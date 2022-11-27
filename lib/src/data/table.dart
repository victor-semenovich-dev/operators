import 'package:operators/src/data/event.dart';
import 'package:operators/src/data/user.dart';

class TableData {
  final List<User> users;
  final List<Event> events;

  const TableData({required this.users, required this.events});

  User? getUserById(int id) {
    for (int i = 0; i < users.length; i++) {
      if (users[i].id == id) {
        return users[i];
      }
    }
    return null;
  }
}
