import 'dart:async';

import 'package:firebase/firebase.dart' as firebase;
import 'package:intl/intl.dart';
import 'package:operators/src/data/event.dart';
import 'package:operators/src/data/table.dart';
import 'package:operators/src/data/user.dart';

class TableBloc {
  static const baseUrl = '/';

  Stream<List<User>> usersStream =
      firebase.database().ref(baseUrl).child('users').onValue.map((event) {
    final users = <User>[];
    final snapshot = event.snapshot;
    snapshot.forEach((childSnapshot) {
      int id = int.parse(childSnapshot.key);
      String name = childSnapshot.child('name').val();
      bool isActive = childSnapshot.child('isActive').val() ?? true;
      String uid = childSnapshot.child('uid').val();
      if (isActive) {
        users.add(User(id: id, name: name, uid: uid));
      }
    });
    users.sort((u1, u2) => u1.name.compareTo(u2.name));
    return users;
  });

  Stream<TableData> tableStream =
      firebase.database().ref(baseUrl).onValue.map((event) {
    final snapshot = event.snapshot;
    final eventsSnapshot = snapshot.child('events');
    final usersSnapshot = snapshot.child('users');

    final events = <Event>[];
    final users = <User>[];

    DateFormat format = DateFormat('yyyy-MM-dd HH:mm');
    eventsSnapshot.forEach((childSnapshot) {
      bool isActive = childSnapshot.child('isActive').val();
      if (isActive) {
        int id = int.parse(childSnapshot.key);
        String title = childSnapshot.child('title').val();
        DateTime date;
        if (childSnapshot.hasChild('date')) {
          try {
            date = format.parse(childSnapshot.child('date').val());
          } catch (Exception) {}
        }
        Map<int, EventUserState> state = {};
        childSnapshot.child('state')?.forEach((stateSnapshot) {
          int userId = int.parse(stateSnapshot.key);
          bool canHelp = stateSnapshot.child('canHelp').val();
          Role role = stringToRole(stateSnapshot.child('role').val());
          state[userId] = EventUserState(canHelp: canHelp, role: role);
        });
        events.add(Event(id: id, title: title, date: date, state: state));
      }
    });
    events.sort((e1, e2) {
      if (e1.date == null && e2.date == null) {
        return e1.id.compareTo(e2.id);
      } else if (e1.date == null && e2.date != null) {
        return -1;
      } else if (e1.date != null && e2.date == null) {
        return 1;
      } else {
        return e1.date.compareTo(e2.date);
      }
    });

    usersSnapshot.forEach((childSnapshot) {
      int id = int.parse(childSnapshot.key);
      String name = childSnapshot.child('name').val();
      bool isActive = childSnapshot.child('isActive').val() ?? true;
      if (isActive) {
        users.add(User(id: id, name: name));
      }
    });
    users.sort((u1, u2) => u1.name.compareTo(u2.name));

    return TableData(events: events, users: users);
  });

  void toggleCanHelp(User user, Event event) {
    var newValue;
    if (event.state.containsKey(user.id)) {
      if (event.state[user.id].canHelp) {
        newValue = false;
      } else {
        newValue = null;
      }
    } else {
      newValue = true;
    }
    firebase
        .database()
        .ref('$baseUrl/events/${event.id}/state/${user.id}/canHelp')
        .set(newValue);
  }
}
