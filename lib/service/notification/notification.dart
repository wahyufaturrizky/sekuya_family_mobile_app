import 'package:sekuya_family_mobile_app/service/client.dart';

Future<dynamic> handleGetDataNotification(queryParameters) {
  return clientDio(
      serviceUrlParam: "/notifications",
      methodParam: "GET",
      queryParameters: queryParameters);
}

Future<dynamic> handleGetDetailNotif(id) {
  return clientDio(
    serviceUrlParam: "/notifications/$id",
    methodParam: "GET",
  );
}
