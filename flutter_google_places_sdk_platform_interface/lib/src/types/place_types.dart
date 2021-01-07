enum Types {
  ACCOUNTING,
  ADMINISTRATIVE_AREA_LEVEL_1,
  ADMINISTRATIVE_AREA_LEVEL_2,
  ADMINISTRATIVE_AREA_LEVEL_3,
  ADMINISTRATIVE_AREA_LEVEL_4,
  ADMINISTRATIVE_AREA_LEVEL_5,
  AIRPORT,
  AMUSEMENT_PARK,
  AQUARIUM,
  ARCHIPELAGO,
  ART_GALLERY,
  ATM,
  BAKERY,
  BANK,
  BAR,
  BEAUTY_SALON,
  BICYCLE_STORE,
  BOOK_STORE,
  BOWLING_ALLEY,
  BUS_STATION,
  CAFE,
  CAMPGROUND,
  CAR_DEALER,
  CAR_RENTAL,
  CAR_REPAIR,
  CAR_WASH,
  CASINO,
  CEMETERY,
  CHURCH,
  CITY_HALL,
  CLOTHING_STORE,
  COLLOQUIAL_AREA,
  CONTINENT,
  CONVENIENCE_STORE,
  COUNTRY,
  COURTHOUSE,
  DENTIST,
  DEPARTMENT_STORE,
  DOCTOR,
  DRUGSTORE,
  ELECTRICIAN,
  ELECTRONICS_STORE,
  EMBASSY,
  ESTABLISHMENT,
  FINANCE,
  FIRE_STATION,
  FLOOR,
  FLORIST,
  FOOD,
  FUNERAL_HOME,
  FURNITURE_STORE,
  GAS_STATION,
  GENERAL_CONTRACTOR,
  GEOCODE,
  GROCERY_OR_SUPERMARKET,
  GYM,
  HAIR_CARE,
  HARDWARE_STORE,
  HEALTH,
  HINDU_TEMPLE,
  HOME_GOODS_STORE,
  HOSPITAL,
  INSURANCE_AGENCY,
  INTERSECTION,
  JEWELRY_STORE,
  LAUNDRY,
  LAWYER,
  LIBRARY,
  LIGHT_RAIL_STATION,
  LIQUOR_STORE,
  LOCALITY,
  LOCAL_GOVERNMENT_OFFICE,
  LOCKSMITH,
  LODGING,
  MEAL_DELIVERY,
  MEAL_TAKEAWAY,
  MOSQUE,
  MOVIE_RENTAL,
  MOVIE_THEATER,
  MOVING_COMPANY,
  MUSEUM,
  NATURAL_FEATURE,
  NEIGHBORHOOD,
  NIGHT_CLUB,
  OTHER,
  PAINTER,
  PARK,
  PARKING,
  PET_STORE,
  PHARMACY,
  PHYSIOTHERAPIST,
  PLACE_OF_WORSHIP,
  PLUMBER,
  PLUS_CODE,
  POINT_OF_INTEREST,
  POLICE,
  POLITICAL,
  POSTAL_CODE,
  POSTAL_CODE_PREFIX,
  POSTAL_CODE_SUFFIX,
  POSTAL_TOWN,
  POST_BOX,
  POST_OFFICE,
  PREMISE,
  PRIMARY_SCHOOL,
  REAL_ESTATE_AGENCY,
  RESTAURANT,
  ROOFING_CONTRACTOR,
  ROOM,
  ROUTE,
  RV_PARK,
  SCHOOL,
  SECONDARY_SCHOOL,
  SHOE_STORE,
  SHOPPING_MALL,
  SPA,
  STADIUM,
  STORAGE,
  STORE,
  STREET_ADDRESS,
  STREET_NUMBER,
  SUBLOCALITY,
  SUBLOCALITY_LEVEL_1,
  SUBLOCALITY_LEVEL_2,
  SUBLOCALITY_LEVEL_3,
  SUBLOCALITY_LEVEL_4,
  SUBLOCALITY_LEVEL_5,
  SUBPREMISE,
  SUBWAY_STATION,
  SUPERMARKET,
  SYNAGOGUE,
  TAXI_STAND,
  TOURIST_ATTRACTION,
  TOWN_SQUARE,
  TRAIN_STATION,
  TRANSIT_STATION,
  TRAVEL_AGENCY,
  UNIVERSITY,
  VETERINARY_CARE,
  ZOO,
}

extension TypesHelper on Types {
  static Types from(String literal) {
    final entries = Types.values.map((e) => MapEntry(e.toString().replaceFirst('Types.', ''), e));
    final map = Map.fromEntries(entries);
    return map[literal];
  }
}