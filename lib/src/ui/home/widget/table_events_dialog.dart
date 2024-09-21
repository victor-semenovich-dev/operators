import 'package:flutter/material.dart';
import 'package:operators/src/data/model/event.dart';

class TableEventsDialog extends StatelessWidget {
  final String title;
  final List<TableEvent> events;

  const TableEventsDialog({
    super.key,
    required this.title,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Container(
        width: double.maxFinite,
        child: Scrollbar(
          child: ListView.separated(
            itemCount: events.length,
            itemBuilder: (context, i) {
              TableEvent event = events[i];
              return Text(event.title);
            },
            separatorBuilder: (context, i) {
              return SizedBox(height: 16);
            },
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
