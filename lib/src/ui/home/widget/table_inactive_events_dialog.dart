import 'package:flutter/material.dart';
import 'package:operators/src/data/model/event.dart';

class TableInactiveEventsDialog extends StatefulWidget {
  final List<TableEvent> allEvents;
  final List<TableEvent> visibleEvents;
  final Function(List<TableEvent>) applyForcedVisibleEvents;

  const TableInactiveEventsDialog({
    super.key,
    required this.allEvents,
    required this.visibleEvents,
    required this.applyForcedVisibleEvents,
  });

  @override
  State<TableInactiveEventsDialog> createState() =>
      _TableInactiveEventsDialogState();
}

class _TableInactiveEventsDialogState extends State<TableInactiveEventsDialog> {
  late List<TableEvent> _visibleEvents;

  @override
  void initState() {
    super.initState();
    _visibleEvents = widget.visibleEvents;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Неактивные события'),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: double.maxFinite,
        child: Scrollbar(
          child: ListView.builder(
            itemCount: widget.allEvents.length,
            itemBuilder: (context, i) {
              TableEvent event = widget.allEvents[i];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 24),
                leading: Image(
                  image: AssetImage(_visibleEvents.contains(event)
                      ? 'icons/ic_eye_opened.png'
                      : 'icons/ic_eye_closed.png'),
                  width: 24,
                  height: 24,
                ),
                title: Text(event.title),
                onTap: () {
                  setState(() {
                    if (_visibleEvents.contains(event)) {
                      _visibleEvents.remove(event);
                    } else {
                      _visibleEvents.add(event);
                    }
                  });
                },
              );
            },
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Отмена'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Скрыть все'),
          onPressed: () {
            widget.applyForcedVisibleEvents([]);
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            widget.applyForcedVisibleEvents(_visibleEvents);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
