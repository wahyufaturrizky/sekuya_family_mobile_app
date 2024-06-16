import 'package:sekuya_family_mobile_app/service/client.dart';

Future<dynamic> handleGetDataVoucher(queryParameters) {
  return clientDio(
      serviceUrlParam: "/vouchers",
      methodParam: "GET",
      queryParameters: queryParameters);
}

Future<dynamic> handleClaimVoucher(data) {
  return clientDio(
    serviceUrlParam: "/vouchers/claim",
    methodParam: "POST",
    data: data,
  );
}
