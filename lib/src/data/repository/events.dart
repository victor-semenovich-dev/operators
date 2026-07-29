import 'package:flutter/foundation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart' as logging;
import 'package:operators/src/data/model/event.dart';

class EventsRepository {
  EventsRepository() {
    logging.Logger.root.level = logging.Level.ALL;
    logging.Logger.root.onRecord.listen((rec) {
      debugPrint('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
    initializeDateFormatting();
  }

  Future<List<Event>> loadFutureEvents({DateTime? dateTime}) async {
    final dateTimeFrom = dateTime ?? DateTime.now();
    DateTime thursday = dateTimeFrom.copyWith(
      day: dateTimeFrom.day + (DateTime.thursday - dateTimeFrom.weekday),
      hour: 19,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
    DateTime sundayMorning = dateTimeFrom.copyWith(
      day: dateTimeFrom.day + (DateTime.sunday - dateTimeFrom.weekday),
      hour: 10,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
    DateTime sundayEvening = dateTimeFrom.copyWith(
      day: dateTimeFrom.day + (DateTime.sunday - dateTimeFrom.weekday),
      hour: 18,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
    if (thursday.isBefore(dateTimeFrom)) {
      thursday = thursday.copyWith(day: thursday.day + 7);
    }
    if (sundayMorning.isBefore(dateTimeFrom)) {
      sundayMorning = sundayMorning.copyWith(day: sundayMorning.day + 7);
    }
    if (sundayEvening.isBefore(dateTimeFrom)) {
      sundayEvening = sundayEvening.copyWith(day: sundayEvening.day + 7);
    }
    final eventsList = [
      Event(0, _formatDate(thursday), thursday),
      Event(0, _formatDate(sundayMorning), sundayMorning),
      Event(0, _formatDate(sundayEvening), sundayEvening),
    ];
    eventsList.sort((a, b) => a.date.compareTo(b.date));
    return eventsList;
  }

  String _formatDate(DateTime date) {
    final weekday = DateFormat('EE', 'ru').format(date).toUpperCase();
    if (date.weekday == DateTime.sunday) {
      final partOfDay = date.hour <= 12 ? 'утро' : 'вечер';
      return DateFormat('dd.MM ($weekday, $partOfDay)').format(date);
    } else {
      return DateFormat('dd.MM ($weekday)').format(date);
    }
  }
}
