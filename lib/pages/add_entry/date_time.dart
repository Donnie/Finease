import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  final Function(DateTime) onDateTimeChanged;

  const DateTimePicker({Key? key, required this.onDateTimeChanged}) : super(key: key);

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime? selectedDateTime;

  void _pickDateTime() async {
    final localContext = context;

    // Pick date
    final DateTime? pickedDate = await showDatePicker(
      context: localContext,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate == null) return;

    // Pick time
    final TimeOfDay? pickedTime = await showTimePicker(
      context: localContext,
      initialTime: selectedDateTime != null ? TimeOfDay.fromDateTime(selectedDateTime!) : TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    // Combine date and time into a single DateTime object
    final combinedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Update state and notify the parent widget
    setState(() {
      selectedDateTime = combinedDateTime;
    });
    widget.onDateTimeChanged(combinedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: _pickDateTime,
          child: Text(selectedDateTime == null
              ? 'Select Date and Time'
              : 'Selected: ${DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!)}'),
        ),
        if (selectedDateTime != null)
          Text(
            'Selected: ${DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
      ],
    );
  }
}
