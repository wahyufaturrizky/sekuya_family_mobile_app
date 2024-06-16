import 'package:sekuya_family_mobile_app/service/client.dart';

Future<dynamic> handleGetDataDashboard() {
  return clientDio(serviceUrlParam: "/dashboard", methodParam: "GET");
}
