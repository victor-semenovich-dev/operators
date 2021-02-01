class Event {
  final int id;
  final String title;
  final DateTime date;
  final Map<int, EventUserState> state;

  const Event({this.id, this.title, this.date, this.state});
}

class EventUserState {
  final bool canHelp;
  final Role role;

  const EventUserState({this.canHelp, this.role});
}

enum Role { PC, CAMERA }

Role stringToRole(String str) {
  switch (str) {
    case 'pc':
      return Role.PC;
    case 'camera':
      return Role.CAMERA;
    default:
      return null;
  }
}

String roleToString(Role role) {
  switch (role) {
    case Role.PC:
      return 'pc';
    case Role.CAMERA:
      return 'camera';
    default:
      return null;
  }
}
