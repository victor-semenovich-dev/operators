import 'package:flutter/material.dart';
import 'package:operators/src/bloc/table.dart';
import 'package:operators/src/data/model/event.dart';
import 'package:operators/src/data/model/table.dart';
import 'package:operators/src/data/model/user.dart';
import 'package:operators/src/ui/authorization/authorization_provider.dart';
import 'package:operators/src/ui/home/home_bloc.dart';

class TableWidget extends StatelessWidget {
  static const double ROW_HEIGHT = 60;
  static const Color COLOR_GREY = Color(0xFFBDBDBD);

  final HomeState state;
  final TableModel tableModel;
  final TableData? tableData;

  const TableWidget(this.tableModel, this.tableData, this.state);

  @override
  Widget build(BuildContext context) {
    if (tableData == null) {
      return Center(child: CircularProgressIndicator());
    }

    var rows = <Widget>[];
    final dividerWidget =
        Container(width: double.infinity, height: 1, color: Colors.black);
    tableData!.users.forEach((user) {
      rows
        ..add(_userRow(context, user.id))
        ..add(dividerWidget);
    });
    return Column(
      children: [
        dividerWidget,
        _eventsTitlesRow(),
        dividerWidget,
        Expanded(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: SafeArea(
              child: Column(
                children: rows,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _eventsTitlesRow() {
    List<Widget> children = <Widget>[];
    for (int i = 0; i <= tableData!.events.length; i++) {
      if (i == 0) {
        children.add(Expanded(
          flex: 3,
          child: Container(
              color: COLOR_GREY, width: double.infinity, height: ROW_HEIGHT),
        ));
      } else {
        Event event = tableData!.events[i - 1];
        children
            .add(Container(width: 1, height: ROW_HEIGHT, color: Colors.black));
        children.add(Expanded(
          flex: 2,
          child: Container(
            color: COLOR_GREY,
            width: double.infinity,
            height: ROW_HEIGHT,
            padding: EdgeInsets.all(4),
            child: Center(
              child: Text(event.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ));
      }
    }
    return Row(children: children);
  }

  Widget _userRow(BuildContext context, int userId) {
    List<Widget> children = <Widget>[];
    User user = tableData!.getUserById(userId)!;
    for (int i = 0; i <= tableData!.events.length; i++) {
      if (i == 0) {
        children.add(Expanded(
          flex: 3,
          child: Container(
            color: COLOR_GREY,
            width: double.infinity,
            height: ROW_HEIGHT,
            padding: EdgeInsets.all(4),
            child: Center(
              child: Text(user.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ));
      } else {
        Event event = tableData!.events[i - 1];
        children
            .add(Container(width: 1, height: ROW_HEIGHT, color: Colors.black));
        var color = Colors.white;
        if (event.state.containsKey(userId)) {
          if (event.state[userId]!.role == null) {
            if (event.state[userId]?.canHelp == true) {
              color = Colors.green;
            } else if (event.state[userId]?.canHelp == false) {
              color = Colors.red[400]!;
            }
          } else {
            color = Colors.blue;
          }
        }
        children.add(Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                if (!event.state.containsKey(user.id) ||
                    event.state[user.id]?.role == null) {
                  if (!state.isLoggedIn) {
                    showDialog(
                      context: context,
                      builder: (context) => AuthorizationDialogProvider(),
                    );
                  } else if (state.currentFirebaseUser?.uid == user.uid) {
                    tableModel.toggleCanHelp(user, event);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Можно отмечаться только в своих ячейках',
                      ),
                    ));
                  }
                }
              },
              child: Container(
                color: color,
                width: double.infinity,
                height: ROW_HEIGHT,
                child: _getChildWidget(user, event),
              ),
            )));
      }
    }
    return Row(children: children);
  }

  Widget _getChildWidget(User user, Event event) {
    if (event.state.containsKey(user.id) &&
        event.state[user.id]?.role != null) {
      switch (event.state[user.id]?.role) {
        case Role.PC:
          return Icon(Icons.computer, size: 48);
        case Role.CAMERA:
          return Icon(Icons.videocam_outlined, size: 48);
        default:
          return Container();
      }
    } else {
      return Container();
    }
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
