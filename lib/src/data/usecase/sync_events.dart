import 'package:operators/src/data/model/event.dart';
import 'package:operators/src/data/repository/events.dart';
import 'package:operators/src/data/repository/table.dart';

class SyncEventsUseCase {
  final EventsRepository eventsRepository;
  final TableRepository tableRepository;

  SyncEventsUseCase(this.eventsRepository, this.tableRepository);

  void perform() async {
    final futureEvents = (await eventsRepository.loadFutureEvents())
        .where((e) => e.date.difference(DateTime.now()) < Duration(days: 7));
    final allTableEvents = await tableRepository.eventsStream.first;

    final now = DateTime.now();
    allTableEvents.forEach((event) {
      if (now.difference(event.date) > Duration(days: 60)) {
        tableRepository.deleteEvent(event.id);
      }
    });

    futureEvents.forEach((futureEvent) {
      TableEvent? tableEvent;
      for (final e in allTableEvents) {
        if (futureEvent.date == e.date) {
          tableEvent = e;
          break;
        }
      }
      if (tableEvent == null) {
        tableRepository.addEvent(futureEvent.date, futureEvent.title);
      } else {
        tableRepository.updateEvent(tableEvent.id, futureEvent.title, true);
      }
    });
  }
}
