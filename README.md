# flutter_google_places_sdk <img src="https://gist.githubusercontent.com/wescosta/26884502a355b6546177db7869b8e19e/raw/037905e760e86d6c7d6150d07edcb15826e3e66b/null-safety-badge.svg" width="80" height="30" alt="This repo supports the null safety language feature.">
Flutter plugin for google places native sdk

### What

This is a fork of an Android Google Places SDK wrapper package for Flutter.
This fork adds some functionality to the existent APIs. Here are the improvements:
- Autocomplete API:
  - Add `sessionToken: bool` param
  - Add `countryCode: List<String>` param
  - Add `origin: Location` param
  - Add `bounds: Viewport` param

- Place Details implementation with the following params:
  - `placeId`
  - `fields: List<PlaceField>`
  - `PlaceField` with `LAT_LNG` option only for now
