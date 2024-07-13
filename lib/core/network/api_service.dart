import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wenia_assignment/core/network/constants.dart';

class ApiService {
  static Future<String> get({String? endpoint}) async {
    print('------------');
    final response = await http.get(Uri.parse('$baseurl/$endpoint'));
    print(response);

    return _handleResponse(response);
  }

  static Future<String> post(
      {String? endpoint,
      required Map<String, dynamic> body,
      Map<String, String>? headers = const {
        'Content-Type': 'application/json'
      }}) async {
    final response = await http.post(
      Uri.parse('$baseurl/${endpoint ?? ''}'),
      headers: headers,
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  static String _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body;
      // return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() {
    return 'ApiException: $statusCode - $message';
  }
}
