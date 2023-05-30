import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
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
    final eventsService = _chopper.getService<EventsService>();
    final eventsResponse = await eventsService.getEvents();
    if (eventsResponse.isSuccessful) {
      final eventsList = eventsResponse.body;
      if (eventsList != null) {
        return eventsList
            .where((e) => e.category == CategoryDTO.WORSHIP)
            .map((e) {
          final title;
          final weekday = DateFormat('EE', 'ru').format(e.date).toUpperCase();
          if (e.date.weekday == DateTime.sunday) {
            final partOfDay = e.date.hour <= 12 ? 'утро' : 'вечер';
            title = DateFormat('dd.MM ($weekday, $partOfDay)').format(e.date);
          } else {
            title = DateFormat('dd.MM ($weekday)').format(e.date);
          }
          return Event(e.id, title, e.date);
        }).toList();
      }
    }
    return List.empty();
  }
}
