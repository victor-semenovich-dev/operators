import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart' as logging;
import 'package:operators/src/data/model/event.dart';
import 'package:operators/src/data/remote/converter/converter.dart';
import 'package:operators/src/data/remote/dto/event.dart';
import 'package:operators/src/data/remote/service/events.dart';

class EventsRepository {
  EventsRepository() {
    logging.Logger.root.level = logging.Level.ALL;
    logging.Logger.root.onRecord.listen((rec) {
      debugPrint('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
    initializeDateFormatting();
  }

  final _chopper = ChopperClient(
    baseUrl: Uri.parse('http://api.geth.by'),
    services: [EventsService.create()],
    converter: JsonSerializableConverter({
      EventDTO: EventDTO.fromJsonFactory,
    }),
    interceptors: [HttpLoggingInterceptor()],
  );

  Future<List<Event>> loadFutureEvents() async {
    if (kIsWeb) {
      final now = DateTime.now();
      DateTime thursday = now.copyWith(
        day: now.day + (DateTime.thursday - now.weekday),
        hour: 19,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
      DateTime sundayMorning = now.copyWith(
        day: now.day + (DateTime.sunday - now.weekday),
        hour: 10,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
      DateTime sundayEvening = now.copyWith(
        day: now.day + (DateTime.sunday - now.weekday),
        hour: 18,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
      if (thursday.isBefore(now)) {
        thursday = thursday.copyWith(day: thursday.day + 7);
      }
      if (sundayMorning.isBefore(now)) {
        sundayMorning = sundayMorning.copyWith(day: sundayMorning.day + 7);
      }
      if (sundayEvening.isBefore(now)) {
        sundayEvening = sundayEvening.copyWith(day: sundayEvening.day + 7);
      }
      final eventsList = [
        Event(0, _formatDate(thursday), thursday),
        Event(0, _formatDate(sundayMorning), sundayMorning),
        Event(0, _formatDate(sundayEvening), sundayEvening),
      ];
      eventsList.sort((a, b) => a.date.compareTo(b.date));
      return eventsList;
    } else {
      final eventsService = _chopper.getService<EventsService>();
      final eventsResponse = await eventsService.getEvents();
      final eventsList = eventsResponse.body;
      return eventsList!
          .where((e) => e.category == CategoryDTO.WORSHIP)
          .map((e) {
        return Event(e.id, _formatDate(e.date), e.date);
      }).toList();
    }
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
