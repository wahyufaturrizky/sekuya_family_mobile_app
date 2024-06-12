/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/components/empty_list.dart';
import 'package:sekuya_family_mobile_app/components/shimmer_loading.dart';
import 'package:sekuya_family_mobile_app/components/tab_profile/my_community.dart';
import 'package:sekuya_family_mobile_app/components/tab_profile/my_mission.dart';
import 'package:sekuya_family_mobile_app/components/tab_profile/my_reward.dart';
import 'package:sekuya_family_mobile_app/components/tab_profile/my_voucher.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/service/profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn googleSignIn = kIsWeb
    ? GoogleSignIn(
        scopes: scopes,
        clientId:
            "433294916757-ebvrl9qvhgvn3vqo3j2k9elirj7t1k7r.apps.googleusercontent.com")
    : GoogleSignIn(
        scopes: scopes,
      );

class ProfileComponentApp extends StatelessWidget {
  const ProfileComponentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileComponent();
  }
}

class ProfileComponent extends StatefulWidget {
  const ProfileComponent({super.key});

  @override
  State<ProfileComponent> createState() => _ProfileComponentState();
}

class _ProfileComponentState extends State<ProfileComponent> {
  bool isLoadingResProfile = false;
  bool isLoadingResMyVoucher = false;
  bool isLoadingResMyMission = false;
  bool isLoadingCommunities = false;
  bool isLoadingReward = false;

  bool refetchResMyVoucher = false;
  bool refetchResMyMission = false;
  bool refetchCommunities = false;
  bool refetchReward = false;

  final List<String> tabs = <String>[
    'My Mission',
    'My Communities',
    'My Voucher',
    'My Reward',
  ];

  static const pageSizeMyMission = 5;
  static const pageSizeMyCommunities = 5;
  static const pageSizeMyVoucher = 5;
  static const pageSizeMyReward = 5;

  var totalPagesMyMission;
  var totalPagesMyCommunities;
  var totalPagesMyVoucher;
  var totalPagesMyReward;

  var currentPageMyMission = 0;
  var currentPageMyCommunities = 0;
  var currentPageMyVoucher = 0;
  var currentPageMyReward = 0;

  int itemPerPageMyMission = 0;
  int itemPerPageMyCommunities = 0;
  int itemPerPageMyVoucher = 0;
  int itemPerPageMyReward = 0;

  var noDataAnymoreMyMission = false;
  var noDataAnymoreMyCommunities = false;
  var noDataAnymoreMyVoucher = false;
  var noDataAnymoreMyReward = false;

  late ScrollController? nestedScrollViewContollerMyMission =
      ScrollController();
  late ScrollController? nestedScrollViewContollerMyCommunities =
      ScrollController();
  late ScrollController? nestedScrollViewContollerMyVoucher =
      ScrollController();
  late ScrollController? nestedScrollViewContollerMyReward = ScrollController();

  var resProfile;
  var resMyVoucher;
  var resMyMission;
  var resMyReward;
  var resMyCommunities;

  int tabIndex = 0;

  final List<String> menu = <String>[
    'Edit Profile',
    'Logout',
  ];

  @override
  void initState() {
    getDataProfile();
    getDataMyVoucher();
    getDataMyMissions();
    getDataMyCommunities();
    getDataMyReward();

    nestedScrollViewContollerMyMission?.addListener(() {
      if (nestedScrollViewContollerMyMission!.position.atEdge) {
        bool isTop = nestedScrollViewContollerMyMission!.position.pixels == 0;
        if (isTop) {
          print('At the top');
        } else {
          print('At the bottom');
          getDataMyMissions(pageKey: currentPageMyMission + 1, refetch: true);
        }
      }
    });

    nestedScrollViewContollerMyCommunities?.addListener(() {
      if (nestedScrollViewContollerMyCommunities!.position.atEdge) {
        bool isTop =
            nestedScrollViewContollerMyCommunities!.position.pixels == 0;
        if (isTop) {
          print('At the top');
        } else {
          print('At the bottom');
          getDataMyCommunities(
              pageKey: currentPageMyCommunities + 1, refetch: true);
        }
      }
    });

    nestedScrollViewContollerMyVoucher?.addListener(() {
      if (nestedScrollViewContollerMyVoucher!.position.atEdge) {
        bool isTop = nestedScrollViewContollerMyVoucher!.position.pixels == 0;
        if (isTop) {
          print('At the top');
        } else {
          print('At the bottom');
          getDataMyVoucher(pageKey: currentPageMyVoucher + 1, refetch: true);
        }
      }
    });

    nestedScrollViewContollerMyReward?.addListener(() {
      if (nestedScrollViewContollerMyReward!.position.atEdge) {
        bool isTop = nestedScrollViewContollerMyReward!.position.pixels == 0;
        if (isTop) {
          print('At the top');
        } else {
          print('At the bottom');
          getDataMyReward(pageKey: currentPageMyReward + 1, refetch: true);
        }
      }
    });

    super.initState();
  }

  Future<dynamic> getDataMyVoucher({
    int pageKey = 1,
    refetch = false,
  }) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          if (refetch) {
            refetchResMyVoucher = true;
          } else {
            isLoadingResMyVoucher = true;
          }
        });
      }

      var queryParameters;

      queryParameters = {
        'page': pageKey.toString(),
        'limit': pageSizeMyVoucher.toString(),
      };

      var res = await handleGetDataMyVoucher(queryParameters);
      print("@res ${res?["data"]?["meta"]?["totalPages"]}");

      if (res != null) {
        if (mounted) {
          if (res?["data"]?["meta"]?["totalPages"] > currentPageMyVoucher) {
            var response = {
              ...res,
              "data": {
                ...res["data"],
                "data": [
                  ...resMyVoucher?["data"]?["data"] ?? [],
                  ...res?["data"]?["data"],
                ]
              }
            };

            int tempItemPerPageState = res?["data"]?["data"]?.length;

            setState(() {
              resMyVoucher = response;
              isLoadingResMyVoucher = false;
              refetchResMyVoucher = false;
              totalPagesMyVoucher = res?["data"]?["meta"]?["totalPages"];
              currentPageMyVoucher = res?["data"]?["meta"]?["page"];
              itemPerPageMyVoucher =
                  itemPerPageMyVoucher + tempItemPerPageState;
            });
          } else {
            setState(() {
              noDataAnymoreMyVoucher = true;
              isLoadingResMyVoucher = false;
              refetchResMyVoucher = false;
            });
          }
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingResMyVoucher = false;
        });
      }

      print('Error getDataMyVoucher = $e');
    }
  }

  Future<dynamic> getDataMyReward({
    int pageKey = 1,
    refetch = false,
  }) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          if (refetch) {
            refetchReward = true;
          } else {
            isLoadingReward = true;
          }
        });
      }

      var queryParameters;

      queryParameters = {
        'page': pageKey.toString(),
        'limit': pageSizeMyReward.toString(),
      };

      var res = await handleGetDataMyReward(queryParameters);

      if (res != null) {
        if (mounted) {
          if (res?["data"]?["meta"]?["totalPages"] > currentPageMyReward) {
            var response = {
              ...res,
              "data": {
                ...res["data"],
                "data": [
                  ...resMyReward?["data"]?["data"] ?? [],
                  ...res?["data"]?["data"],
                ]
              }
            };

            int tempItemPerPageState = res?["data"]?["data"]?.length;

            setState(() {
              resMyReward = response;
              isLoadingReward = false;
              refetchReward = false;
              totalPagesMyReward = res?["data"]?["meta"]?["totalPages"];
              currentPageMyReward = res?["data"]?["meta"]?["page"];
              itemPerPageMyReward = itemPerPageMyReward + tempItemPerPageState;
            });
          } else {
            setState(() {
              noDataAnymoreMyReward = true;
              isLoadingReward = false;
              refetchReward = false;
            });
          }
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingReward = false;
        });
      }

      print('Error getDataMyReward = $e');
    }
  }

  Future<dynamic> getDataProfile() async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingResProfile = true;
        });
      }

      var res = await handleGetDataProfile();

      if (res != null) {
        if (mounted) {
          setState(() {
            resProfile = res;
            isLoadingResProfile = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingResProfile = false;
        });
      }

      print('Error getDataProfile = $e');
    }
  }

  Future<dynamic> getDataMyMissions({pageKey = 1, refetch = false}) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          if (refetch) {
            refetchResMyMission = true;
          } else {
            isLoadingResMyMission = true;
          }
        });
      }

      var queryParameters;

      queryParameters = {
        'page': pageKey.toString(),
        'limit': pageSizeMyMission.toString(),
      };

      var res = await handleGetDataMyMissios(queryParameters);

      if (res != null) {
        if (mounted) {
          if (res?["data"]?["meta"]?["totalPages"] > currentPageMyMission) {
            var response = {
              ...res,
              "data": {
                ...res["data"],
                "data": [
                  ...resMyMission?["data"]?["data"] ?? [],
                  ...res?["data"]?["data"],
                ]
              }
            };

            int tempItemPerPageState = res?["data"]?["data"]?.length;

            setState(() {
              resMyMission = response;
              isLoadingResMyMission = false;
              refetchResMyMission = false;
              totalPagesMyMission = res?["data"]?["meta"]?["totalPages"];
              currentPageMyMission = res?["data"]?["meta"]?["page"];
              itemPerPageMyMission =
                  itemPerPageMyMission + tempItemPerPageState;
            });
          } else {
            setState(() {
              noDataAnymoreMyMission = true;
              isLoadingResMyMission = false;
              refetchResMyMission = false;
            });
          }
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingResMyMission = false;
          refetchResMyMission = false;
        });
      }

      print('Error getDataMyMissions = $e');
    }
  }

  Future<dynamic> getDataMyCommunities({
    pageKey = 1,
    refetch = false,
  }) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          if (refetch) {
            refetchCommunities = true;
          } else {
            isLoadingCommunities = true;
          }
        });
      }

      var queryParameters;

      queryParameters = {
        'page': pageKey.toString(),
        'limit': pageSizeMyCommunities.toString(),
      };

      var res = await handleGetDataMyCommunities(queryParameters);

      if (res != null) {
        if (mounted) {
          if (res?["data"]?["meta"]?["totalPages"] > currentPageMyCommunities) {
            var response = {
              ...res,
              "data": {
                ...res["data"],
                "data": [
                  ...resMyCommunities?["data"]?["data"] ?? [],
                  ...res?["data"]?["data"],
                ]
              }
            };

            int tempItemPerPageState = res?["data"]?["data"]?.length;

            setState(() {
              resMyCommunities = response;
              isLoadingCommunities = false;
              refetchCommunities = false;
              totalPagesMyCommunities = res?["data"]?["meta"]?["totalPages"];
              currentPageMyCommunities = res?["data"]?["meta"]?["page"];
              itemPerPageMyCommunities =
                  itemPerPageMyCommunities + tempItemPerPageState;
            });
          } else {
            setState(() {
              noDataAnymoreMyCommunities = true;
              isLoadingCommunities = false;
              refetchCommunities = false;
            });
          }
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingCommunities = false;
          refetchCommunities = false;
        });
      }

      print('Error getDataMyCommunities = $e');
    }
  }

  Future handleLogout() async {
    googleSignIn.disconnect().then((value) {
      FirebaseAuth.instance.signOut().then((value) {
        SharedPreferences.getInstance().then((prefs) {
          prefs
              .remove('access_token')
              .then((value) => {
                    Application.router.navigateTo(context, "/",
                        transition: TransitionType.native)
                  })
              .catchError((onError) => {
                    print(
                        'Error SharedPreferences remove access_token = $onError')
                  });
        }).catchError((onError) {
          print('Error SharedPreferences signOut = $onError');
        });
      }).catchError((err) {
        print('Error FirebaseAuth signOut = $err');
      });
    }).catchError((onError) {
      print('Error GoogleSignIn disconnect = $onError');
    });
  }

  @override
  Widget build(BuildContext mainContext) {
    var isLoadingTab =
        isLoadingCommunities || isLoadingResMyMission || isLoadingResMyVoucher;

    var isNull = resMyMission == null ||
        resMyCommunities == null ||
        resMyVoucher == null;

    return Shimmer(
        linearGradient: shimmerGradient,
        child: DefaultTabController(
          length: tabs.length, // This is the number of tabs.
          child: NestedScrollView(
            physics: isLoadingTab || isNull
                ? const NeverScrollableScrollPhysics()
                : null,
            controller: tabIndex == 0
                ? nestedScrollViewContollerMyMission
                : tabIndex == 1
                    ? nestedScrollViewContollerMyCommunities
                    : tabIndex == 2
                        ? nestedScrollViewContollerMyVoucher
                        : nestedScrollViewContollerMyReward,
            floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              // These are the slivers that show up in the "outer" scroll view.

              final TabController tabController =
                  DefaultTabController.of(context);
              tabController.addListener(() {
                if (!tabController.indexIsChanging) {
                  setState(() {
                    tabIndex = tabController.index;
                    noDataAnymoreMyCommunities = false;
                    noDataAnymoreMyMission = false;
                    noDataAnymoreMyReward = false;
                    noDataAnymoreMyVoucher = false;
                  });
                }
              });
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    automaticallyImplyLeading: false,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/images/bg_profile.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 170,
                              alignment: Alignment.topCenter,
                            ),
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Application.router.navigateTo(
                                          context,
                                          "/notificationScreen",
                                          transition: TransitionType.native,
                                        );
                                      },
                                      child: const Icon(
                                        Icons.notifications,
                                        color: yellowPrimaryColor,
                                      ),
                                    ),
                                    MyWidgetShimmerApp(
                                      isLoading: isLoadingResProfile,
                                      child: CircleAvatar(
                                        backgroundImage: resProfile?["data"]
                                                    ?["profilePic"] !=
                                                null
                                            ? NetworkImage(resProfile?["data"]
                                                ?["profilePic"])
                                            : null,
                                        radius: 40,
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                        color: Colors.black,
                                        onSelected: (String item) {
                                          if (item == 'Logout') {
                                            handleLogout();
                                          } else {
                                            Application.router.navigateTo(
                                              context,
                                              "/profileDetailScreens",
                                              transition: TransitionType.native,
                                            );
                                          }
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return menu
                                              .map((item) =>
                                                  PopupMenuItem<String>(
                                                    value: item,
                                                    child: ListTile(
                                                      leading: Icon(
                                                        item == "Logout"
                                                            ? Icons
                                                                .login_outlined
                                                            : Icons.edit,
                                                        color: item == "Logout"
                                                            ? redSolidPrimaryColor
                                                            : Colors.white,
                                                      ),
                                                      title: Text(
                                                        item == "Logout"
                                                            ? 'Logout'
                                                            : 'Edit Profile',
                                                        style: TextStyle(
                                                            color: item ==
                                                                    "Logout"
                                                                ? redSolidPrimaryColor
                                                                : Colors.white),
                                                      ),
                                                    ),
                                                  ))
                                              .toList();
                                        },
                                        child: const Icon(
                                          Icons.more_vert,
                                          color: Colors.white,
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  resProfile?["data"]?["username"] ?? "-",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  resProfile?["data"]?["email"] ?? "-",
                                  style: const TextStyle(
                                      color: greySecondaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16.0,
                          children: [
                            1,
                            2,
                            3,
                          ]
                              .map((item) => GestureDetector(
                                  onTap: () {
                                    // showModalBottomSheet(
                                    // backgroundColor: Colors.black,
                                    //     context: mainContext,
                                    //     builder: (BuildContext context) {
                                    //       return BadgeListBottomSheetApp(
                                    //           detailProfile: resProfile);
                                    //     });

                                    showDialog<String>(
                                      context: mainContext,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        backgroundColor: blackSolidPrimaryColor,
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              child: Image.asset(
                                                  "assets/images/test_badge.png"),
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            const Text('You Get New Badge',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white)),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            const Text(
                                                'dictum cursus mauris varius tristique aliquet. dictum cur mauris varius tristique aliquet. ',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: greySecondaryColor)),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomButton(
                                                buttonText: 'See Later',
                                                isOutlined: true,
                                                border: 1,
                                                isOutlinedBackgroundColor:
                                                    blackSolidPrimaryColor,
                                                isOutlinedBorderColor:
                                                    yellowPrimaryColor,
                                                labelSize: 12,
                                                width: 100,
                                                height: 36,
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context, 'Cancel');
                                                },
                                              ),
                                              CustomButton(
                                                buttonText: 'See My Badge',
                                                onPressed: () {
                                                  Navigator.pop(context, 'OK');
                                                },
                                                labelSize: 12,
                                                height: 36,
                                                width: 100,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: MyWidgetShimmerApp(
                                      isLoading: isLoadingResProfile,
                                      child: CircleAvatar(
                                        radius: 20,
                                      ))))
                              .toList(),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        MyWidgetShimmerApp(
                          isLoading: isLoadingResProfile,
                          child: Container(
                              height: 56,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/bg_progress_xp.png'),
                                      fit: BoxFit.fill)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Level ${resProfile?["data"]?["level"]}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        '${resProfile?["data"]?["exp"] ?? ""} xp',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  if (resProfile?["data"]?["nextExp"] != null)
                                    LinearProgressIndicator(
                                      value: resProfile?["data"]?["nextExp"] *
                                          0.01,
                                      color: yellowPrimaryColor,
                                      backgroundColor: greyThirdColor,
                                    )
                                ],
                              )),
                        )
                      ],
                    ),
                    // This is the title in the app bar.
                    floating: true,
                    expandedHeight: 300.0,
                    toolbarHeight: 300,
                    backgroundColor: Colors.black,
                    forceElevated: innerBoxIsScrolled,
                    bottom: TabBar(
                      labelColor: yellowPrimaryColor,
                      unselectedLabelColor: greySecondaryColor,
                      dividerColor: greySecondaryColor,
                      overlayColor:
                          MaterialStateProperty.all<Color>(yellowPrimaryColor),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: const BoxDecoration(
                          color: yellowPrimaryTransparentColor,
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(4),
                              right: Radius.circular(4))),
                      controller: isLoadingTab ? null : tabController,
                      // These are the widgets to put in each tab in the tab bar.
                      tabs: tabs.map((String name) => Tab(text: name)).toList(),
                      physics: isLoadingTab
                          ? const NeverScrollableScrollPhysics()
                          : null,
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              physics:
                  isLoadingTab ? const NeverScrollableScrollPhysics() : null,
              children: tabs.map((String name) {
                return Builder(
                  builder: (BuildContext context) {
                    return Column(
                      children: [
                        if (name == "My Mission" &&
                            resMyMission == null &&
                            !isLoadingResMyMission)
                          const MyWidgetEmptyListApp(),
                        if (name == "My Communities" &&
                            resMyCommunities == null &&
                            !isLoadingCommunities)
                          const MyWidgetEmptyListApp(),
                        if (name == "My Voucher" &&
                            resMyVoucher == null &&
                            !isLoadingResMyVoucher)
                          const MyWidgetEmptyListApp(),
                        if (name == "My Reward" &&
                            resMyReward == null &&
                            !isLoadingReward)
                          const MyWidgetEmptyListApp(),
                        Expanded(
                          child: Container(
                            color: Colors.black,
                            child: CustomScrollView(
                              key: PageStorageKey<String>(name),
                              slivers: <Widget>[
                                SliverOverlapInjector(
                                  handle: NestedScrollView
                                      .sliverOverlapAbsorberHandleFor(context),
                                ),
                                SliverPadding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  sliver: SliverFixedExtentList(
                                    itemExtent: name == "My Mission"
                                        ? 170.0
                                        : name == "My Communities"
                                            ? 150.0
                                            : name == "My Reward"
                                                ? 130.0
                                                : 140,
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                        var bodyTab;

                                        switch (name) {
                                          case "My Mission":
                                            bodyTab = MyWidgetShimmerApp(
                                              isLoading: isLoadingResMyMission,
                                              child:
                                                  TabContentProfileMyMissionComponentApp(
                                                      resMyMission:
                                                          resMyMission,
                                                      index: index),
                                            );

                                            break;
                                          case "My Communities":
                                            bodyTab = MyWidgetShimmerApp(
                                                isLoading: isLoadingCommunities,
                                                child:
                                                    TabContentProfileMyCommunityComponentApp(
                                                        resMyCommunities:
                                                            resMyCommunities,
                                                        index: index));

                                            break;
                                          case "My Voucher":
                                            bodyTab = MyWidgetShimmerApp(
                                                isLoading:
                                                    isLoadingResMyVoucher,
                                                child:
                                                    TabContentProfileMyVoucherComponentApp(
                                                        resVoucher:
                                                            resMyVoucher,
                                                        index: index));

                                            break;
                                          default:
                                            bodyTab = MyWidgetShimmerApp(
                                                isLoading: isLoadingReward,
                                                child:
                                                    TabContentProfileMyRewardComponentApp(
                                                        resMyReward:
                                                            resMyReward,
                                                        index: index));

                                            break;
                                        }

                                        return bodyTab;
                                      },
                                      childCount: name == "My Mission"
                                          ? itemPerPageMyMission == 0 &&
                                                  isLoadingResMyMission
                                              ? 5
                                              : itemPerPageMyMission
                                          : name == "My Communities"
                                              ? itemPerPageMyCommunities == 0 &&
                                                      isLoadingCommunities
                                                  ? 5
                                                  : itemPerPageMyCommunities
                                              : name == "My Voucher"
                                                  ? itemPerPageMyVoucher == 0 &&
                                                          isLoadingResMyVoucher
                                                      ? 5
                                                      : itemPerPageMyVoucher
                                                  : itemPerPageMyReward == 0 &&
                                                          isLoadingReward
                                                      ? 5
                                                      : itemPerPageMyReward,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // if ((name == "My Mission" && noDataAnymoreMyMission) ||
                        //     (name == "My Communities" &&
                        //         noDataAnymoreMyCommunities) ||
                        //     (name == "My Voucher" && noDataAnymoreMyVoucher) ||
                        //     (name == "My Reward" && noDataAnymoreMyReward))
                        //   const Center(
                        //     child: Text(
                        //         "👋🏻 Hi your reach the end of the list",
                        //         style: TextStyle(
                        //             color: Colors.white, fontSize: 14)),
                        //   ),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ));
  }
}
