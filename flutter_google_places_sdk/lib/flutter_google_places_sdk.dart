import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk_platform_interface/flutter_google_places_sdk_platform_interface.dart';

class FlutterGooglePlacesSdk {
  FlutterGooglePlacesSdk(this.apiKey, {this.locale}) : assert(apiKey != null);

  static const AssetImage ASSET_POWERED_BY_GOOGLE_ON_WHITE =
      FlutterGooglePlacesSdkPlatform.ASSET_POWERED_BY_GOOGLE_ON_WHITE;

  static const AssetImage ASSET_POWERED_BY_GOOGLE_ON_NON_WHITE =
      FlutterGooglePlacesSdkPlatform.ASSET_POWERED_BY_GOOGLE_ON_NON_WHITE;

  static FlutterGooglePlacesSdkPlatform platform = FlutterGooglePlacesSdkPlatform.instance;

  final String apiKey;
  final Locale locale;

  Future<void> _lastMethodCall;
  Future<void> _initialization;

  Future<T> _addMethodCall<T>(Future<T> Function() method) async {
    Future<T> response;
    if (_lastMethodCall == null) {
      response = _callMethod(method);
    } else {
      response = _lastMethodCall.then((_) {
        return _callMethod(method);
      });
    }
    _lastMethodCall = _waitFor(response);
    return response;
  }

  static Future<void> _waitFor(Future<void> future) {
    final Completer<void> completer = Completer<void>();
    future.whenComplete(completer.complete).catchError((dynamic err) {
      // Ignore if previous call completed with an error.
      print('FlutterGooglePlacesSdk::call error: $err');
      throw err;
    });
    return completer.future;
  }

  Future<T> _callMethod<T>(Future<T> Function() method) async {
    await _ensureInitialized();
    return await method();
  }

  Future<void> _ensureInitialized() {
    return _initialization ??= platform.initialize(apiKey, locale: locale)
      ..catchError((dynamic err) {
        print('FlutterGooglePlacesSdk::_ensureInitialized error: $err');
        _initialization = null;
      });
  }

  /// Autocomplete wrapper around Android Places SDK
  /// Finds autocomplete predictions [FindAutocompletePredictionsResponse] based on a [query].
  /// Optional parameters are the list of [countries] (ISO 3166-1 Alpha-2: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2),
  /// [newSessionToken] to create a new session token to the following requests and
  /// an [origin] location. For more info, check out: https://developers.google.com/places/android-sdk/autocomplete
  Future<FindAutocompletePredictionsResponse> findAutocompletePredictions(
    String query, {
    List<String> countries,
    bool newSessionToken,
    Location origin,
    Bounds bounds,
  }) {
    return _addMethodCall(() => platform.findAutocompletePredictions(
          query,
          countries: countries,
          newSessionToken: newSessionToken,
          origin: origin,
          bounds: bounds,
        ));
  }

  /// Place details wrapper around Android Places SDK
  /// Finds place details [PlaceDetails] given a [placeId] containing the list of [fields] passed to the API.
  /// For more info, check out: https://developers.google.com/places/android-sdk/place-details
  Future<PlaceDetails> fetchPlaceDetails(String placeId, List<PlaceField> fields) {
    return _addMethodCall(() => platform.fetchPlaceDetails(
          placeId,
          fields,
        ));
  }

  Future<bool> isInitialized() {
    return _addMethodCall(platform.isInitialized);
  }
}
