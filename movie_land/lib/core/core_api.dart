import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_land/core/db/auth_token_db.dart';
import 'package:movie_land/core/models/error_model.dart';
import 'package:movie_land/core/models/failed_response_model.dart';

class CoreApi {
  // static final String baseUrl = 'http://192.168.88.253:8080';
  // static final String baseUrl = 'http://192.168.89.131:8080';
  late String baseUrl;
  late String apiReadAccessToken;
  late String apiKey;
  String? token;

  CoreApi() {
    _initializeBaseUrl();
  }

  void _initializeBaseUrl() {
    final envBaseUrl = dotenv.env['BASE_URL'];
    final envApiReadAccessToken = dotenv.env['API_READ_ACCESS_TOKEN'];
    final envApiKey = dotenv.env['API_KEY'];

    if (envBaseUrl == null || envBaseUrl.isEmpty) {
      log(
        'ERROR: BASE_URL not found in environment variables. Please check your .env file.',
        name: 'CoreApi',
      );
      throw Exception(
        'BASE_URL not configured. Please check your environment variables.',
      );
    }
    if (envApiReadAccessToken == null || envApiReadAccessToken.isEmpty) {
      log(
        'ERROR: API_READ_ACCESS_TOKEN not found in environment variables. Please check your .env file.',
        name: 'CoreApi',
      );
      throw Exception(
        'API_READ_ACCESS_TOKEN not configured. Please check your environment variables.',
      );
    }
    if (envApiKey == null || envApiKey.isEmpty) {
      log(
        'ERROR: API_KEY not found in environment variables. Please check your .env file.',
        name: 'CoreApi',
      );
      throw Exception(
        'API_KEY not configured. Please check your environment variables.',
      );
    }
    apiReadAccessToken = envApiReadAccessToken;
    apiKey = envApiKey;
    baseUrl = envBaseUrl;
    log('Base URL initialized: $baseUrl', name: 'CoreApi');
    log(
      'API Read Access Token initialized: $apiReadAccessToken',
      name: 'CoreApi',
    );
    log('API Key initialized: $apiKey', name: 'CoreApi');
  }

  Future<Map<String, String>> get _generalHeaders async {
    String? token = apiReadAccessToken;
    log("token ${token.toString()}");
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, String>? additionalHeaders,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Construct URL with query parameters
      final url = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParameters?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      //log('message: GET $url', name: 'CoreApi');

      // Headers
      Map<String, String> headers = await _generalHeaders;
      headers.addAll(additionalHeaders ?? {});

      // send request
      final response = await http
          .get(url, headers: headers)
          .timeout(
            Duration(seconds: 7),
            onTimeout: () {
              throw Exception(
                'Request timeout: The server took too long to respond',
              );
            },
          );
      //log("status of get is ${response.statusCode.toString()}");
      // Check for HTTP error responses
      if (response.statusCode >= 500 && response.statusCode < 600) {
        final failedResponse = FailedResponseModel(
          statusCode: response.statusCode,
          statusMessage: 'Internal server error',
          success: false,
          error: ErrorModel(
            message: 'Internal server error',
            error: 'Internal server error',
            statusCode: response.statusCode,
          ),
        );
        throw failedResponse;
      }
      log("get responsecodee ${response.statusCode.toString()}");
      if (response.statusCode < 200 || response.statusCode >= 300) {
        // Handle auth errors before throwing

        final responseBody = response.body;
        final decodedBody = jsonDecode(responseBody);
        final failedResponse = FailedResponseModel.fromJson(decodedBody);
        throw failedResponse;
      }

      // Parse response
      final responseBody = response.body;

      final decodedBody = jsonDecode(responseBody) as Map<String, dynamic>;

      return decodedBody;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      //log('message: POST $url body: ${body.toString()}', name: 'CoreApi');
      Map<String, String> headers = await _generalHeaders;
      headers.addAll(additionalHeaders ?? {});
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      //log(response.statusCode.toString());
      //log(response.statusCode.toString());
      if (response.statusCode >= 500 && response.statusCode < 600) {
        final failedResponse = FailedResponseModel(
          statusCode: response.statusCode,
          statusMessage: 'Internal server error',
          success: false,
          error: ErrorModel(
            message: 'Internal server error',
            error: 'Internal server error',
            statusCode: response.statusCode,
          ),
        );
        throw failedResponse;
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        // Handle auth errors before throwing

        final responseBody = response.body;
        log("message ${responseBody.toString()}");
        log("message ${responseBody.toString()}");
        if (response.statusCode == 404) {
          final failedResponse = FailedResponseModel(
            statusCode: response.statusCode,
            statusMessage: 'Internal server error',
            success: false,
            error: ErrorModel(
              message: 'Internal server error',
              error: 'Internal server error',
              statusCode: response.statusCode,
            ),
          );
          throw failedResponse;
        }
        final decodedBody = jsonDecode(responseBody);
        final failedResponse = FailedResponseModel.fromJson(decodedBody);
        throw failedResponse;
      }
      final responseBody = response.body;
      final decodedBody = jsonDecode(responseBody) as Map<String, dynamic>;
      log(decodedBody.toString());
      return decodedBody;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      log('message: PUT $url body: ${body.toString()}', name: 'CoreApi');
      Map<String, String> headers = await _generalHeaders;
      headers.addAll(additionalHeaders ?? {});
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      log("status ${response.statusCode.toString()}");
      log("body ${response.body.toString()}");
      if (response.statusCode >= 500 && response.statusCode < 600) {
        final failedResponse = FailedResponseModel(
          statusCode: response.statusCode,
          statusMessage: 'Internal server error',
          success: false,
          error: ErrorModel(
            message: 'Internal server error',
            error: 'Internal server error',
            statusCode: response.statusCode,
          ),
        );
        throw failedResponse;
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final responseBody = response.body;
        final decodedBody = jsonDecode(responseBody);
        final failedResponse = FailedResponseModel.fromJson(decodedBody);
        throw failedResponse;
      }
      final responseBody = response.body;
      final decodedBody = jsonDecode(responseBody) as Map<String, dynamic>;

      return decodedBody;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> delete({
    required String endpoint,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      log('message: DELETE $url', name: 'CoreApi');
      Map<String, String> headers = await _generalHeaders;
      headers.addAll(additionalHeaders ?? {});
      final response = await http.delete(url, headers: headers);
      if (response.statusCode >= 500 && response.statusCode < 600) {
        final failedResponse = FailedResponseModel(
          statusCode: response.statusCode,
          statusMessage: 'Internal server error',
          success: false,
          error: ErrorModel(
            message: 'Internal server error',
            error: 'Internal server error',
            statusCode: response.statusCode,
          ),
        );
        throw failedResponse;
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        // Handle auth errors before throwing

        final responseBody = response.body;
        final decodedBody = jsonDecode(responseBody);
        final failedResponse = FailedResponseModel.fromJson(decodedBody);
        throw failedResponse;
      }
      final responseBody = response.body;
      final decodedBody = jsonDecode(responseBody) as Map<String, dynamic>;
      return decodedBody;
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List> downloadFileFromUrl({required String fileUrl}) async {
    try {
      var uri = Uri.parse(fileUrl);
      var response = await http.get(uri).timeout(Duration(seconds: 70));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        log("Download failed with status code: ${response.statusCode}");
        return Uint8List(0);
      }
    } catch (e) {
      log("Error downloading file from $fileUrl: $e");
      // log("Stack trace: $stackTrace"); // optional
      rethrow;
    }
  }
}
