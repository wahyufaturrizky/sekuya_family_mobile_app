import 'package:sekuya_family_mobile_app/service/client.dart';

Future<dynamic> setRecoveryEmail(data) {
  return clientDio(
    serviceUrlParam: '/auth/set-recovery-email',
    methodParam: "POST",
    data: data,
  );
}
