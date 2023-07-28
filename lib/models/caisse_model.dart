class Caisse{
  String name;
  String type;
  int time;
  String userId;
  String key;

//<editor-fold desc="Data Methods">

  Caisse({
    required this.name,
    required this.type,
    required this.time,
    required this.userId,
    required this.key,
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
          key == other.key);

  @override
  int get hashCode =>
      name.hashCode ^
      type.hashCode ^
      time.hashCode ^
      userId.hashCode ^
      key.hashCode;

  @override
  String toString() {
    return 'Caisse{' +
        ' name: $name,' +
        ' type: $type,' +
        ' time: $time,' +
        ' userId: $userId,' +
        ' key: $key,' +
        '}';
  }

  Caisse copyWith({
    String? name,
    String? type,
    int? time,
    String? userId,
    String? key,
  }) {
    return Caisse(
      name: name ?? this.name,
      type: type ?? this.type,
      time: time ?? this.time,
      userId: userId ?? this.userId,
      key: key ?? this.key,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'type': this.type,
      'time': this.time,
      'userId': this.userId,
      'key': this.key,
    };
  }

  factory Caisse.fromMap(Map<String, dynamic> map) {
    return Caisse(
      name: map['name'] as String,
      type: map['type'] as String,
      time: map['time'] as int,
      userId: map['userId'] as String,
      key: map['key'] as String,
    );
  }

//</editor-fold>
}