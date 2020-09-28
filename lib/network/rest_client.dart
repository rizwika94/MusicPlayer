import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'exceptions/network_exceptions.dart';

class RestClient {

  static final RestClient _singleton = RestClient._internal();

  factory RestClient() {
    return _singleton;
  }

  RestClient._internal();

  // instantiate json decoder for json serialization
  final JsonDecoder _decoder = JsonDecoder();

  // Get:-----------------------------------------------------------------------
  Future<dynamic> get(String url) {
    return http.get(url).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw NetworkException(
            message: "Error fetching data from server", statusCode: statusCode);
      }

      print(res);
      return _decoder.convert(res);
    });
  }

  // Post:----------------------------------------------------------------------
  Future<dynamic> post(String url, {Map headers, body, encoding}) async {
    if(headers == null) {
      headers = HashMap<String, String>();
    }
    headers['Content-Type'] = 'application/json';
    return http.post(url, body: json.encode(body), headers: headers, encoding: Encoding.getByName("utf-8"))
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw NetworkException(
            message: "Error fetching data from server", statusCode: statusCode);
      }
      return _decoder.convert(res);
    });
  }
}
