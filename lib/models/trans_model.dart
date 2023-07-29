class Trans{
  String key;
  String userId;
  String catId; //Cat
  String caisseId;
  int time;
  int type;
  double amount;
  String deviseId;
  String comment;

//<editor-fold desc="Data Methods">

  Trans({
    required this.key,
    required this.userId,
    required this.catId,
    required this.caisseId,
    required this.time,
    required this.type,
    required this.amount,
    required this.deviseId,
    required this.comment,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trans &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          userId == other.userId &&
          catId == other.catId &&
          caisseId == other.caisseId &&
          time == other.time &&
          type == other.type &&
          amount == other.amount &&
          deviseId == other.deviseId &&
          comment == other.comment);

  @override
  int get hashCode =>
      key.hashCode ^
      userId.hashCode ^
      catId.hashCode ^
      caisseId.hashCode ^
      time.hashCode ^
      type.hashCode ^
      amount.hashCode ^
      deviseId.hashCode ^
      comment.hashCode;

  @override
  String toString() {
    return 'Trans{' +
        ' key: $key,' +
        ' userId: $userId,' +
        ' catId: $catId,' +
        ' caisseId: $caisseId,' +
        ' time: $time,' +
        ' type: $type,' +
        ' amount: $amount,' +
        ' deviseId: $deviseId,' +
        ' comment: $comment,' +
        '}';
  }

  Trans copyWith({
    String? key,
    String? userId,
    String? catId,
    String? caisseId,
    int? time,
    int? type,
    double? amount,
    String? deviseId,
    String? comment,
  }) {
    return Trans(
      key: key ?? this.key,
      userId: userId ?? this.userId,
      catId: catId ?? this.catId,
      caisseId: caisseId ?? this.caisseId,
      time: time ?? this.time,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      deviseId: deviseId ?? this.deviseId,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': this.key,
      'userId': this.userId,
      'catId': this.catId,
      'caisseId': this.caisseId,
      'time': this.time,
      'type': this.type,
      'amount': this.amount,
      'deviseId': this.deviseId,
      'comment': this.comment,
    };
  }

  factory Trans.fromMap(Map<String, dynamic> map) {
    return Trans(
      key: map['key'] as String,
      userId: map['userId'] as String,
      catId: map['catId'] as String,
      caisseId: map['caisseId'] as String,
      time: map['time'] as int,
      type: map['type'] as int,
      amount: map['amount'] as double,
      deviseId: map['deviseId'] as String,
      comment: map['comment']??"",
    );
  }

//</editor-fold>
}