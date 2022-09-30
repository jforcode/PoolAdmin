class Player {
  String id;
  String name;
  String phone;
  int amountPlayerOwes;

  Player({
    required this.id,
    required this.phone,
    required this.name,
    required this.amountPlayerOwes,
  });

  Player.fromMap(Map<String, Object?> map)
      : id = "${map['id']}",
        name = "${map['name']}",
        phone = "${map['phone']}",
        amountPlayerOwes = map['amount_player_owes'] as int;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'amount_player_owes': amountPlayerOwes,
    };
  }
}
