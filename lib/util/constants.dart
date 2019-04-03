class ErrorMessages {
  static const String NO_USER_FOUND = "Login failed because there is no user in the database";
}

class StorageKeys {
  static const String USER_ID_KEY = "user_id_key";
  static const String USER_DISPLAY_NAME_KEY = "user_display_name_key";
  static const String USER_PHOTO_URL_KEY = "user_photo_url_key";
  static const String FCM_TOKEN = "fcmToken";
}

class UIConstants {
  // FONT SIZE
  static const double SMALLER_FONT_SIZE = 10.0;
  static const double STANDARD_FONT_SIZE = 14.0;
  static const double BIGGER_FONT_SIZE = 18.0;

  // PADDING
  static const double SMALLER_PADDING = 8.0;
  static const double STANDARD_PADDING = 16.0;
  static const double BIGGER_PADDING = 24.0;

  // ELEVATION
  static const double STANDARD_ELEVATION = 3.0;
}

class FirestorePaths {
  static const String ROOT_PATH = "";
  static const String USERS_COLLECTION = ROOT_PATH + "users";
  static const String CHATROOMS_COLLECTION = ROOT_PATH + "chatrooms";
  static const String USER_DOCUMENT = USERS_COLLECTION + "/{user_id}";
}