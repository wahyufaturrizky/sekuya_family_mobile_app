import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import './route_handlers.dart';

class Routes {
  static String root = "/";
  static String demoSimple = "/demo";
  static String privateScreens = "/privateScreens";
  static String profileDetailScreens = "/profileDetailScreens";
  static String notificationScreen = "/notificationScreen";
  static String communityDetailAppScreens = "/communityDetailScreens";
  static String detailVoucherScreen = "/detailVoucherScreen";
  static String detailMissionScreen = "/detailMissionScreen";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return;
    });
    router.define(root, handler: rootHandler);
    router.define(privateScreens, handler: privateHandler);
    router.define(profileDetailScreens, handler: profileDetailHandler);
    router.define(notificationScreen, handler: notificationlHandler);
    router.define(detailVoucherScreen, handler: voucherDetailHandler);
    router.define(detailMissionScreen, handler: missionDetailHandler);
    router.define(communityDetailAppScreens, handler: communityDetailHandler);
  }
}
