class Project{
  String name, key, userId;
  double montant;
  String deviseId;
  int echeance;
  double montantSpent;

//<editor-fold desc="Data Methods">

  Project({
    required this.name,
    required this.key,
    required this.userId,
    required this.montant,
    required this.deviseId,
    required this.echeance,
    required this.montantSpent,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          key == other.key &&
          userId == other.userId &&
          montant == other.montant &&
          deviseId == other.deviseId &&
          echeance == other.echeance &&
          montantSpent == other.montantSpent);

  @override
  int get hashCode =>
      name.hashCode ^
      key.hashCode ^
      userId.hashCode ^
      montant.hashCode ^
      deviseId.hashCode ^
      echeance.hashCode ^
      montantSpent.hashCode;

  @override
  String toString() {
    return 'Project{' +
        ' name: $name,' +
        ' key: $key,' +
        ' userId: $userId,' +
        ' montant: $montant,' +
        ' deviseId: $deviseId,' +
        ' echeance: $echeance,' +
        ' montantSpent: $montantSpent,' +
        '}';
  }

  Project copyWith({
    String? name,
    String? key,
    String? userId,
    double? montant,
    String? deviseId,
    int? echeance,
    double? montantSpent,
  }) {
    return Project(
      name: name ?? this.name,
      key: key ?? this.key,
      userId: userId ?? this.userId,
      montant: montant ?? this.montant,
      deviseId: deviseId ?? this.deviseId,
      echeance: echeance ?? this.echeance,
      montantSpent: montantSpent ?? this.montantSpent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'key': this.key,
      'userId': this.userId,
      'montant': this.montant,
      'deviseId': this.deviseId,
      'echeance': this.echeance,
      'montantSpent': this.montantSpent,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      name: map['name'] as String,
      key: map['key'] as String,
      userId: map['userId'] as String,
      montant: map['montant'] as double,
      deviseId: map['deviseId'] as String,
      echeance: map['echeance'] as int,
      montantSpent: map['montantSpent'] as double,
    );
  }

  static Project initial() {
    return Project(name: "", key: "", userId: "", montant: 0, deviseId: "", echeance: 0, montantSpent: 0);
  }

//</editor-fold>
}