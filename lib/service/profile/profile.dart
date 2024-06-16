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

Future<dynamic> handleGetDataMyVoucher(queryParameters) {
  return clientDio(
      serviceUrlParam: "/profile/my-vouchers",
      methodParam: "GET",
      queryParameters: queryParameters);
}

Future<dynamic> handleGetDataMyReward(queryParameters) {
  return clientDio(
      serviceUrlParam: "/profile/my-rewards",
      methodParam: "GET",
      queryParameters: queryParameters);
}

Future<dynamic> handleGetDataMyMissios(queryParameters) {
  return clientDio(
      serviceUrlParam: "/profile/my-missions",
      methodParam: "GET",
      queryParameters: queryParameters);
}

Future<dynamic> handleGetDataMyCommunities(queryParameters) {
  return clientDio(
      serviceUrlParam: "/profile/my-communities",
      methodParam: "GET",
      queryParameters: queryParameters);
}
