class MTable {
  final String id;
  final String name;
  final TableType type;
  final int pricePerHour;
  bool active = true;

  MTable({
    required this.id,
    required this.name,
    required this.type,
    required this.pricePerHour,
  });

  TableType convert(int value) {
    return TableType.values[value];
  }

  MTable.fromMap(Map<String, Object?> map)
      : id = map['id'] as String,
        name = map['name'] as String,
        type = TableType.values[map['table_type'] as int],
        pricePerHour = map['price_per_hour'] as int,
        active = map['active'] as int == 1;
}

enum TableType { pool, french, english }
