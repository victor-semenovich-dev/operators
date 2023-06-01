import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEditEventDialog extends StatefulWidget {
  final DateTime? initialDateTime;
  final String? initialTitle;
  final Function(DateTime dateTime, String title) onConfirmClick;

  const AddEditEventDialog({
    Key? key,
    this.initialDateTime,
    this.initialTitle,
    required this.onConfirmClick,
  }) : super(key: key);

  @override
  State<AddEditEventDialog> createState() => _AddEditEventDialogState();
}

class _AddEditEventDialogState extends State<AddEditEventDialog> {
  final DateFormat _dateFormat = DateFormat('dd.MM (EE)', 'ru');

  late DateTime _dateTime;

  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _dateTime = widget.initialDateTime ?? DateTime.now();
      _titleController.text = _buildTitle();
    });
  }

  String _buildTitle() {
    return '${DateFormat('dd.MM').format(_dateTime)} (${DateFormat('EE', 'ru').format(_dateTime).toUpperCase()})';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilledButton(
                onPressed: () async {
                  final result = await showDatePicker(
                    context: context,
                    initialDate: _dateTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 90)),
                    locale: Locale('ru'),
                  );
                  if (result != null) {
                    setState(() {
                      _dateTime = _dateTime.copyWith(
                          year: result.year,
                          month: result.month,
                          day: result.day);
                      _titleController.text = _buildTitle();
                    });
                  }
                },
                child: Text(DateFormat('dd MMMM', 'ru').format(_dateTime)),
              ),
              FilledButton(
                onPressed: () async {
                  final result = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_dateTime),
                  );
                  if (result != null) {
                    setState(() {
                      _dateTime = _dateTime.copyWith(
                          hour: result.hour, minute: result.minute);
                    });
                  }
                },
                child: Text(DateFormat('HH:mm', 'ru').format(_dateTime)),
              ),
            ],
          ),
          TextField(controller: _titleController),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Отмена'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Применить'),
          onPressed: () {
            widget.onConfirmClick(_dateTime, _titleController.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

enum TitleSuffix { MORNING, EVENING, NONE }
