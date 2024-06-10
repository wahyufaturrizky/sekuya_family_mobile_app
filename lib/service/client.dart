/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

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
      InterceptorsWrapper(
        onError: (error, handler) {
          print("@ Error InterceptorsWrapper $error");
          // Do stuff here
          handler.reject(
              error); // Added this line to let error propagate outside the interceptor
        },
      ),

      /// Handles CSRF token
      QueuedInterceptorsWrapper(
        /// Adds CSRF token to headers, if it exists
        onRequest: (requestOptions, handler) async {
          try {
            final prefs = await SharedPreferences.getInstance();

            final accessToken = prefs.getString('access_token') ?? '';

            if (accessToken != '') {
              cachedCSRFToken = 'Bearer $accessToken';
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
          print('@onResponse $response');
          final token = response.headers.value(headerKey);

          if (token != null) {
            cachedCSRFToken = token;
          }
          return handler.resolve(response);
        },

        onError: (error, handler) async {
          print("@ Error QueuedInterceptorsWrapper $error");
          if (error.response == null) return handler.next(error);

          /// When request fails with 401 status code, request new CSRF token
          if (error.response?.statusCode == 401) {
            print('Error 401 $error');
          }
        },
      ),
    ],
  );

Future<dynamic> clientDio(
    {serviceUrlParam = "", methodParam = "GET", data, queryParameters}) async {
  try {
    String serviceUrl = serviceUrlParam;
    String method = methodParam;

    final response = await dio.request(serviceUrl,
        options: Options(
          method: method,
        ),
        queryParameters: queryParameters,
        data: data);
    print('@client response $response');

    var decodeJsonRes = jsonDecode(response.toString());

    return decodeJsonRes;
  } on DioException catch (e) {
    print('@client error $e');
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx and is also not 304.
    if (e.response != null) {
      print(e.response?.data);
      print(e.response?.headers);
      print(e.response?.requestOptions);
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      print(e.requestOptions);
      print(e.message);
    }

    if (e.response?.data != null) {
      return e.response?.data;
    }
  }
}
