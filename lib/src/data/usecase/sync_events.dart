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
  }
}
