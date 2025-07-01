import 'package:finease/db/messages.dart';
import 'package:finease/parts/app_drawer.dart';
import 'package:finease/parts/app_top_bar.dart';
import 'package:finease/parts/input.dart';
import 'package:finease/parts/list.dart';
import 'package:finease/pages/home/frame/destinations.dart';
import 'package:finease/pages/chat/finance_query_service.dart';
import 'package:finease/pages/chat/llm_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final List<Message> messages = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isProcessing = false;
  final LLMService _llmService = LLMService();
  final MessageService _messageService = MessageService();

  @override
  void initState() {
    super.initState();
    _loadMessages();
    // Request focus when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Future<void> _loadMessages() async {
    try {
      final savedMessages = await _messageService.getMessages();
      
      setState(() {
        messages.clear();
        
        if (savedMessages.isEmpty) {
          // If no saved messages, show welcome messages
          messages.addAll([
            Message(
              content: "Hello! I can help you analyze your finances. Try asking about your expenses, income, or savings over a time period.",
              type: MessageType.automated,
            ),
            Message(
              content: "For example: \"How much did I spend last month?\" or \"What was my income in March?\"",
              type: MessageType.automated,
            ),
          ]);
          
          // Save the welcome messages
          for (var message in messages) {
            _messageService.saveMessage(message);
          }
        } else {
          messages.addAll(savedMessages);
        }
      });
    } catch (e) {
      // If there's an error loading messages, show welcome messages
      _loadInitialMessages();
    }
  }

  void _loadInitialMessages() {
    setState(() {
      messages.clear();
      messages.addAll([
        Message(
          content: "Hello! I can help you analyze your finances. Try asking about your expenses, income, or savings over a time period.",
          type: MessageType.automated,
        ),
        Message(
          content: "For example: \"How much did I spend last month?\" or \"What was my income in March?\"",
          type: MessageType.automated,
        ),
      ]);
      
      // Save the welcome messages
      for (var message in messages) {
        _messageService.saveMessage(message);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _processUserQuery(String query) async {
    // Show that we're processing the query
    setState(() {
      _isProcessing = true;
      // Add a temporary processing message
      messages.insert(0, Message(
        content: "Processing your query...",
        type: MessageType.automated,
      ));
    });
    
    try {
      // Step 1: Use LLM to extract intent and parameters
      final llmResponse = await _llmService.processQuery(query);
      
      // Step 2: Get the appropriate function from the registry
      final function = FunctionRegistry.getFunction(llmResponse.requiredFunction);
      
      if (function == null) {
        throw Exception("Could not find function: ${llmResponse.requiredFunction}");
      }
      
      // Step 3: Call the function with the parameters
      final result = await function(llmResponse.intent, llmResponse.parameters);
      
      // Step 4: Generate a human-readable response
      final response = await _llmService.generateResponse(
        llmResponse.intent,
        llmResponse.parameters,
        result,
      );
      
      // Replace the processing message with the actual response
      setState(() {
        messages.removeAt(0); // Remove "Processing" message
        final responseMessage = Message(
          content: response,
          type: MessageType.automated,
        );
        messages.insert(0, responseMessage);
        _isProcessing = false;
        
        // Save the response message
        _messageService.saveMessage(responseMessage);
      });
    } catch (e) {
      // Handle errors
      setState(() {
        messages.removeAt(0); // Remove "Processing" message
        final errorMessage = Message(
          content: "Sorry, I couldn't process your request. ${e.toString()}",
          type: MessageType.automated,
        );
        messages.insert(0, errorMessage);
        _isProcessing = false;
        
        // Save the error message
        _messageService.saveMessage(errorMessage);
      });
    }
  }

  void _sendMessage() {
    if (_controller.text.isEmpty || _isProcessing) return;
    
    final userMessage = _controller.text;
    
    setState(() {
      // Create and add user message
      final userMessageObj = Message(
        content: userMessage,
        type: MessageType.user,
      );
      messages.insert(0, userMessageObj);
      
      _controller.clear();
      
      // Save the user message
      _messageService.saveMessage(userMessageObj);
    });
    
    // Process the query
    _processUserQuery(userMessage);
    
    // Request focus after state update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }
  
  void _clearChat() async {
    // Clear all messages in DB and local state
    await _messageService.clearMessages();
    
    setState(() {
      messages.clear();
    });
    
    // Load initial messages again
    _loadInitialMessages();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
    int destIndex = 4; // Index of chat in destinations list

    void updateBody(int index) {
      setState(() {
        destIndex = index;
      });
      context.goNamed(
        destinations[destIndex].routeName.name,
        extra: () => {},
      );
    }

    return Scaffold(
      key: scaffoldStateKey,
      appBar: AppBar(
        title: const Text("Financial Assistant"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearChat,
            tooltip: 'Clear chat history',
          ),
        ],
      ),
      drawer: AppDrawer(
        onRefresh: () {
          _loadInitialMessages();
        },
        scaffoldKey: scaffoldStateKey,
        selectedIndex: destIndex,
        destinations: destinations,
        onDestinationSelected: updateBody,
      ),
      body: Column(
        children: <Widget>[
          MessagesListView(messages: messages),
          ChatInputArea(
            controller: _controller,
            focusNode: _focusNode,
            isProcessing: _isProcessing,
            onSubmitted: (value) {
              if (value.isNotEmpty && !_isProcessing) {
                _sendMessage();
              }
            },
          ),
        ],
      ),
    );
  }
}
