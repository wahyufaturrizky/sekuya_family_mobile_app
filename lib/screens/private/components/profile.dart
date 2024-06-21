import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
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
];

GoogleSignIn googleSignIn = GoogleSignIn(
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

class _ProfileComponentState extends State<ProfileComponent>
    with SingleTickerProviderStateMixin {
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

  late TabController tabController;

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

    tabController = TabController(vsync: this, length: tabs.length);

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

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
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

  handleLogout() async {
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
  }

  @override
  Widget build(BuildContext mainContext) {
    var isLoadingTab =
        isLoadingCommunities || isLoadingResMyMission || isLoadingResMyVoucher;

    return Shimmer(
        linearGradient: shimmerGradient,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.width * 0.6,
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      image: AssetImage(
                        'assets/images/bg_profile.png',
                      ))),
              child: Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            backgroundImage:
                                resProfile?["data"]?["profilePic"] != null
                                    ? NetworkImage(
                                        resProfile?["data"]?["profilePic"])
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
                                  .map((item) => PopupMenuItem<String>(
                                        value: item,
                                        child: ListTile(
                                          leading: Icon(
                                            item == "Logout"
                                                ? Icons.logout_outlined
                                                : Icons.edit_outlined,
                                            color: item == "Logout"
                                                ? redSolidPrimaryColor
                                                : Colors.white,
                                          ),
                                          title: Text(
                                            item == "Logout"
                                                ? 'Logout'
                                                : 'Edit Profile',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: item == "Logout"
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
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          spreadRadius: 42,
                          blurRadius: 42,
                          offset: Offset(0, 40))
                    ]),
                    child: Column(
                      children: [
                        if (resProfile?["data"]?["username"] != null &&
                            resProfile?["data"]?["username"].isNotEmpty)
                          Text(
                            resProfile?["data"]?["username"],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        if (resProfile?["data"]?["email"] != null &&
                            resProfile?["data"]?["email"].isNotEmpty)
                          Text(
                            resProfile?["data"]?["email"] ?? "-",
                            style: const TextStyle(
                                color: greySecondaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        const SizedBox(
                          height: 16,
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
                                      child: const CircleAvatar(
                                        radius: 20,
                                      ))))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            MyWidgetShimmerApp(
              isLoading: isLoadingResProfile,
              child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/bg_progress_xp.png'),
                          fit: BoxFit.fill)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          value: resProfile?["data"]?["nextExp"] * 0.01,
                          color: yellowPrimaryColor,
                          backgroundColor: greyThirdColor,
                        )
                    ],
                  )),
            ),
            Container(
              color: blackSolidPrimaryColor,
              height: 8,
              margin: const EdgeInsets.symmetric(vertical: 16),
            ),
            TabBar(
              labelColor: yellowPrimaryColor,
              unselectedLabelColor: greySecondaryColor,
              dividerColor: greySecondaryColor,
              overlayColor:
                  MaterialStateProperty.all<Color>(yellowPrimaryColor),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: const BoxDecoration(
                  color: yellowPrimaryTransparentColor,
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(4), right: Radius.circular(4))),
              controller: tabController,
              // These are the widgets to put in each tab in the tab bar.
              tabs: tabs.map((String name) => Tab(text: name)).toList(),
              isScrollable: true,
              physics:
                  isLoadingTab ? const NeverScrollableScrollPhysics() : null,
              tabAlignment: TabAlignment.start,
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                physics:
                    isLoadingTab ? const NeverScrollableScrollPhysics() : null,
                children: tabs.map((String name) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          color: mainBlackColor,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (name == "My Mission" &&
                                  resMyMission == null &&
                                  !isLoadingResMyMission)
                                const Center(
                                  child: MyWidgetEmptyListApp(),
                                ),

                              if (name == "My Communities" &&
                                  resMyCommunities == null &&
                                  !isLoadingCommunities)
                                const Center(
                                  child: MyWidgetEmptyListApp(),
                                ),
                              if (name == "My Voucher" &&
                                  resMyVoucher == null &&
                                  !isLoadingResMyVoucher)
                                const Center(
                                  child: MyWidgetEmptyListApp(),
                                ),
                              if (name == "My Reward" &&
                                  resMyReward == null &&
                                  !isLoadingReward)
                                const Center(
                                  child: MyWidgetEmptyListApp(),
                                ),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  controller: tabIndex == 0
                                      ? nestedScrollViewContollerMyMission
                                      : tabIndex == 1
                                          ? nestedScrollViewContollerMyCommunities
                                          : tabIndex == 2
                                              ? nestedScrollViewContollerMyVoucher
                                              : nestedScrollViewContollerMyReward,
                                  physics: isLoadingTab
                                      ? const NeverScrollableScrollPhysics()
                                      : null,
                                  itemCount: name == "My Mission"
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var bodyTab;

                                    switch (name) {
                                      case "My Mission":
                                        bodyTab = MyWidgetShimmerApp(
                                          isLoading: isLoadingResMyMission,
                                          child:
                                              TabContentProfileMyMissionComponentApp(
                                                  resMyMission: resMyMission,
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
                                            isLoading: isLoadingResMyVoucher,
                                            child:
                                                TabContentProfileMyVoucherComponentApp(
                                                    resVoucher: resMyVoucher,
                                                    index: index));

                                        break;
                                      default:
                                        bodyTab = MyWidgetShimmerApp(
                                            isLoading: isLoadingReward,
                                            child:
                                                TabContentProfileMyRewardComponentApp(
                                                    resMyReward: resMyReward,
                                                    index: index));

                                        break;
                                    }

                                    return bodyTab;
                                  },
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
                          ));
                    },
                  );
                }).toList(),
              ),
            )
          ],
        ));
  }
}
