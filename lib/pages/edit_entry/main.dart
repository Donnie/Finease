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
    setState(() {
      _entry = entry!;
      _entryDate = entry.date;
      _creditAccount = entry.creditAccount;
      _debitAccount = entry.debitAccount;
      _entryNotes.text = entry.notes ?? '';
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
      _entry!.date = _entryDate ?? _entry!.date;
      _entry!.notes = entryNotes;
      await _entryService.updateEntry(_entry!);
      widget.onFormSubmitted();
    }
  }
}

