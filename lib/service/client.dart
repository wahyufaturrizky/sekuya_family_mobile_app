import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? cachedCSRFToken;

const String headerKey = 'Authorization';

final dio = Dio()
  ..options.baseUrl = baseUrl
  ..interceptors.addAll(
    [
      /// Handles CSRF token
      QueuedInterceptorsWrapper(
        /// Adds CSRF token to headers, if it exists
        onRequest: (requestOptions, handler) async {
          try {
            final prefs = await SharedPreferences.getInstance();

            final accessToken = prefs.getString('access_token') ?? '';

            if (accessToken != '') {
              cachedCSRFToken = 'Bearer $accessToken';
              print('cachedCSRFToken $cachedCSRFToken');
              if (cachedCSRFToken != null) {
                requestOptions.headers[headerKey] = cachedCSRFToken;
              }
              return handler.next(requestOptions);
            }
          } catch (e) {
            print('Error access token $e');
          }
        },

        /// Update CSRF token from [response] headers, if it exists
        onResponse: (response, handler) {
          final token = response.headers.value(headerKey);

          if (token != null) {
            cachedCSRFToken = token;
          }
          return handler.resolve(response);
        },

        onError: (error, handler) async {
          if (error.response == null) return handler.next(error);

          /// When request fails with 401 status code, request new CSRF token
          if (error.response?.statusCode == 401) {
            print('Error 401 $error');
          }
        },
      ),
    ],
  );
