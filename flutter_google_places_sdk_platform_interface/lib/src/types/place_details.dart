import 'package:flutter_google_places_sdk_platform_interface/flutter_google_places_sdk_platform_interface.dart';
import 'package:flutter_google_places_sdk_platform_interface/src/types/place_types.dart';
import 'package:flutter_google_places_sdk_platform_interface/src/types/viewport.dart';

class PlaceDetails {
  const PlaceDetails({
    required this.location,
    required this.types,
    required this.viewport,
  });

  /// The place location
  final Location location;

  /// Place types
  final List<Types?> types;

  /// Viewport
  final Viewport viewport;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceDetails &&
          runtimeType == other.runtimeType &&
          location == other.location &&
          viewport == other.viewport;

  @override
  int get hashCode => location.hashCode ^ viewport.hashCode;

  @override
  String toString() {
    return 'PlaceDetails{location: $location, types: $types, viewport: $viewport}';
  }

  Map<String, dynamic> toMap() => {
        'location': location.toMap(),
        'types': types.map((e) => e.toString()),
        'viewport': viewport.toMap(),
      };

  static PlaceDetails fromMap(Map<String, dynamic> map) => PlaceDetails(
        location: Location.fromMap(map['location']),
        types: List<dynamic>.from(map['types'])
            .map((e) => TypesHelper.from(e as String))
            .toList(),
        viewport: Viewport.fromMap(map['viewport']),
      );
}
