/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:sekuya_family_mobile_app/service/client.dart';

Future<dynamic> handleGetDataCommunities() {
  return clientDio(serviceUrlParam: "/communities", methodParam: "GET");
}

Future<dynamic> handleJoinCommunities(id) {
  return clientDio(
    serviceUrlParam: '/communities/$id/join',
    methodParam: "POST",
  );
}

Future<dynamic> handleLeaveCommunities(id) {
  return clientDio(
    serviceUrlParam: '/communities/$id/leave',
    methodParam: "POST",
  );
}
