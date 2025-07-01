import 'dart:convert';
import 'package:finease/pages/chat/finance_query_service.dart';

/// A service to interact with an external LLM API
/// This is a placeholder implementation that will be replaced with
/// an actual API call to an LLM service like OpenAI.
class LLMService {
  /// Process a user query to extract financial information
  /// Returns a structured response that can be used by the app
  Future<LLMResponse> processQuery(String query) async {
    // In a real implementation, this would call an external API
    // For now, we'll simulate the response with our existing rule-based system
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
    
    // Use our rule-based intent and timeRange extraction as a placeholder
    final queryService = FinanceQueryService();
    final intent = queryService.extractIntent(query);
    final timeRange = queryService.extractTimeRange(query);
    
    // Construct a response that mimics what we'd get from an LLM
    return LLMResponse(
      intent: _intentToString(intent),
      parameters: {
        'timeRangeStart': timeRange.startDate.toIso8601String(),
        'timeRangeEnd': timeRange.endDate.toIso8601String(),
        'timeRangeDescription': timeRange.description,
      },
      requiredFunction: 'getFinancialData',
      confidence: 0.9,
    );
  }
  
  /// Generate a response based on financial data
  /// This would normally use the LLM to format the response nicely
  Future<String> generateResponse(
    String intent, 
    Map<String, dynamic> parameters, 
    FinanceQueryResult data
  ) async {
    // For now, delegate to our existing formatter
    final queryService = FinanceQueryService();
    final intentEnum = _stringToIntent(intent);
    final timeRange = TimeRange(
      startDate: DateTime.parse(parameters['timeRangeStart']),
      endDate: DateTime.parse(parameters['timeRangeEnd']),
      description: parameters['timeRangeDescription'],
    );
    
    return queryService.formatQueryResult(intentEnum, timeRange, data);
  }
  
  // Helper method to convert QueryIntent to String
  String _intentToString(QueryIntent intent) {
    switch (intent) {
      case QueryIntent.expenses:
        return 'expenses';
      case QueryIntent.income:
        return 'income';
      case QueryIntent.savings:
        return 'savings';
      case QueryIntent.balance:
        return 'balance';
      case QueryIntent.unknown:
        return 'unknown';
      default:
        return 'unknown';
    }
  }
  
  // Helper method to convert String to QueryIntent
  QueryIntent _stringToIntent(String intent) {
    switch (intent) {
      case 'expenses':
        return QueryIntent.expenses;
      case 'income':
        return QueryIntent.income;
      case 'savings':
        return QueryIntent.savings;
      case 'balance':
        return QueryIntent.balance;
      case 'unknown':
      default:
        return QueryIntent.unknown;
    }
  }
}

/// Represents a structured response from the LLM
class LLMResponse {
  final String intent;
  final Map<String, dynamic> parameters;
  final String requiredFunction;
  final double confidence;
  
  const LLMResponse({
    required this.intent,
    required this.parameters,
    required this.requiredFunction,
    required this.confidence,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'intent': intent,
      'parameters': parameters,
      'requiredFunction': requiredFunction,
      'confidence': confidence,
    };
  }
  
  factory LLMResponse.fromJson(Map<String, dynamic> json) {
    return LLMResponse(
      intent: json['intent'],
      parameters: json['parameters'],
      requiredFunction: json['requiredFunction'],
      confidence: json['confidence'],
    );
  }
}

/// Function registry to map function names to actual implementations
class FunctionRegistry {
  static final Map<String, Function> _functions = {
    'getFinancialData': getFinancialData,
  };
  
  /// Get a function by name
  static Function? getFunction(String name) {
    return _functions[name];
  }
  
  /// Example function to get financial data
  static Future<FinanceQueryResult> getFinancialData(
    String intent, 
    Map<String, dynamic> parameters
  ) async {
    // This would normally call the actual database functions
    // For now, return mock data based on the intent
    final intentEnum = _stringToIntent(intent);
    
    switch (intentEnum) {
      case QueryIntent.expenses:
        return FinanceQueryResult(
          amount: 1250.75,
          currency: 'USD',
          breakdown: {
            'Housing': 750.0,
            'Food': 320.0,
            'Transportation': 100.0,
            'Other': 80.75,
          },
        );
      
      case QueryIntent.income:
        return FinanceQueryResult(
          amount: 3200.0,
          currency: 'USD',
          breakdown: {
            'Salary': 3000.0,
            'Interest': 200.0,
          },
        );
      
      case QueryIntent.savings:
        return FinanceQueryResult(
          amount: 800.0,
          currency: 'USD',
          additionalInfo: '25% savings rate',
        );
        
      case QueryIntent.balance:
      case QueryIntent.unknown:
      default:
        return FinanceQueryResult(
          amount: 12500.0,
          currency: 'USD',
          additionalInfo: 'Total assets across all accounts',
        );
    }
  }
  
  // Helper method to convert String to QueryIntent
  static QueryIntent _stringToIntent(String intent) {
    switch (intent) {
      case 'expenses':
        return QueryIntent.expenses;
      case 'income':
        return QueryIntent.income;
      case 'savings':
        return QueryIntent.savings;
      case 'balance':
        return QueryIntent.balance;
      case 'unknown':
      default:
        return QueryIntent.unknown;
    }
  }
} 
