import 'package:chopper/chopper.dart';
import 'package:operators/src/data/remote/dto/event.dart';

part 'events.chopper.dart';

@ChopperApi(baseUrl: "/events")
abstract class EventsService extends ChopperService {
  static EventsService create([ChopperClient? client]) =>
      _$EventsService(client);

  @Get()
  Future<Response<List<EventDTO>>> getEvents();
}
