/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:sekuya_family_mobile_app/service/client.dart';

Future<dynamic> handleGetDataProfile() {
  return clientDio(serviceUrlParam: "/profile/info", methodParam: "GET");
}

Future<dynamic> handleGetDataDetailProfile(id) {
  return clientDio(serviceUrlParam: "/users/$id", methodParam: "GET");
}

Future<dynamic> handleUpdateDataProfile(data) {
  return clientDio(
    serviceUrlParam: "/profile/info",
    methodParam: "POST",
    data: data,
  );
}

Future<dynamic> handleGetDataMyVoucher() {
  return clientDio(serviceUrlParam: "/profile/my-vouchers", methodParam: "GET");
}

Future<dynamic> handleGetDataMyReward() {
  return clientDio(serviceUrlParam: "/profile/my-reward", methodParam: "GET");
}

Future<dynamic> handleGetDataMyMissios() {
  return clientDio(serviceUrlParam: "/profile/my-missions", methodParam: "GET");
}

Future<dynamic> handleGetDataMyCommunities() {
  return clientDio(
      serviceUrlParam: "/profile/my-communities", methodParam: "GET");
}
