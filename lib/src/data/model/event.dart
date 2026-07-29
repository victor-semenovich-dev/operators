import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Event {
  final int id;
  final String title;
  final DateTime date;

  Event(this.id, this.title, this.date);

  @override
  String toString() {
    return 'Event{id: $id, title: $title, date: $date}';
  }
}

class TableEvent {
  final int id;
  final String title;
  final DateTime date;
  final bool isActive;
  final Map<int, EventUserState> state;
  final Map<Role, int>? required;

  const TableEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.isActive,
    required this.state,
    this.required,
  });

  @override
  String toString() {
    return 'TableEvent{id: $id, title: $title, date: $date, isActive: $isActive, state: $state, required: $required}';
  }
}

class ScheduleItem {
  final int day;
  final String time;
  final String title;
  final Map<Role, int>? required;

  const ScheduleItem({
    required this.day,
    required this.time,
    required this.title,
    this.required,
  });

  @override
  String toString() {
    return 'ScheduleItem{day: $day, time: $time, title: $title, required: $required}';
  }

  TableEvent toTableEvent(int id, DateTime now) {
    DateTime date = DateTime(now.year, now.month, now.day);
    List<String> timeParts = time.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    date = date.add(Duration(hours: hour, minutes: minute));

    int targetWeekday = day == 0 ? 7 : day;
    int daysToAdd = (targetWeekday - date.weekday + 7) % 7;

    if (daysToAdd == 0 && date.isBefore(now)) {
      daysToAdd = 7;
    }
    date = date.add(Duration(days: daysToAdd));

    final titlePrefix = DateFormat('dd.MM').format(date);
    final fullTitle = '$titlePrefix ($title)';

    final isActive =
        date.isAfter(now) && date.isBefore(now.add(const Duration(days: 7)));

    return TableEvent(
      id: id,
      title: fullTitle,
      date: date,
      isActive: isActive,
      state: {},
      required: required,
    );
  }
}

class EventUserState {
  final bool canHelp;
  final Role? role;
  final DateTime? canHelpDateTime;
  final DateTime? roleDateTime;

  const EventUserState({
    required this.canHelp,
    required this.role,
    required this.canHelpDateTime,
    required this.roleDateTime,
  });
}

enum Role { PC, VIDEO_MIXER, CAMERA }

Role? stringToRole(String? str) {
  switch (str) {
    case 'pc':
      return Role.PC;
    case 'camera':
      return Role.CAMERA;
    case 'videoMixer':
      return Role.VIDEO_MIXER;
    default:
      return null;
  }
}

String? roleToString(Role? role) {
  switch (role) {
    case Role.PC:
      return 'pc';
    case Role.CAMERA:
      return 'camera';
    case Role.VIDEO_MIXER:
      return 'videoMixer';
    default:
      return null;
  }
}

Widget roleToWidget(Role role, double leftPadding, double rightPadding) {
  switch (role) {
    case Role.PC:
      return Padding(
        padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
        child: Icon(Icons.computer, size: 16),
      );
    case Role.CAMERA:
      return Padding(
        padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
        child: Icon(Icons.videocam_outlined, size: 16),
      );
    default:
      return Container();
  }
}

String? roleToReadableString(Role? role) {
  switch (role) {
    case Role.PC:
      return 'компьютер';
    case Role.CAMERA:
      return 'камера';
    case Role.VIDEO_MIXER:
      return 'видеопульт';
    default:
      return null;
  }
}
