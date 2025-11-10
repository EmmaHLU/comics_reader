/// Application-wide constants

class AppConstants {
  AppConstants._(); // Private constructor to prevent instantiation

  // Database names
  static const String favoritesDatabaseName = 'favorites.db';

  // Firebase collection names
  static const String usersCollection = 'users';
  static const String comicsCollection = 'comics_collection';

  // Firebase storage paths
  static const String comicsPath = 'comics';

  // Shared Preferences keys
  static const String languageCodeKey = 'language_code';
  static const String credentialsKey = 'credentials';

  //Remote Data Sources
  static const String baseXkcd = 'https://xkcd.com';
  static const String searchBase = 'https://relevantxkcd.appspot.com/process';
  static const String explainBase = 'https://www.explainxkcd.com/wiki/api.php';

  // Error messages
  static const String networkErrorMessage = 'Please check your internet connection';
  static const String serverErrorMessage = 'Something went wrong on our end';
  static const String authErrorMessage = 'Authentication failed';
  static const String cacheErrorMessage = 'Failed to load cached data';
  static const String unexpectedErrorMessage = 'An unexpected error occurred';
}
