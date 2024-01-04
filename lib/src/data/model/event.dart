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

  const TableEvent(
      {required this.id,
      required this.title,
      required this.date,
      required this.isActive,
      required this.state});

  @override
  String toString() {
    return 'TableEvent{id: $id, title: $title, date: $date, isActive: $isActive, state: $state}';
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

enum Role { PC, CAMERA }

Role? stringToRole(String? str) {
  switch (str) {
    case 'pc':
      return Role.PC;
    case 'camera':
      return Role.CAMERA;
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
    default:
      return null;
  }
}

String? roleToReadableString(Role? role) {
  switch (role) {
    case Role.PC:
      return 'компьютер';
    case Role.CAMERA:
      return 'камера';
    default:
      return null;
  }
}
