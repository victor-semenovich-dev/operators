import 'package:flutter/material.dart';
import 'package:operators/src/bloc/table.dart';
import 'package:operators/src/data/event.dart';
import 'package:operators/src/data/table.dart';
import 'package:operators/src/data/user.dart';

class TableWidget extends StatelessWidget {

  static const double ROW_HEIGHT = 60;
  static const Color COLOR_GREY = Color(0xFFBDBDBD);

  final TableBloc tableBloc;
  final TableData tableData;

  const TableWidget(this.tableBloc, this.tableData);

  @override
  Widget build(BuildContext context) {
    if (tableData == null) {
      return Center(
        child: CircularProgressIndicator()
      );
    }

    var rows = <Widget>[];
    rows..add(
        Container(width: double.infinity, height: 1, color: Colors.black)
    )..add(_eventsTitlesRow());
    tableData.users.forEach((user) {
      rows..add(
        Container(width: double.infinity, height: 1, color: Colors.black)
      )..add(_userRow(user.id));
    });
    rows.add(
        Container(width: double.infinity, height: 1, color: Colors.black)
    );
    return SingleChildScrollView(
      child: Column(
        children: rows,
      ),
    );
  }

  Widget _eventsTitlesRow() {
    List<Widget> children = <Widget>[];
    for (int i = 0; i <= tableData.events.length; i++) {
      if (i == 0) {
        children.add(Expanded(flex: 1,
          child: Container(color: COLOR_GREY, width: double.infinity, height: ROW_HEIGHT),
        ));
      } else {
        Event event = tableData.events[i - 1];
        children.add(Container(width: 1, height: ROW_HEIGHT, color: Colors.black));
        children.add(Expanded(flex: 1,
          child: Container(
            color: COLOR_GREY,
            width: double.infinity,
            height: ROW_HEIGHT,
            padding: EdgeInsets.all(4),
            child: Center(
              child: Text(event.title, textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ));
      }
    }
    return Row(children: children);
  }

  Widget _userRow(int userId) {
    List<Widget> children = <Widget>[];
    User user = tableData.getUserById(userId);
    for (int i = 0; i <= tableData.events.length; i++) {
      if (i == 0) {
        children.add(Expanded(flex: 1,
          child: Container(
            color: COLOR_GREY,
            width: double.infinity,
            height: ROW_HEIGHT,
            padding: EdgeInsets.all(4),
            child: Center(
              child: Text(user.name, textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ));
      } else {
        Event event = tableData.events[i - 1];
        children.add(Container(width: 1, height: ROW_HEIGHT, color: Colors.black));
        var color = Colors.white;
        if (event.participation.containsKey(userId)) {
          if (event.participation[userId])
            color = Colors.green;
          else
            color = Colors.red[400];
        }
        children.add(Expanded(flex: 1,
          child: GestureDetector(
            onTap: () => tableBloc.toggleValue(user, event),
            onLongPress: () => tableBloc.clearValue(user, event),
            child: Container(
                color: color,
                width: double.infinity,
                height: ROW_HEIGHT
            ),
          ),
        ));
      }
    }
    return Row(children: children);
  }
}