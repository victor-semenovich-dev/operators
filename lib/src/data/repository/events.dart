import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart' as logging;
import 'package:operators/src/data/remote/converter/converter.dart';
import 'package:operators/src/data/remote/dto/event.dart';
import 'package:operators/src/data/remote/service/events.dart';

class EventsRepository {
  EventsRepository() {
    logging.Logger.root.level = logging.Level.ALL;
    logging.Logger.root.onRecord.listen((rec) {
      debugPrint('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
  }

  final _chopper = ChopperClient(
    baseUrl: Uri.parse('http://api.geth.by'),
    services: [EventsService.create()],
    converter: JsonSerializableConverter({
      EventDTO: EventDTO.fromJsonFactory,
    }),
    interceptors: [HttpLoggingInterceptor()],
  );

  Future<void> updateEvents() async {
    final eventsService = _chopper.getService<EventsService>();
    final eventsResponse = await eventsService.getEvents();
    if (eventsResponse.isSuccessful) {
      final eventsList = eventsResponse.body;
      if (eventsList != null) {
        debugPrint('${eventsList.length} events');
        debugPrint('first event: ${eventsList[0].toString()}');
      }
    }
  }
}
