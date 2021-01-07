import 'package:flutter_google_places_sdk_platform_interface/flutter_google_places_sdk_platform_interface.dart';

class Viewport {
  const Viewport({
    this.northeast,
    this.southwest,
  });

  final Location northeast, southwest;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Viewport &&
          runtimeType == other.runtimeType &&
          northeast == other.northeast &&
          southwest == other.southwest;

  @override
  int get hashCode => northeast.hashCode ^ southwest.hashCode;

  @override
  String toString() {
    return 'Viewport{northeast: $northeast, southwest: $southwest}';
  }

  Map<String, dynamic> toMap() => {
        'northeast': northeast.toMap(),
        'southwest': southwest.toMap(),
      };

  static Viewport fromMap(Map<dynamic, dynamic> map) => Viewport(
        northeast: Location.fromMap(map['northeast']),
        southwest: Location.fromMap(map['southwest']),
      );
}
