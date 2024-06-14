/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:sekuya_family_mobile_app/service/client.dart';

Future<dynamic> handleGetDataCommunities(queryParameters) {
  return clientDio(
      serviceUrlParam: "/communities",
      methodParam: "GET",
      queryParameters: queryParameters);
}

Future<dynamic> handleGetDataCommunitiesDetail(id) {
  return clientDio(serviceUrlParam: "/communities/$id", methodParam: "GET");
}

Future<dynamic> handleGetDataCommunitiesMissions(id) {
  return clientDio(
      serviceUrlParam: "/communities/$id/missions", methodParam: "GET");
}

Future<dynamic> handleGetDataCommunitiesLeaderboards(id) {
  return clientDio(
      serviceUrlParam: "/communities/$id/leaderboards", methodParam: "GET");
}

Future<dynamic> handleGetDataCommunitiesMembers(id) {
  return clientDio(
      serviceUrlParam: "/communities/$id/members", methodParam: "GET");
}

Future<dynamic> handleGetDataCommunitiesCategories() {
  return clientDio(
      serviceUrlParam: "/communities/categories", methodParam: "GET");
}

Future<dynamic> handleJoinCommunities({id, referral}) {
  return clientDio(
      serviceUrlParam: '/communities/$id/join',
      methodParam: "POST",
      data: referral);
}

Future<dynamic> handleLeaveCommunities(id) {
  return clientDio(
    serviceUrlParam: '/communities/$id/leave',
    methodParam: "POST",
  );
}
