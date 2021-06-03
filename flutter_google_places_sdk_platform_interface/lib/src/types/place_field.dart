enum PlaceField {
  location,
  types,
  viewport,
}

extension PlaceFieldDescriptor on PlaceField {
  /// The string value returned from this function must match the
  /// enum values that the android sdk uses and it's described here:
  /// https://developers.google.com/places/android-sdk/reference/com/google/android/libraries/places/api/model/Place.Field
  String? value() {
    switch (this) {
      case PlaceField.location:
        return 'LAT_LNG';
      case PlaceField.types:
        return 'TYPES';
      case PlaceField.viewport:
        return 'VIEWPORT';
      default:
        return null;
    }
  }
}
