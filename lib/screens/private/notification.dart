import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/featured_community.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/screens/private/profile_detail.dart';
import 'package:sekuya_family_mobile_app/service/community/community.dart';
import 'package:sekuya_family_mobile_app/service/notification/notification.dart';
import 'package:sekuya_family_mobile_app/util/format_date.dart';

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
  bool isLoadingJoinCommunity = false;

  static const pageSize = 5;

  var resNotification;
  var totalPages;
  var currentPageState = 0;
  int itemPerPageState = 0;

  late ScrollController? nestedScrollViewContoller = ScrollController();

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

  void goToDetailCommunity(resCommunities, index) {
    final arguments =
        MyArgumentsDataDetailCommunityClass(resCommunities, index);

    Application.router.navigateTo(context, "/communityDetailScreens",
        transition: TransitionType.native,
        routeSettings: RouteSettings(arguments: arguments));

    setState(() {
      isLoadingJoinCommunity = false;
    });
  }

  Future<dynamic> handleGetDetailNotification(item) async {
    var communityId = item?["data"]?["communityId"]?["id"];
    var idNotif = item?["data"]?["_id"];
    var referral = item?["data"]?["referral"];

    try {
      setState(() {
        isLoadingJoinCommunity = true;
      });

      var resNotif = await handleGetDetailNotif(idNotif);

      if (resNotif != null) {
        var res = await handleJoinCommunities(
            id: communityId, referral: {referral: referral});

        if (res != null) {
          var resCommunityById =
              await handleGetDataCommunitiesDetail(communityId);

          if (resCommunityById != null) {
            var tempItem = {
              "data": {"data": []}
            };

            tempItem["data"]!["data"]?.add(resCommunityById?["data"]);

            var tempData = [];

            tempData.add(res?["data"]);

            goToDetailCommunity(tempItem, 0);
          }
        }
      }
    } catch (e) {
      setState(() {
        isLoadingJoinCommunity = false;
      });
      print(e);
    }
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

      queryParameters = {
        'page': pageKey.toString(),
        'limit': pageSize.toString(),
      };

      var res = await handleGetDataNotification(queryParameters);

      if (res != null) {
        print("@res = $res");

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
              currentPageState = res?["data"]?["meta"]?["currentPage"];
              itemPerPageState = itemPerPageState + tempItemPerPageState;
            });
          } else {
            setState(() {
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
        transition: TransitionType.inFromRight,
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
                // Row(
                //   children: [
                //     Container(
                //       padding: const EdgeInsets.symmetric(vertical: 8),
                //       child: const Text('April 2022',
                //           style: TextStyle(
                //               color: greySoftSecondaryColor,
                //               fontWeight: FontWeight.w500)),
                //     ),
                //   ],
                // ),
                if (resNotification != null)
                  Column(
                    children: (resNotification?["data"]?["data"]
                            as List<dynamic>)
                        .map((item) => GestureDetector(
                            onTap: () {
                              if (!isLoadingJoinCommunity) {
                                handleGetDetailNotification(item);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                  color: goldenSoftColor,
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: greySoftFourthColor,
                                          width: 1))),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item["data"]?["taskCategoryKey"],
                                        style: const TextStyle(
                                          color: goldenColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        handleFormatDate(item?["createdAt"]),
                                        style: const TextStyle(
                                          color: greySoftThirdColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          item?["title"],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          item?["body"],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )))
                        .toList(),
                  ),
              ],
            ),
            // This is the title in the app bar.
          )),
    ));
  }
}
