import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

handleStatusIcon(status) {
  switch (status) {
    case "APPROVED":
      return Icons.check_circle;
    case "PENDING":
      return Icons.pending_actions;
    case "REJECTED":
      return Icons.warning;
    default:
      return Icons.fiber_new;
  }
}

handleStatusColorIcon(status) {
  switch (status) {
    case "APPROVED":
      return greenColor;
    case "PENDING":
      return bluePrimaryColor;
    case "REJECTED":
      return redSolidPrimaryColor;
    default:
      return yellowPrimaryColor;
  }
}
