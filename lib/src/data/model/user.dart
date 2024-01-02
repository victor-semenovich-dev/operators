import 'event.dart';

class TableUser {
  final int id;
  final String name;
  final String? shortName;
  final String? uid;
  final List<Role> roles;
  final bool isActive;

  const TableUser({
    required this.id,
    required this.name,
    required this.shortName,
    required this.uid,
    required this.roles,
    required this.isActive,
  });
}
