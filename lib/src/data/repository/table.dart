import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:operators/src/data/model/event.dart';
import 'package:operators/src/data/model/table.dart';
import 'package:operators/src/data/model/user.dart';
import 'package:rxdart/rxdart.dart';

class TableRepository {
  static const baseUrl = '/';

  late DatabaseReference _dbRef;
  final _tableSubject = BehaviorSubject<TableData>();
  late Stream<TableData> tableStream = _tableSubject.stream;

  final _eventsSubject = BehaviorSubject<List<TableEvent>>();
  late Stream<List<TableEvent>> eventsStream = _eventsSubject.stream;

  final _usersSubject = BehaviorSubject<List<TableUser>>();
  late Stream<List<TableUser>> usersStream = _usersSubject.stream;

  static DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  TableRepository() {
    _dbRef = FirebaseDatabase.instance.ref(baseUrl);

    _dbRef.onValue.listen((event) {
      final snapshot = event.snapshot;
      final eventsData = snapshot.child('events').value;
      final usersData = snapshot.child('users').value;

      final allUsers = <TableUser>[];
      final allEvents = <TableEvent>[];

      _parseSnapshotData(
        data: usersData,
        preParseCondition: (id, map) => true,
        parseItem: (id, map) => _parseUser(id, map),
        processItem: (id, user) => allUsers.add(user),
      );

      _parseSnapshotData(
        data: eventsData,
        preParseCondition: (id, map) => true,
        parseItem: (id, map) => _parseEvent(id, map),
        processItem: (id, item) => allEvents.add(item),
      );

      final events = allEvents.where((event) => event.isActive).toList();
      events.sort((e1, e2) => e1.date.compareTo(e2.date));

      final users = allUsers.where((user) => user.isActive).toList();
      users.sort((u1, u2) => u1.name.compareTo(u2.name));

      _tableSubject.add(TableData(events: events, users: users));
      _eventsSubject.add(allEvents);
      _usersSubject.add(allUsers);
    });
  }

  void toggleCanHelp(TableUser user, TableEvent event) {
    var newValue;
    if (event.state.containsKey(user.id)) {
      if (event.state[user.id]?.canHelp == true) {
        newValue = false;
      } else {
        newValue = null;
      }
    } else {
      newValue = true;
    }
    _dbRef.child('events/${event.id}/state/${user.id}/canHelp').set(newValue);
  }

  void setRole(TableUser user, TableEvent event, Role? role) {
    _dbRef
        .child('events/${event.id}/state/${user.id}/role')
        .set(roleToString(role));
  }

  void setCanHelp(TableUser user, TableEvent event, bool? canHelp) {
    _dbRef.child('events/${event.id}/state/${user.id}/canHelp').set(canHelp);
  }

  Future<void> addOrUpdateEvent(DateTime date, String title) async {
    final tableEvents = await eventsStream.first;
    int maxId = 0;
    for (final event in tableEvents) {
      if (event.id == 449) {
        debugPrint('449');
      }
      if (event.date == date) {
        await updateEvent(event.id, title, true);
        return;
      }
      if (event.id > maxId) {
        maxId = event.id;
      }
    }
    final id = maxId + 1;

    await _dbRef.child('events/$id').set({
      'date': _dateFormat.format(date),
      'title': title,
      'isActive': true,
    });
  }

  Future<void> updateEvent(int id, String title, bool isActive) async {
    await _dbRef.child('events/$id/title').set(title);
    await _dbRef.child('events/$id/isActive').set(isActive);
  }

  Future<void> deleteEvent(int eventId) {
    return _dbRef.child('events/$eventId').remove();
  }

  static TableUser _parseUser(int id, Map userData) {
    String name = userData['name'];
    String? uid = userData['uid'];
    bool isActive = userData['isActive'] != false;
    return TableUser(id: id, name: name, uid: uid, isActive: isActive);
  }

  static TableEvent _parseEvent(int id, Map eventData) {
    String title = eventData['title'];
    DateTime date = _dateFormat.parse(eventData['date']);
    bool isActive = eventData['isActive'] != false;
    Map<int, EventUserState> state = {};

    if (eventData.containsKey('state')) {
      _parseSnapshotData(
        data: eventData['state'],
        parseItem: (id, map) => _parseEventUserState(map),
        processItem: (id, item) => state[id] = item,
      );
    }
    return TableEvent(
        id: id, title: title, date: date, isActive: isActive, state: state);
  }

  static EventUserState _parseEventUserState(Map data) {
    return EventUserState(
      canHelp: data['canHelp'],
      role: stringToRole(data['role']),
    );
  }

  // --------------------------------------------------------------------------

  static void _parseSnapshotData({
    dynamic data,
    bool Function(int, Map)? preParseCondition,
    required dynamic Function(int, Map) parseItem,
    required Function(int, dynamic) processItem,
  }) {
    try {
      if (data is List) {
        for (int i = 0; i < data.length; i++) {
          if (data[i] != null) {
            _parseSnapshotItem(
                i, data[i], parseItem, processItem, preParseCondition);
          }
        }
      } else if (data is Map) {
        for (String key in data.keys) {
          int id = int.parse(key);
          _parseSnapshotItem(
              id, data[key], parseItem, processItem, preParseCondition);
        }
      }
    } catch (e, stacktrace) {
      print('$e: $stacktrace');
    }
  }

  static void _parseSnapshotItem(
    int id,
    Map data,
    dynamic Function(int, Map) parseItem,
    Function(int, dynamic) processItem,
    bool Function(int, Map)? preParseCondition,
  ) {
    try {
      if (preParseCondition == null || preParseCondition(id, data)) {
        final item = parseItem(id, data);
        processItem(id, item);
      }
    } catch (e, stacktrace) {
      print('$e: $stacktrace');
    }
  }
}
