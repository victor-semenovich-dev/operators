import 'package:operators/src/data/model/event.dart';
import 'package:operators/src/data/repository/events.dart';
import 'package:operators/src/data/repository/table.dart';

class SyncEventsUseCase {
  final EventsRepository eventsRepository;
  final TableRepository tableRepository;

  SyncEventsUseCase(this.eventsRepository, this.tableRepository);

  Future<void> perform() async {
    final futureEvents = (await eventsRepository.loadFutureEvents())
        .where((e) => e.date.difference(DateTime.now()) < Duration(days: 7));
    final allTableEvents = await tableRepository.eventsStream.first;

    final now = DateTime.now();
    for (final event in allTableEvents) {
      if (now.difference(event.date) > Duration(days: 60)) {
        await tableRepository.deleteEvent(event.id);
      }
    }

    for (final futureEvent in futureEvents) {
      TableEvent? tableEvent;
      for (final e in allTableEvents) {
        if (futureEvent.date == e.date) {
          tableEvent = e;
          break;
        }
      }
      if (tableEvent == null) {
        await tableRepository.addEvent(futureEvent.date, futureEvent.title);
      } else {
        await tableRepository.updateEvent(
            tableEvent.id, futureEvent.title, true);
      }
    }
  }
}
