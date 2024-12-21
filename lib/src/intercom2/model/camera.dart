class Camera {
  final bool live;
  final bool ready;
  final bool attention;
  final bool change;

  Camera({
    required this.live,
    required this.ready,
    required this.attention,
    required this.change,
  });

  Camera.fromJson(Map<String, dynamic> json)
      : live = json['live'],
        ready = json['ready'],
        attention = json['attention'],
        change = json['change'];

  @override
  String toString() {
    return 'Camera{live: $live, ready: $ready, attention: $attention, change: $change}';
  }
}
