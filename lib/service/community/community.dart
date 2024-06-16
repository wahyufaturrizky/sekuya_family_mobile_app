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
