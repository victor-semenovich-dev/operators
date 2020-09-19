import 'dart:async';

import 'package:firebase/firebase.dart' as firebase;
import 'package:operators/src/data/event.dart';
import 'package:operators/src/data/table.dart';
import 'package:operators/src/data/user.dart';

class TableBloc {

  Stream<TableData> tableStream = firebase.database().ref('/').onValue.map((event) {
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
        Map<int, bool> participation = {};
        childSnapshot.child('participation')?.forEach((participationSnapshot) {
          int userId = int.parse(participationSnapshot.key);
          bool value = participationSnapshot.val();
          participation[userId] = value;
        });
        events.add(Event(id: id, title: title, participation: participation));
      }
    });

    usersSnapshot.forEach((childSnapshot) {
      int id = int.parse(childSnapshot.key);
      String name = childSnapshot.child('name').val();
      users.add(User(id: id, name: name));
    });
    users.sort((u1, u2) => u1.name.compareTo(u2.name));

    return TableData(events: events, users: users);
  });

  void toggleValue(User user, Event event) {
    var newValue;
    if (event.participation.containsKey(user.id)) {
      var curValue = event.participation[user.id];
      newValue = !curValue;
    } else {
      newValue = true;
    }
    firebase.database().ref('events/${event.id}/participation/${user.id}')
        .set(newValue);
  }

  void clearValue(User user, Event event) {
    firebase.database().ref('events/${event.id}/participation/${user.id}')
        .remove();
  }
}