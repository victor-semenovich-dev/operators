import 'package:intl/intl.dart';

class Message {
  final int? cameraId; // 0 based
  final DateTime dateTime;
  final String message;

  Message({
    this.cameraId,
    required this.dateTime,
    required this.message,
  });

  String dateTimeReadable() {
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  String toString() {
    return 'Message{cameraId: $cameraId, dateTime: $dateTime, message: $message}';
  }
}
