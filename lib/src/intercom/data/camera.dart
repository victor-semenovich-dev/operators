import 'package:intl/intl.dart';
import 'package:operators/src/data/util/dateTime.dart';

class Camera {
  int id;
  bool isLive;
  bool isReady;
  bool isRequested;
  bool isOk;
  List<Message> incomingMessages;
  List<Message> outcomingMessages;
  List<PredefinedMessage> incomingPredefinedMessages;
  List<PredefinedMessage> outcomingPredefinedMessages;

  Camera({
    required this.id,
    required this.isLive,
    required this.isReady,
    required this.isRequested,
    required this.isOk,
    required this.incomingMessages,
    required this.outcomingMessages,
    this.incomingPredefinedMessages = const [],
    this.outcomingPredefinedMessages = const [],
  });

  factory Camera.fromJson(int id, Map<dynamic, dynamic> map) {
    List<Message> readMessages(dynamic data) {
      final resultList = <Message>[];
      if (data is List) {
        data.forEach((element) {
          if (element != null) {
            resultList.add(
              Message(
                text: element['text'],
                author: element['author'],
                dateTime: stringToDateTimeNullable(
                  element['date'],
                  formatDateTimeSeconds,
                ),
              ),
            );
          }
        });
      } else if (data is Map) {
        data.forEach((key, value) {
          resultList.add(
            Message(
              text: value['text'],
              author: value['author'],
              dateTime: stringToDateTimeNullable(
                value['date'],
                formatDateTimeSeconds,
              ),
            ),
          );
        });
      }
      return resultList;
    }

    List<PredefinedMessage> readPredefinedMessages(dynamic data) {
      final resultList = <PredefinedMessage>[];
      if (data is List) {
        data.forEach((element) {
          if (element != null) {
            resultList.add(PredefinedMessage(
                message: element['message'], order: element['order'] ?? 0));
          }
        });
      } else if (data is Map) {
        data.forEach((key, value) {
          resultList.add(PredefinedMessage(
              message: value['message'], order: value['order'] ?? 0));
        });
      }
      return resultList;
    }

    return Camera(
      id: id,
      isLive: map['isLive'],
      isReady: map['isReady'],
      isRequested: map['isRequested'],
      isOk: map['isOk'] ?? true,
      incomingMessages: readMessages(map['incomingMessages']),
      outcomingMessages: readMessages(map['outcomingMessages']),
      incomingPredefinedMessages:
          readPredefinedMessages((map['predefinedMessages'] ?? {})['incoming']),
      outcomingPredefinedMessages: readPredefinedMessages(
          (map['predefinedMessages'] ?? {})['outcoming']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Camera &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isLive == other.isLive &&
          isReady == other.isReady &&
          isRequested == other.isRequested;

  @override
  int get hashCode =>
      id.hashCode ^ isLive.hashCode ^ isReady.hashCode ^ isRequested.hashCode;

  @override
  String toString() {
    return 'Camera{id: $id, isLive: $isLive, isReady: $isReady, isRequested: $isRequested}';
  }
}

class Message {
  final String text;
  final String? author;
  final DateTime? dateTime;
  final int? cameraId;

  Message({
    required this.text,
    required this.author,
    required this.dateTime,
    this.cameraId,
  });

  String? dateTimeReadable() {
    if (dateTime == null) {
      return null;
    } else {
      DateTime dateNow = DateTime.now();
      if (dateNow.year == dateTime!.year &&
          dateNow.month == dateTime!.month &&
          dateNow.day == dateTime!.day) {
        return DateFormat('HH:mm').format(dateTime!);
      } else {
        return DateFormat('dd.MM HH:mm').format(dateTime!);
      }
    }
  }
}

class PredefinedMessage {
  final String message;
  final int order;

  PredefinedMessage({required this.message, this.order = 0});
}
