import 'package:finease/core/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DateTimePicker extends StatefulWidget {
  final DateTime? dateTime;
  final Function(DateTime) onDateTimeChanged;

  const DateTimePicker({
    super.key,
    this.dateTime,
    required this.onDateTimeChanged,
  });

  @override
  DateTimePickerState createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePicker> {
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.dateTime ?? DateTime.now();
  }

  void _pickDateTime() async {
    final DateTime? pickedDateNullable = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    final DateTime pickedDate = pickedDateNullable ?? selectedDateTime;

    // ignore: use_build_context_synchronously
    final TimeOfDay? pickedTimeNullable = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );
    final TimeOfDay pickedTime =
        pickedTimeNullable ?? TimeOfDay.fromDateTime(selectedDateTime);

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
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16,
            ),
            child: Row(
              children: [
                Icon(MdiIcons.calendar),
                const SizedBox(width: 16),
                Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime),
                  style: context.bodyLarge,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
