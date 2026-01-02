import 'package:finease/db/accounts.dart';
import 'package:finease/db/entries.dart';
import 'package:finease/pages/edit_entry/entry_body.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditEntryScreen extends StatefulWidget {
  final Function() onFormSubmitted;
  final int entryID;

  const EditEntryScreen({
    super.key,
    required this.entryID,
    required this.onFormSubmitted,
  });

  @override
  EditEntryScreenState createState() => EditEntryScreenState();
}

class EditEntryScreenState extends State<EditEntryScreen> {
  final EntryService _entryService = EntryService();

  final _formState = GlobalKey<FormState>();
  final _entryNotes = TextEditingController();
  Entry? _entry;
  DateTime? _entryDate;
  Account? _creditAccount;
  Account? _debitAccount;

  @override
  void initState() {
    super.initState();
    loadEntry(widget.entryID);
  }

  Future<void> loadEntry(int id) async {
    Entry? entry = await _entryService.getEntry(id);
    if (entry == null) return;
    
    // For forex transactions, get the credit entry's notes (user's actual notes)
    String? displayNotes = entry.notes;
    if (_entryService.isForexPairEntry(entry)) {
      final allEntries = await _entryService.getAllEntries();
      final pairedEntry = await _entryService.findForexPairEntry(entry, allEntries);
      
      if (pairedEntry != null) {
        // Determine which is the credit entry (the one with user notes)
        final isDebitSide = _entryService.isForexAccount(entry.creditAccount);
        final isCreditSide = _entryService.isForexAccount(entry.debitAccount);
        
        if (isDebitSide) {
          // This entry is debit side, paired entry is credit side (has user notes)
          displayNotes = pairedEntry.notes;
        } else if (isCreditSide) {
          // This entry is credit side (has user notes)
          displayNotes = entry.notes;
        }
      }
    }
    
    setState(() {
      _entry = entry;
      _entryDate = entry.date;
      _creditAccount = entry.creditAccount;
      _debitAccount = entry.debitAccount;
      _entryNotes.text = displayNotes ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_entry == null) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Transaction')),
      body: EditEntryBody(
        creditAccount: _creditAccount!,
        dateTime: _entryDate!,
        debitAccount: _debitAccount!,
        entryAmount: _entry!.amount.toString(),
        entryNotes: _entryNotes,
        formState: _formState,
        onDateTimeChanged: _onDateTimeChanged,
      ),
      // body: const Card(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppBigButton(
            onPressed: _submitForm,
            title: "Save",
          ),
        ),
      ),
    );
  }

  void _onDateTimeChanged(DateTime dateTime) {
    setState(() {
      _entryDate = dateTime;
    });
  }

  Future<void> _submitForm() async {
    String entryNotes = _entryNotes.text;
    if (_formState.currentState?.validate() ?? false) {
      context.pop();
      
      final newDate = _entryDate ?? _entry!.date ?? DateTime.now();
      
      // For forex transactions, update the credit entry's notes and sync dates on both entries
      if (_entryService.isForexPairEntry(_entry!)) {
        final allEntries = await _entryService.getAllEntries();
        final pairedEntry = await _entryService.findForexPairEntry(_entry!, allEntries);
        
        if (pairedEntry != null) {
          final isDebitSide = _entryService.isForexAccount(_entry!.creditAccount);
          final isCreditSide = _entryService.isForexAccount(_entry!.debitAccount);
          
          Entry debitEntry, creditEntry;
          if (isDebitSide) {
            // Loaded entry is debit side
            debitEntry = _entry!;
            creditEntry = pairedEntry;
          } else if (isCreditSide) {
            // Loaded entry is credit side
            debitEntry = pairedEntry;
            creditEntry = _entry!;
          } else {
            // Fallback: treat current entry as debit
            debitEntry = _entry!;
            creditEntry = pairedEntry;
          }
          
          // Update both entries' dates and only credit entry's notes
          await _entryService.updateForexPair(
            debitEntry: debitEntry,
            creditEntry: creditEntry,
            date: newDate,
            creditNotes: entryNotes,
          );
        } else {
          // Fallback: update the current entry
          _entry!.date = newDate;
          _entry!.notes = entryNotes;
          await _entryService.updateEntry(_entry!);
        }
      } else {
        // Regular entry
        _entry!.date = newDate;
        _entry!.notes = entryNotes;
        await _entryService.updateEntry(_entry!);
      }
      
      widget.onFormSubmitted();
    }
  }
}

