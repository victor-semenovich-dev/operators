class Event {
  final int id;
  final String title;
  final Map<int, EventUserState> state;

  const Event({this.id, this.title, this.state});
}

class EventUserState {
  final bool canHelp;

  const EventUserState({this.canHelp});
}