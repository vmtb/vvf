class Category{
  String nom;
  int iconData;
  String type;
  String userId,key;
  int time;
  int colorR, colorG, colorA, colorB;

//<editor-fold desc="Data Methods">

  Category({
    required this.nom,
    required this.iconData,
    required this.type,
    required this.userId,
    required this.key,
    required this.time,
    required this.colorR,
    required this.colorG,
    required this.colorA,
    required this.colorB,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          runtimeType == other.runtimeType &&
          nom == other.nom &&
          iconData == other.iconData &&
          type == other.type &&
          userId == other.userId &&
          key == other.key &&
          time == other.time &&
          colorR == other.colorR &&
          colorG == other.colorG &&
          colorA == other.colorA &&
          colorB == other.colorB);

  @override
  int get hashCode =>
      nom.hashCode ^
      iconData.hashCode ^
      type.hashCode ^
      userId.hashCode ^
      key.hashCode ^
      time.hashCode ^
      colorR.hashCode ^
      colorG.hashCode ^
      colorA.hashCode ^
      colorB.hashCode;

  @override
  String toString() {
    return 'Category{' +
        ' nom: $nom,' +
        ' iconData: $iconData,' +
        ' type: $type,' +
        ' userId: $userId,' +
        ' key: $key,' +
        ' time: $time,' +
        ' colorR: $colorR,' +
        ' colorG: $colorG,' +
        ' colorA: $colorA,' +
        ' colorB: $colorB,' +
        '}';
  }

  Category copyWith({
    String? nom,
    int? iconData,
    String? type,
    String? userId,
    String? key,
    int? time,
    int? colorR,
    int? colorG,
    int? colorA,
    int? colorB,
  }) {
    return Category(
      nom: nom ?? this.nom,
      iconData: iconData ?? this.iconData,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      key: key ?? this.key,
      time: time ?? this.time,
      colorR: colorR ?? this.colorR,
      colorG: colorG ?? this.colorG,
      colorA: colorA ?? this.colorA,
      colorB: colorB ?? this.colorB,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': this.nom,
      'iconData': this.iconData,
      'type': this.type,
      'userId': this.userId,
      'key': this.key,
      'time': this.time,
      'colorR': this.colorR,
      'colorG': this.colorG,
      'colorA': this.colorA,
      'colorB': this.colorB,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      nom: map['nom'] as String,
      iconData: map['iconData'] as int,
      type: map['type'] as String,
      userId: map['userId'] as String,
      key: map['key']??"",
      time: map['time'] as int,
      colorR: map['colorR'] as int,
      colorG: map['colorG'] as int,
      colorA: map['colorA'] as int,
      colorB: map['colorB'] as int,
    );
  }

//</editor-fold>
}