class UserModel{
  String firstname;
  String lastname;
  String email;
  String fcm;
  int createdAt;
  String userId;
  String deviseId;

//<editor-fold desc="Data Methods">

  UserModel({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.fcm,
    required this.createdAt,
    required this.userId,
    required this.deviseId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          firstname == other.firstname &&
          lastname == other.lastname &&
          email == other.email &&
          fcm == other.fcm &&
          createdAt == other.createdAt &&
          userId == other.userId &&
          deviseId == other.deviseId);

  @override
  int get hashCode =>
      firstname.hashCode ^
      lastname.hashCode ^
      email.hashCode ^
      fcm.hashCode ^
      createdAt.hashCode ^
      userId.hashCode ^
      deviseId.hashCode;

  @override
  String toString() {
    return 'UserModel{' +
        ' firstname: $firstname,' +
        ' lastname: $lastname,' +
        ' email: $email,' +
        ' fcm: $fcm,' +
        ' createdAt: $createdAt,' +
        ' userId: $userId,' +
        ' deviseId: $deviseId,' +
        '}';
  }

  UserModel copyWith({
    String? firstname,
    String? lastname,
    String? email,
    String? fcm,
    int? createdAt,
    String? userId,
    String? deviseId,
  }) {
    return UserModel(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      fcm: fcm ?? this.fcm,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      deviseId: deviseId ?? this.deviseId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstname': this.firstname,
      'lastname': this.lastname,
      'email': this.email,
      'fcm': this.fcm,
      'createdAt': this.createdAt,
      'userId': this.userId,
      'deviseId': this.deviseId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
      email: map['email'] as String,
      fcm: map['fcm'] as String,
      createdAt: map['createdAt'] as int,
      userId: map['userId'] as String,
      deviseId: map['deviseId']??"",
    );
  }

//</editor-fold>
  static initial() {
    return UserModel(firstname: "", lastname: "", email: "", fcm: "", createdAt: DateTime.now().millisecondsSinceEpoch, userId: "", deviseId: '');
  }
}