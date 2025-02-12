import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:operators/src/data/model/event.dart';
import 'package:operators/src/data/model/table.dart';
import 'package:operators/src/data/model/user.dart';
import 'package:operators/src/ui/authorization/authorization_provider.dart';
import 'package:operators/src/ui/home/home_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class TableWidget extends StatelessWidget {
  static const double ROW_HEIGHT = 60;
  static const Color COLOR_GREY = Color(0xFFBDBDBD);

  final HomeState state;
  final Function(TableUser user, TableEvent event) onToggleCanHelp;
  final Function(TableUser user, TableEvent event, Role? role) onRoleSelected;
  final Function(TableUser user, TableEvent event, bool? canHelp)
      onCanHelpSelected;
  final Function(TableEvent event) onAppointClick;
  final Function(TableEvent event) onCancelAppointmentsClick;
  final Function(TableEvent event) onNotificationClick;
  final Function(TableEvent event) onRemindClick;
  final Function(TableEvent event) onRefreshClick;
  final Function(TableEvent event) onEditClick;
  final Function(TableEvent event) onHideClick;
  final Function(TableEvent event) onDeleteClick;

  const TableWidget({
    required this.state,
    required this.onToggleCanHelp,
    required this.onRoleSelected,
    required this.onCanHelpSelected,
    required this.onAppointClick,
    required this.onCancelAppointmentsClick,
    required this.onNotificationClick,
    required this.onRemindClick,
    required this.onRefreshClick,
    required this.onEditClick,
    required this.onHideClick,
    required this.onDeleteClick,
  });

  @override
  Widget build(BuildContext context) {
    final tableData = state.tableData;
    if (tableData == null) {
      return Center(child: CircularProgressIndicator());
    }

    var rows = <Widget>[];
    final dividerWidget =
        Container(width: double.infinity, height: 1, color: Colors.black);
    final users =
        state.showAllUsers ? state.sortedAllUsers : state.sortedTableUsers;
    users.forEach((user) {
      rows
        ..add(_userRow(context, tableData, user))
        ..add(dividerWidget);
    });
    return Column(
      children: [
        dividerWidget,
        _eventsTitlesRow(context, tableData),
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

  Widget _eventsTitlesRow(BuildContext context, TableData tableData) {
    List<Widget> children = <Widget>[];
    for (int i = 0; i <= tableData.events.length; i++) {
      if (i == 0) {
        children.add(Expanded(
          flex: 3,
          child: Container(
            color: COLOR_GREY,
            width: double.infinity,
            height: ROW_HEIGHT,
            child: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final packageInfo = snapshot.data;
                if (packageInfo != null) {
                  return Center(
                    child: Text(
                      'v${packageInfo.version} (${packageInfo.buildNumber})',
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ));
      } else {
        TableEvent event = tableData.events[i - 1];
        children
            .add(Container(width: 1, height: ROW_HEIGHT, color: Colors.black));
        final baseWidget = Container(
          color: COLOR_GREY,
          width: double.infinity,
          height: ROW_HEIGHT,
          padding: EdgeInsets.all(4),
          child: Center(
            child: Text(
              event.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: event.isActive ? Colors.black : Colors.black38,
              ),
            ),
          ),
        );
        children.add(
          Expanded(
              flex: 2,
              child: state.isAdmin
                  ? FocusedMenuHolder(
                      child: baseWidget,
                      onPressed: () {},
                      menuItems: [
                        FocusedMenuItem(
                          title: Text('Назначить операторов'),
                          onPressed: () => onAppointClick(event),
                        ),
                        FocusedMenuItem(
                          title: Text('Отменить назначение'),
                          onPressed: () => onCancelAppointmentsClick(event),
                        ),
                        FocusedMenuItem(
                          title: Text('Уведомление: участие'),
                          onPressed: () => onNotificationClick(event),
                        ),
                        FocusedMenuItem(
                          title: Text('Напоминание: отметки'),
                          onPressed: () => onRemindClick(event),
                        ),
                        FocusedMenuItem(
                          title: Text('Обновить таблицу'),
                          onPressed: () => onRefreshClick(event),
                        ),
                        FocusedMenuItem(
                          title: Text('Редактировать'),
                          onPressed: () => onEditClick(event),
                        ),
                        FocusedMenuItem(
                          title: Text('Скрыть'),
                          onPressed: () => onHideClick(event),
                        ),
                        FocusedMenuItem(
                          title: Text('Удалить'),
                          onPressed: () => onDeleteClick(event),
                        ),
                      ],
                      menuWidth: MediaQuery.of(context).size.width * 0.50,
                    )
                  : baseWidget),
        );
      }
    }
    return Row(children: children);
  }

  Widget _userRow(BuildContext context, TableData tableData, TableUser user) {
    List<Widget> children = <Widget>[];
    List<Rating> rating = context.read<HomeCubit>().getRating(user);
    Rating? pcRating = rating.firstWhereOrNull((r) => r.role == Role.PC);
    Rating? cameraRating =
        rating.firstWhereOrNull((r) => r.role == Role.CAMERA);
    for (int i = 0; i <= tableData.events.length; i++) {
      if (i == 0) {
        children.add(Expanded(
          flex: 3,
          child: Container(
            color: COLOR_GREY,
            width: double.infinity,
            height: ROW_HEIGHT,
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      user.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: user.isActive ? Colors.black : Colors.black38,
                      ),
                    ),
                  ),
                ),
                if (user.roles.contains(Role.PC))
                  Align(
                    alignment: Alignment.topLeft,
                    child: roleToWidget(Role.PC, 4, 0),
                  ),
                if (pcRating != null)
                  Align(
                    alignment: Alignment.topRight,
                    child: _ratingWidget(pcRating),
                  ),
                if (user.roles.contains(Role.CAMERA))
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: roleToWidget(Role.CAMERA, 4, 0),
                  ),
                if (cameraRating != null)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: _ratingWidget(cameraRating),
                  ),
              ],
            ),
          ),
        ));
      } else {
        TableEvent event = tableData.events[i - 1];
        children
            .add(Container(width: 1, height: ROW_HEIGHT, color: Colors.black));
        var color = Colors.white;
        if (event.state.containsKey(user.id)) {
          if (event.state[user.id]?.role == null) {
            if (event.state[user.id]?.canHelp == true) {
              color = Colors.green;
            } else if (event.state[user.id]?.canHelp == false) {
              color = Colors.red[400]!;
            }
          } else {
            color = Colors.blue;
          }
        }
        final itemWidget = GestureDetector(
          onTap: () {
            if (!state.isLoggedIn) {
              showDialog(
                context: context,
                builder: (context) => AuthorizationDialogProvider(),
              );
            } else if (state.currentFirebaseUser?.uid == user.uid) {
              if (event.state[user.id]?.role != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Нельзя изменить отметку после назначения',
                  ),
                ));
              } else {
                onToggleCanHelp(user, event);
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Можно отмечаться только в своих ячейках',
                ),
              ));
            }
          },
          child: Container(
            color: color,
            width: double.infinity,
            height: ROW_HEIGHT,
            child: _getChildWidget(context, user, event, state.isAdmin),
          ),
        );
        children.add(
          Expanded(
            flex: 2,
            child: state.isAdmin
                ? FocusedMenuHolder(
                    menuWidth: MediaQuery.of(context).size.width * 0.50,
                    menuItems: [
                      if (event.state[user.id]?.canHelp == true)
                        FocusedMenuItem(
                          title: Text('Роль: компьютер'),
                          onPressed: () => onRoleSelected(user, event, Role.PC),
                        ),
                      if (event.state[user.id]?.canHelp == true)
                        FocusedMenuItem(
                          title: Text('Роль: камера'),
                          onPressed: () =>
                              onRoleSelected(user, event, Role.CAMERA),
                        ),
                      if (event.state[user.id]?.canHelp == true)
                        FocusedMenuItem(
                          title: Text('Роль: ничего'),
                          onPressed: () => onRoleSelected(user, event, null),
                        ),
                      if (event.state[user.id]?.role == null)
                        FocusedMenuItem(
                          title: Text('Отметка: зелёный'),
                          onPressed: () => onCanHelpSelected(user, event, true),
                        ),
                      if (event.state[user.id]?.role == null)
                        FocusedMenuItem(
                          title: Text('Отметка: красный'),
                          onPressed: () =>
                              onCanHelpSelected(user, event, false),
                        ),
                      if (event.state[user.id]?.role == null)
                        FocusedMenuItem(
                          title: Text('Отметка: ничего'),
                          onPressed: () => onCanHelpSelected(user, event, null),
                        ),
                    ],
                    onPressed: () {},
                    child: itemWidget,
                  )
                : itemWidget,
          ),
        );
      }
    }
    return Row(children: children);
  }

  Widget _getChildWidget(
      BuildContext context, TableUser user, TableEvent event, bool isAdmin) {
    if (event.state[user.id]?.role == null) {
      final canHelpDateTime = event.state[user.id]?.canHelpDateTime;
      return canHelpDateTime == null || !isAdmin
          ? Container()
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  DateFormat('dd.MM HH:mm').format(canHelpDateTime),
                  textAlign: TextAlign.center,
                ),
              ),
            );
    }

    if (event.state[user.id]?.role != null) {
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

  Widget _ratingWidget(Rating rating) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Text(
        rating.toString(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
