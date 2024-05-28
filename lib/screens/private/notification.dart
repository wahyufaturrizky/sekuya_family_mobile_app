/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/spinner.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/screens/private/profile_detail.dart';
import 'package:sekuya_family_mobile_app/service/notification/notification.dart';

class NotificationApp extends StatelessWidget {
  const NotificationApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Notification();
  }
}

class Notification extends StatefulWidget {
  const Notification({
    super.key,
  });

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  bool isLoadingResNotification = false;
  static const pageSize = 10;

  var totalPages;
  var currentPageState = 0;
  int itemPerPageState = 0;
  var noDataAnymore = false;

  late ScrollController? nestedScrollViewContoller = ScrollController();

  var resNotification;

  @override
  void initState() {
    getDataNotification();

    nestedScrollViewContoller?.addListener(() {
      if (nestedScrollViewContoller!.position.atEdge) {
        bool isTop = nestedScrollViewContoller!.position.pixels == 0;
        if (isTop) {
          print('At the top');
        } else {
          print('At the bottom');
          getDataNotification(pageKey: currentPageState + 1);
        }
      }
    });

    super.initState();
  }

  Future<dynamic> getDataNotification(
      {search, filter_by_value, pageKey = 1}) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingResNotification = true;
        });
      }

      var queryParameters;

      if (search != null) {
        queryParameters = {
          'search': search,
        };
      } else if (filter_by_value != null) {
        queryParameters = {
          'filter_by_value': filter_by_value,
          'filter_by': 'status',
        };
      } else {
        queryParameters = {
          'page': pageKey.toString(),
          'limit': pageSize.toString(),
        };
      }

      var res = await handleGetDataNotification(queryParameters);

      if (res != null) {
        if (mounted) {
          if (res?["data"]?["meta"]?["totalPages"] > currentPageState) {
            var response = {
              ...res,
              "data": {
                ...res["data"],
                "data": [
                  ...resNotification?["data"]?["data"] ?? [],
                  ...res?["data"]?["data"],
                ]
              }
            };

            int tempItemPerPageState = res?["data"]?["data"]?.length;

            setState(() {
              resNotification = response;
              isLoadingResNotification = false;
              totalPages = res?["data"]?["meta"]?["totalPages"];
              currentPageState = res?["data"]?["meta"]?["page"];
              itemPerPageState = itemPerPageState + tempItemPerPageState;
            });
          } else {
            setState(() {
              noDataAnymore = true;
              isLoadingResNotification = false;
            });
          }
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingResNotification = false;
        });
      }

      print('Error getDataNotification = $e');
    }
  }

  void handleBack() {
    final arguments = MyArgumentsDataClass(true, false, false, false);

    Application.router.navigateTo(context, "/privateScreens",
        transition: TransitionType.inFromLeft,
        routeSettings: RouteSettings(arguments: arguments));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            handleBack();
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          controller: nestedScrollViewContoller,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text('April 2022',
                          style: TextStyle(
                              color: greySoftSecondaryColor,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                Column(
                  children: List.generate(
                      5,
                      (index) => Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                                color: goldenSoftColor,
                                border: Border.symmetric(
                                    horizontal: BorderSide(
                                        color: greySoftFourthColor, width: 1))),
                            child: const Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Mission',
                                      style: TextStyle(
                                        color: goldenColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      '15 minute ago',
                                      style: TextStyle(
                                        color: greySoftThirdColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Mission Complete',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Congratulations! You've successfully completed your mission. Your dedication and effort have paid off. Well done!",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )),
                ),
                if (noDataAnymore)
                  const Center(
                    child: Text("👋🏻 Hi your reach the end of the list",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                if (isLoadingResNotification) const MyWidgetSpinnerApp()
              ],
            ),
            // This is the title in the app bar.
          )),
    ));
  }
}
