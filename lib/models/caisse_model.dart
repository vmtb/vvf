class Caisse{
  String name;
  String type;
  int time;
  String userId;
  String key;
  double solde;

//<editor-fold desc="Data Methods">

  Caisse({
    required this.name,
    required this.type,
    required this.time,
    required this.userId,
    required this.key,
    required this.solde,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Caisse &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type &&
          time == other.time &&
          userId == other.userId &&
          key == other.key &&
          solde == other.solde);

  @override
  int get hashCode =>
      name.hashCode ^
      type.hashCode ^
      time.hashCode ^
      userId.hashCode ^
      key.hashCode ^
      solde.hashCode;

  @override
  String toString() {
    return 'Caisse{' +
        ' name: $name,' +
        ' type: $type,' +
        ' time: $time,' +
        ' userId: $userId,' +
        ' key: $key,' +
        ' solde: $solde,' +
        '}';
  }

  Caisse copyWith({
    String? name,
    String? type,
    int? time,
    String? userId,
    String? key,
    double? solde,
  }) {
    return Caisse(
      name: name ?? this.name,
      type: type ?? this.type,
      time: time ?? this.time,
      userId: userId ?? this.userId,
      key: key ?? this.key,
      solde: solde ?? this.solde,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'type': this.type,
      'time': this.time,
      'userId': this.userId,
      'key': this.key,
      'solde': this.solde,
    };
  }

  factory Caisse.fromMap(Map<String, dynamic> map) {
    return Caisse(
      name: map['name'] as String,
      type: map['type'] as String,
      time: map['time'] as int,
      userId: map['userId'] as String,
      key: map['key'] as String,
      solde: double.parse(map['solde'].toString()),
    );
  }

//</editor-fold>
}