import 'package:intl/intl.dart';

class Message {
  final int cameraId; // 0 based
  final DateTime dateTime;
  final String message;
  final String? userName;

  Message({
    required this.cameraId,
    required this.dateTime,
    required this.message,
    this.userName,
  });

  Message.fromJson(Map<String, dynamic> json)
      : cameraId = json['cameraId'],
        dateTime = DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
        message = json['message'],
        userName = json['userName'];

  String dateTimeReadable() {
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  String toString() {
    return 'Message{cameraId: $cameraId, dateTime: $dateTime, message: $message}';
  }
}
