import 'package:flutter_google_places_sdk_platform_interface/flutter_google_places_sdk_platform_interface.dart';
import 'package:flutter_google_places_sdk_platform_interface/src/types/place_types.dart';

class PlaceDetails {
  const PlaceDetails({
    this.location,
    this.types,
  });

  /// The place location
  final Location location;

  /// Place types
  final List<Types> types;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PlaceDetails && runtimeType == other.runtimeType && location == other.location;

  @override
  int get hashCode => location.hashCode;

  @override
  String toString() {
    return 'PlaceDetails{location: $location, types: $types}';
  }

  Map<String, dynamic> toMap() => {
        'location': location.toMap(),
        'types': types.map((e) => e.toString()),
      };

  static PlaceDetails fromMap(Map<String, dynamic> map) => PlaceDetails(
        location: Location.fromMap(Map<String, dynamic>.from(map['location'])),
        types: List<dynamic>.from(map['types']).map((e) => TypesHelper.from(e as String)).toList(),
      );
}
