class Devise{
  String name;
  String symbol;
  double rate;
  String type;
  String key;

//<editor-fold desc="Data Methods">

  Devise({
    required this.name,
    required this.symbol,
    required this.rate,
    required this.type,
    required this.key,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Devise &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          symbol == other.symbol &&
          rate == other.rate &&
          type == other.type &&
          key == other.key);

  @override
  int get hashCode =>
      name.hashCode ^
      symbol.hashCode ^
      rate.hashCode ^
      type.hashCode ^
      key.hashCode;

  @override
  String toString() {
    return 'Devise{' +
        ' name: $name,' +
        ' symbol: $symbol,' +
        ' rate: $rate,' +
        ' type: $type,' +
        ' key: $key,' +
        '}';
  }

  Devise copyWith({
    String? name,
    String? symbol,
    double? rate,
    String? type,
    String? key,
  }) {
    return Devise(
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      rate: rate ?? this.rate,
      type: type ?? this.type,
      key: key ?? this.key,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'symbol': this.symbol,
      'rate': this.rate,
      'type': this.type,
      'key': this.key,
    };
  }

  factory Devise.fromMap(Map<String, dynamic> map) {
    return Devise(
      name: map['name'] as String,
      symbol: map['symbol'] as String,
      rate: map['rate'] as double,
      type: map['type'] as String,
      key: map['key'] as String,
    );
  }

  factory Devise.initial(){
    return Devise(name: "Euro", symbol: "€", rate: 1, type: "main", key: "");
  }

//</editor-fold>
}