# flutter_google_places_sdk
Flutter plugin for google places native sdk

### What

This is a fork of an Android Google Places SDK wrapper package for Flutter.
This fork adds some functionality to the existent APIs. Here are the improvements:
- Autocomplete API:
  - Add `sessionToken: bool` param
  - Add `countryCode: List<String>` param
  - Add `origin: Location` param
  - Add `bounds: Bounds` param
  - Add `typeFilter: TypeFilter` param
  
- Place Details implementation with the following params:
  - `placeId`
  - `fields: List<PlaceField>`
  - `PlaceField` with `LAT_LNG` option only for now
