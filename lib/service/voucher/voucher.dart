/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

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
