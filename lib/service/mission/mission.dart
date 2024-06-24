/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:sekuya_family_mobile_app/service/client.dart';

Future<dynamic> handleGetDataMission(queryParameters) {
  return clientDio(
    serviceUrlParam: "/missions",
    methodParam: "GET",
    queryParameters: queryParameters,
  );
}

Future<dynamic> handleGetDataMissionDetail(id) {
  return clientDio(serviceUrlParam: "/missions/$id", methodParam: "GET");
}

Future<dynamic> handleGetDataLuckyWinnersByMissionDetail(id, queryParameters) {
  return clientDio(
      serviceUrlParam: "/missions/$id/lucky-winners",
      methodParam: "GET",
      queryParameters: queryParameters);
}

Future<dynamic> handleGetDataPlayersByMissionDetail(id, queryParameters) {
  return clientDio(
      serviceUrlParam: "/missions/$id/players",
      methodParam: "GET",
      queryParameters: queryParameters);
}

Future<dynamic> handleTaskSubmission(data, idMission) {
  return clientDio(
    serviceUrlParam: '/missions/$idMission/task-submission',
    methodParam: "POST",
    data: data,
  );
}
