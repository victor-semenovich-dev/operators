class TableUser {
  final int id;
  final String name;
  final String? uid;
  final bool isActive;

  const TableUser({
    required this.id,
    required this.name,
    required this.uid,
    required this.isActive,
  });
}
