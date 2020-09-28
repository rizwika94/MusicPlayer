import 'dart:convert';

import 'package:walkman_music/network/exceptions/network_exceptions.dart';

class BaseRemoteClientImpl {
  static const ResponseTimeout = Duration(seconds: 7);

  String _username = '';
  String _password = '';

  Map<String, String> header() {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
    return <String, String>{'authorization': basicAuth};
  }

  void handleError(dynamic error) {
    throw NetworkException(message: error);
  }

  /// This will be used primarily for ApiExceptions to return a generic error message
  /// or to tailor the error message to the error code. For now, just a generic message.
  String _errorMessage(int code) {
    return "error  message";
  }
}
