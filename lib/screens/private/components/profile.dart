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
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/spinner.dart';
import 'package:sekuya_family_mobile_app/components/tab_profile/my_community.dart';
import 'package:sekuya_family_mobile_app/components/tab_profile/my_mission.dart';
import 'package:sekuya_family_mobile_app/components/tab_profile/my_reward.dart';
import 'package:sekuya_family_mobile_app/components/tab_profile/my_voucher.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/service/profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final List<String> tabs = <String>[
    'My Mission',
    'My Communities',
    'My Voucher',
    'My Reward',
  ];

  var resProfile;
  var resMyVoucher;
  var resMyMission;
  var resMyReward;
  var resMyCommunities;

  final List<String> menu = <String>[
    'Edit Profile',
    'Logout',
  ];

  @override
  void initState() {
    super.initState();
    getDataProfile();
    getDataMyVoucher();
    getDataMyMissions();
    getDataMyCommunities();
    getDataMyReward();
  }

  Future<dynamic> getDataMyVoucher() async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingResMyVoucher = true;
        });
      }

      var res = await handleGetDataMyVoucher();

      if (res != null) {
        if (mounted) {
          setState(() {
            resMyVoucher = res;
            isLoadingResMyVoucher = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingResMyVoucher = false;
        });
      }

      print('Error getDataProfile = $e');
    }
  }

  Future<dynamic> getDataMyReward() async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingReward = true;
        });
      }

      var res = await handleGetDataMyReward();

      if (res != null) {
        if (mounted) {
          setState(() {
            resMyReward = res;
            isLoadingReward = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingReward = false;
        });
      }

      print('Error getDataProfile = $e');
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

      print('Error getDataVoucher = $e');
    }
  }

  Future<dynamic> getDataMyMissions() async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingResMyMission = true;
        });
      }

      var res = await handleGetDataMyMissios();

      if (res != null) {
        if (mounted) {
          setState(() {
            resMyMission = res;
            isLoadingResMyMission = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingResMyMission = false;
        });
      }

      print('Error getDataProfile = $e');
    }
  }

  Future<dynamic> getDataMyCommunities() async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingCommunities = true;
        });
      }

      var res = await handleGetDataMyCommunities();

      if (res != null) {
        if (mounted) {
          setState(() {
            resMyCommunities = res;
            isLoadingCommunities = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingCommunities = false;
        });
      }

      print('Error getDataMyCommunities = $e');
    }
  }

  Future handleLogout() async {
    FirebaseAuth.instance.signOut().then((value) {
      SharedPreferences.getInstance().then((prefs) {
        prefs
            .remove('access_token')
            .then((value) => {
                  Application.router.navigateTo(context, "/",
                      transition: TransitionType.native)
                })
            .catchError((onError) => print(onError));
      }).catchError((onError) {
        print('onError $onError');
      });
    }).catchError((onError) => {print(onError)});
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = isLoadingResProfile ||
        isLoadingResMyVoucher ||
        isLoadingResMyMission ||
        isLoadingCommunities ||
        isLoadingReward;

    if (!isLoading) {
      return const MyWidgetSpinner();
    } else {
      return DefaultTabController(
        length: tabs.length, // This is the number of tabs.
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
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
                                  const Icon(
                                    Icons.more_vert,
                                    color: Colors.transparent,
                                  ),
                                  if (resProfile?["data"]?["profilePic"] !=
                                      null)
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          resProfile?["data"]?["profilePic"]),
                                      radius: 40,
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
                                                          ? Icons.login_outlined
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
                              if (resProfile != null)
                                Text(
                                  resProfile["data"]?["username"] == ""
                                      ? "-"
                                      : resProfile["data"]?["username"],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              if (resProfile != null)
                                Text(
                                  resProfile["data"]?["email"] == ""
                                      ? "-"
                                      : resProfile["data"]?["email"],
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
                        children: [1, 2, 3]
                            .map((item) => const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://i.pravatar.cc/150?img=1'),
                                  radius: 20,
                                ))
                            .toList(),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/bg_progress_xp.png'),
                                  fit: BoxFit.fill)),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Level 4',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '255 xp',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              LinearProgressIndicator(
                                value: 0.6,
                                color: yellowPrimaryColor,
                                backgroundColor: greyThirdColor,
                              )
                            ],
                          )),
                    ],
                  ),
                  // This is the title in the app bar.
                  floating: true,
                  expandedHeight: 300.0,
                  toolbarHeight: 300,
                  backgroundColor: Colors.black,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    // These are the widgets to put in each tab in the tab bar.
                    tabs: tabs.map((String name) => Tab(text: name)).toList(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: tabs.map((String name) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    color: Colors.black,
                    child: CustomScrollView(
                      key: PageStorageKey<String>(name),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(8.0),
                          sliver: SliverFixedExtentList(
                            itemExtent: name == "My Mission"
                                ? 170.0
                                : name == "My Communities"
                                    ? 150.0
                                    : name == "My Reward"
                                        ? 170.0
                                        : 140,
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return name == "My Mission"
                                    ? TabContentProfileMyMissionComponentApp(
                                        resMyMission: resMyMission,
                                        index: index)
                                    : name == "My Communities"
                                        ? TabContentProfileMyCommunityComponentApp(
                                            resMyCommunities: resMyCommunities,
                                            index: index)
                                        : name == "My Reward"
                                            ? TabContentProfileMyRewardComponentApp(
                                                resMyReward: resMyReward,
                                                index: index)
                                            : TabContentProfileMyVoucherComponentApp(
                                                resMyVoucher: resMyVoucher,
                                                index: index);
                              },
                              childCount: name == "My Mission"
                                  ? resMyMission?["data"]?["data"]?.length
                                  : name == "My Communities"
                                      ? resMyCommunities?["data"]?["data"]
                                          ?.length
                                      : name == "My Reward"
                                          ? resMyReward?["data"]?["data"]
                                              ?.length
                                          : resMyVoucher?["data"]?["data"]
                                              ?.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      );
    }
  }
}
