import 'package:operators/src/data/model/event.dart';
import 'package:operators/src/data/model/user.dart';

class TableData {
  final List<TableUser> users;
  final List<TableEvent> events;

  const TableData({required this.users, required this.events});

  TableUser? getUserById(int id) {
    for (int i = 0; i < users.length; i++) {
      if (users[i].id == id) {
        return users[i];
      }
    }
    return null;
  }
}

enum SortType {
  BY_NAME,
  BY_RATING_PC,
  BY_RATING_CAMERA,
  BY_LAST_DATE_PC,
  BY_LAST_DATE_CAMERA
}
