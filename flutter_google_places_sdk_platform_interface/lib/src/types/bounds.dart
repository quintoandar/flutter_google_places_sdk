import 'location.dart';

class Bounds {
  const Bounds({
    this.northeast,
    this.southwest,
  });

  final Location northeast;
  final Location southwest;

  @override
  bool operator ==(Object other) {
    return identical(this, other) || hashCode == other.hashCode;
  }

  @override
  int get hashCode => northeast.hashCode + southwest.hashCode;

  @override
  String toString() {
    return 'Bounds{northeast: $northeast, southwest: $southwest}';
  }

  Map<String, dynamic> toMap() => {
        'northeast': northeast.toMap(),
        'southwest': southwest.toMap(),
      };

  static Bounds fromMap(Map<dynamic, dynamic> map) => Bounds(
        northeast: Location.fromMap(map['northeast']),
        southwest: Location.fromMap(map['southwest']),
      );
}
