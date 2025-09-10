import 'package:flutter/material.dart';
import 'package:operators/src/data/model/event.dart';
import 'package:operators/src/data/repository/events.dart';
import 'package:operators/src/data/repository/table.dart';

class SyncEventsUseCase {
  final EventsRepository eventsRepository;
  final TableRepository tableRepository;

  SyncEventsUseCase(this.eventsRepository, this.tableRepository);

  Future<SyncResult> perform({DateTime? dateTime}) async {
    final dateTimeFrom = dateTime ?? DateTime.now();
    int deleted = 0;
    int hidden = 0;
    int added = 0;
    int updated = 0;
    try {
      final futureEvents =
          (await eventsRepository.loadFutureEvents(dateTime: dateTimeFrom))
              .where((e) {
        final difference = e.date.difference(dateTimeFrom);
        return difference > Duration.zero && difference <= Duration(days: 7);
      });
      final allTableEvents = await tableRepository.eventsStream.first;

      for (final event in allTableEvents) {
        if (dateTimeFrom.difference(event.date) >= Duration(days: 90)) {
          debugPrint('delete event: ${event.title}');
          await tableRepository.deleteEvent(event.id);
          deleted++;
        } else if (event.isActive &&
            (event.date == dateTimeFrom || event.date.isBefore(dateTimeFrom))) {
          debugPrint('hide event: ${event.title}');
          await tableRepository.updateEvent(event.id, isActive: false);
          hidden++;
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
          debugPrint('add event: ${futureEvent.title}');
          await tableRepository.addOrUpdateEvent(
              futureEvent.date, futureEvent.title);
          added++;
        } else {
          debugPrint('update event: ${futureEvent.title}');
          await tableRepository.updateEvent(tableEvent.id, isActive: true);
          updated++;
        }
      }
      return SyncResult(
          deleted: deleted, hidden: hidden, added: added, updated: updated);
    } catch (e) {
      return SyncResult(
        deleted: deleted,
        hidden: hidden,
        added: added,
        updated: updated,
        error: e,
      );
    }
  }
}

class SyncResult {
  final int deleted;
  final int hidden;
  final int added;
  final int updated;
  final Object? error;

  SyncResult({
    required this.deleted,
    required this.hidden,
    required this.added,
    required this.updated,
    this.error,
  });
}
