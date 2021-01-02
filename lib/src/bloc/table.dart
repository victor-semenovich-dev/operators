import 'dart:async';

import 'package:firebase/firebase.dart' as firebase;
import 'package:operators/src/data/event.dart';
import 'package:operators/src/data/table.dart';
import 'package:operators/src/data/user.dart';

class TableBloc {
  static const baseUrl = '/';

  Stream<TableData> tableStream =
      firebase.database().ref(baseUrl).onValue.map((event) {
    final snapshot = event.snapshot;
    final eventsSnapshot = snapshot.child('events');
    final usersSnapshot = snapshot.child('users');

    final events = <Event>[];
    final users = <User>[];

    eventsSnapshot.forEach((childSnapshot) {
      bool isActive = childSnapshot.child('isActive').val();
      if (isActive) {
        int id = int.parse(childSnapshot.key);
        String title = childSnapshot.child('title').val();
        Map<int, EventUserState> state = {};
        childSnapshot.child('state')?.forEach((stateSnapshot) {
          int userId = int.parse(stateSnapshot.key);
          bool canHelp = stateSnapshot.child('canHelp').val();
          Role role = stringToRole(stateSnapshot.child('role').val());
          state[userId] = EventUserState(canHelp: canHelp, role: role);
        });
        events.add(Event(id: id, title: title, state: state));
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
