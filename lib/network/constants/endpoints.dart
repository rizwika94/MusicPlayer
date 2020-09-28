class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://itunes.apple.com";

  // receiveTimeout
  static const int receiveTimeout = 5000;

  // connectTimeout
  static const int connectionTimeout = 3000;

  // booking endpoints
  static const String searchSong = baseUrl + "/search?term=";
}
