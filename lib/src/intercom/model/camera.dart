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

  @override
  String toString() {
    return 'Camera{live: $live, ready: $ready, attention: $attention, change: $change}';
  }
}
