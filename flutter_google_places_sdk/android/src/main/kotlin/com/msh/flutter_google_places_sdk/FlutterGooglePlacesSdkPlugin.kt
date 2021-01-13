package com.msh.flutter_google_places_sdk

import android.content.Context
import androidx.annotation.NonNull
import com.google.android.gms.maps.model.LatLng
import com.google.android.libraries.places.api.Places
import com.google.android.libraries.places.api.model.AutocompletePrediction
import com.google.android.libraries.places.api.model.AutocompleteSessionToken
import com.google.android.libraries.places.api.model.Place
import com.google.android.libraries.places.api.model.RectangularBounds
import com.google.android.libraries.places.api.model.TypeFilter
import com.google.android.libraries.places.api.net.FindAutocompletePredictionsRequest
import com.google.android.libraries.places.api.net.FindAutocompletePredictionsResponse
import com.google.android.libraries.places.api.net.PlacesClient
import com.google.android.libraries.places.api.net.FetchPlaceRequest
import com.google.android.libraries.places.api.net.FetchPlaceResponse
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.*

/** FlutterGooglePlacesSdkPlugin */
class FlutterGooglePlacesSdkPlugin : FlutterPlugin, MethodCallHandler {

  private lateinit var client: PlacesClient
  private lateinit var channel: MethodChannel
  private lateinit var applicationContext: Context
  private var token = AutocompleteSessionToken.newInstance()

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    onAttachedToEngine(binding.applicationContext, binding.binaryMessenger)
  }

  private fun onAttachedToEngine(applicationContext: Context, binaryMessenger: BinaryMessenger) {
    this.applicationContext = applicationContext

    channel = MethodChannel(binaryMessenger, CHANNEL_NAME)
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      METHOD_INITIALIZE -> initialize(call, result)
      METHOD_DEINITIALIZE -> deinitialize(call, result)
      METHOD_IS_INITIALIZE -> isInitialized(call, result)
      METHOD_FIND_AUTOCOMPLETE_PREDICTIONS -> autocompletePredictions(call, result)
      METHOD_FETCH_PLACE -> fetchPlaceDetails(call, result)
      else -> result.notImplemented()
    }
  }

  private fun initialize(@NonNull call: MethodCall, @NonNull result: Result) {
    val apiKey = call.argument<String>("apiKey")
    val localeMap = call.argument<Map<String, Any>>("locale")
    val locale = readLocale(localeMap)
    initialize(apiKey, locale)
    result.success(null)
  }

  private fun deinitialize(@NonNull call: MethodCall, @NonNull result: Result) {
    Places.deinitialize()
    result.success(null)
  }

  private fun isInitialized(@NonNull call: MethodCall, @NonNull result: Result) {
    result.success(Places.isInitialized())
  }

  private fun autocompletePredictions(@NonNull call: MethodCall, @NonNull result: Result) {
    val requestBuilder = FindAutocompletePredictionsRequest.builder()

    call.argument<List<String>>("countries")?.let { countries ->
      requestBuilder.setCountries(countries)
    }

    call.argument<Boolean>("newSessionToken")?.let { newSessionToken ->
      if (newSessionToken) {
        token = AutocompleteSessionToken.newInstance()
      }
    }

    call.argument<Map<String, Double?>>("origin")?.let { origin ->
      val originLocation = LatLng(
        origin["lat"] ?: 0.0,
        origin["lng"] ?: 0.0
      )

      requestBuilder.setOrigin(originLocation)
    }

    call.argument<Map<String, Map<String, Double?>?>>("bounds")?.let { bounds ->
      var northeast = bounds["northeast"] ?: mapOf()
      var southwest = bounds["southwest"] ?: mapOf()

      var locationBias = RectangularBounds.newInstance(
        LatLng(
          southwest["lat"] ?: 0.0, 
          southwest["lng"] ?: 0.0
        ),
        LatLng(
          northeast["lat"] ?: 0.0, 
          northeast["lng"] ?: 0.0
        )
      )
      
      requestBuilder.setLocationBias(locationBias)
    }

    val query = call.argument<String>("query")

    var request = requestBuilder
      .setSessionToken(token)
      .setTypeFilter(TypeFilter.GEOCODE)
      .setQuery(query)
      .build()
  
    client.findAutocompletePredictions(request).addOnCompleteListener { task ->
      if (task.isSuccessful) {
        val resultList = responseToList(task.result)
        println("Result: $resultList");
        result.success(resultList)
      } else {
        val exception = task.exception
        result.error("API_ERROR", exception?.message ?: "Unknown exception", null)
      }
    }
  }

  private fun fetchPlaceDetails(@NonNull call: MethodCall, @NonNull result: Result) {
    val placeId = call.argument<String>("placeId") ?: ""
    val fieldsList = call.argument<List<String>>("fields") ?: emptyList()
    val placeFields = fieldsList.map {
      Place.Field.valueOf(it)
    }

    val request = FetchPlaceRequest.newInstance(placeId, placeFields)

    client.fetchPlace(request).addOnCompleteListener { task ->
      if (task.isSuccessful) {
        val resultObj = placeDetailsToMap(task.result)
        result.success(resultObj)
      } else {
        val exception = task.exception
        result.error("API_ERROR", exception?.message ?: "Unknown exception", null)
      }
    }
  }

  private fun responseToList(result: FindAutocompletePredictionsResponse?): List<Map<String, Any?>>? {
    if (result == null) {
      return null
    }

    return result.autocompletePredictions.map { item -> predictionToMap(item) }
  }

  private fun predictionToMap(result: AutocompletePrediction): Map<String, Any?> {
    return mapOf(
            "placeId" to result.placeId,
            "distanceMeters" to result.distanceMeters,
            "primaryText" to result.getPrimaryText(null).toString(),
            "secondaryText" to result.getSecondaryText(null).toString(),
            "fullText" to result.getFullText(null).toString()
    )
  }

  private fun placeDetailsToMap(result: FetchPlaceResponse?): Map<String, Any?> {
    return mapOf(
            "location" to mapOf(
              "lat" to result?.getPlace()?.getLatLng()?.latitude,
              "lng" to result?.getPlace()?.getLatLng()?.longitude
            ),
            "types" to result?.getPlace()?.getTypes()?.map { item -> item.name },
            "viewport" to mapOf(
              "northeast" to mapOf(
                "lat" to result?.getPlace()?.getViewport()?.northeast?.latitude,
                "lng" to result?.getPlace()?.getViewport()?.northeast?.longitude
              ),
              "southwest" to mapOf(
                "lat" to result?.getPlace()?.getViewport()?.southwest?.latitude,
                "lng" to result?.getPlace()?.getViewport()?.southwest?.longitude
              )
            )
    )
  }

  private fun readLocale(localeMap: Map<String, Any>?): Locale? {
    if (localeMap == null) {
      return null
    }

    val language = localeMap["language"] as String
    val country = localeMap["country"] as String
    return Locale(language, country)
  }

  private fun initialize(apiKey: String?, locale: Locale?) {
    Places.initialize(applicationContext, apiKey ?: "", locale)
    client = Places.createClient(applicationContext)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  companion object {
    private const val METHOD_INITIALIZE = "initialize" // string apiKey, Locale locale
    private const val METHOD_DEINITIALIZE = "deinitialize"
    private const val METHOD_IS_INITIALIZE = "isInitialized"
    private const val METHOD_FIND_AUTOCOMPLETE_PREDICTIONS = "findAutocompletePredictions"
    private const val METHOD_FETCH_PLACE = "fetchPlace"

    const val CHANNEL_NAME = "plugins.msh.com/flutter_google_places_sdk"

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val instance = FlutterGooglePlacesSdkPlugin()
      instance.onAttachedToEngine(registrar.context(), registrar.messenger())
    }
  }
}
