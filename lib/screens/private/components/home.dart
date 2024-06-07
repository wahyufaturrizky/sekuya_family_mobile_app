// ignore_for_file: prefer_const_constructors

/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/shimmer_loading.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/featured_community.dart';
import 'package:sekuya_family_mobile_app/components/tab_mission/mission.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/screens/private/profile_detail.dart';
import 'package:sekuya_family_mobile_app/service/dashboard/dashboard.dart';

class HomeComponentApp extends StatelessWidget {
  const HomeComponentApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const HomeComponent();
  }
}

class HomeComponent extends StatefulWidget {
  const HomeComponent({super.key});

  @override
  State<HomeComponent> createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
  var resDashboard;
  bool isLoading = false;

  void goToDetailMission(data, index) {
    final arguments = MyArgumentsDataDetailMissionClass(data, index);

    Application.router.navigateTo(context, "/detailMissionScreen",
        transition: TransitionType.native,
        routeSettings: RouteSettings(arguments: arguments));
  }

  void goToDetailCommunity(data, index) {
    final arguments = MyArgumentsDataDetailCommunityClass(data, index);

    Application.router.navigateTo(context, "/communityDetailScreens",
        transition: TransitionType.native,
        routeSettings: RouteSettings(arguments: arguments));
  }

  @override
  void initState() {
    super.initState();
    getDataDashboard();
  }

  Future<dynamic> getDataDashboard() async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      var res = await handleGetDataDashboard();

      if (res != null) {
        if (mounted) {
          setState(() {
            resDashboard = res;
            isLoading = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      print('Error getDataProfile = $e');
    }
  }

  void goToListMission() {
    final arguments = MyArgumentsDataClass(false, false, false, true);

    Application.router.navigateTo(context, "/privateScreens",
        transition: TransitionType.inFromLeft,
        routeSettings: RouteSettings(arguments: arguments));
  }

  void goToListCommunity() {
    final arguments = MyArgumentsDataClass(false, true, false, false);

    Application.router.navigateTo(context, "/privateScreens",
        transition: TransitionType.inFromLeft,
        routeSettings: RouteSettings(arguments: arguments));
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer(
        linearGradient: shimmerGradient,
        child: SingleChildScrollView(
            physics: isLoading ? const NeverScrollableScrollPhysics() : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 180.0,
                    // autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    viewportFraction: 1.0,
                  ),
                  items: [
                    1,
                    2,
                  ].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          child: resDashboard != null
                              ? Image.network(
                                  resDashboard?["data"]?["coverImage"],
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                )
                              : MyWidgetShimmerApp(
                                  isLoading: isLoading,
                                  child: Card(
                                    child: SizedBox(
                                      width: 350,
                                    ),
                                  )),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Featured Mission',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          goToListMission();
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                              color: yellowPrimaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding: const EdgeInsets.only(left: 16),
                  height: 150,
                  child: ListView(
                    physics:
                        isLoading ? const NeverScrollableScrollPhysics() : null,
                    scrollDirection: Axis.horizontal,
                    children: resDashboard != null
                        ? (resDashboard?["data"]?["featuredMissions"]
                                as List<dynamic>)
                            .map((item) {
                            return Builder(
                              builder: (BuildContext context) {
                                var rewards = item?["rewards"];
                                return Card(
                                  color: blackPrimaryColor,
                                  clipBehavior: Clip.hardEdge,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: InkWell(
                                    splashColor:
                                        yellowPrimaryColor.withAlpha(30),
                                    onTap: () {
                                      var tempItem = {
                                        "data": {"data": []}
                                      };

                                      tempItem["data"]!["data"]?.add(item);

                                      goToDetailMission(tempItem, 0);
                                    },
                                    child: SizedBox(
                                      width: 200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item["name"],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  children: [
                                                    if (item?["community"]
                                                            ?["image"] !=
                                                        null)
                                                      CircleAvatar(
                                                        radius: 12,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: Image.network(
                                                            item?["community"]
                                                                ?["image"]),
                                                      ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      item["description"]
                                                                  .length >
                                                              15
                                                          ? '${item["description"].substring(0, 15)}...'
                                                          : item["description"],
                                                      style: const TextStyle(
                                                          color:
                                                              greySecondaryColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: blackSolidPrimaryColor,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        {
                                                          "title": "Task",
                                                          "value":
                                                              item["totalTasks"]
                                                                  .toString(),
                                                        },
                                                        {
                                                          "title": "Xp",
                                                          "value":
                                                              item["totalExp"]
                                                                  .toString(),
                                                        },
                                                        {
                                                          "title": rewards
                                                                  .isEmpty
                                                              ? null
                                                              : rewards?[0]
                                                                      ?["name"]
                                                                  ?.split(
                                                                      " ")?[1],
                                                          "value": rewards
                                                                  .isEmpty
                                                              ? null
                                                              : rewards?[0]
                                                                      ?["name"]
                                                                  ?.split(
                                                                      " ")?[0],
                                                          "image": rewards
                                                                  .isEmpty
                                                              ? null
                                                              : rewards?[0]
                                                                  ?["image"],
                                                        },
                                                      ]
                                                          .map(
                                                            (itemMission) =>
                                                                Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    if (itemMission[
                                                                            "image"] !=
                                                                        null)
                                                                      CircleAvatar(
                                                                        radius:
                                                                            10,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        child: Image
                                                                            .network(
                                                                          itemMission[
                                                                              "image"]!,
                                                                          width:
                                                                              14,
                                                                          height:
                                                                              14,
                                                                        ),
                                                                      ),
                                                                    Text(
                                                                      itemMission[
                                                                              "value"]
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  itemMission[
                                                                          "title"]
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color:
                                                                          greySecondaryColor,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                          .toList()),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList()
                        : [
                            MyWidgetShimmerApp(
                                isLoading: isLoading,
                                child: Card(
                                  child: SizedBox(
                                    width: 200,
                                  ),
                                ))
                          ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Featured Communities',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                          onTap: () {
                            goToListCommunity();
                          },
                          child: Text(
                            'See All',
                            style: TextStyle(
                                color: yellowPrimaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding: const EdgeInsets.only(left: 16),
                  height: 150,
                  child: ListView(
                    // This next line does the trick.
                    scrollDirection: Axis.horizontal,
                    children: resDashboard != null
                        ? (resDashboard?["data"]?["featuredCommunities"]
                                as List<dynamic>)
                            .map((item) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Card(
                                  color: blackPrimaryColor,
                                  clipBehavior: Clip.hardEdge,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: InkWell(
                                    splashColor:
                                        yellowPrimaryColor.withAlpha(30),
                                    onTap: () {
                                      var tempItem = {
                                        "data": {"data": []}
                                      };

                                      tempItem["data"]!["data"]?.add(item);

                                      goToDetailCommunity(tempItem, 0);
                                    },
                                    child: Container(
                                      width: 200,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          image: (item?["coverImage"] != null)
                                              ? DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                    item?["coverImage"],
                                                  ))
                                              : null),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            decoration:
                                                const BoxDecoration(boxShadow: [
                                              BoxShadow(
                                                  color: blackSolidPrimaryColor,
                                                  spreadRadius: 15,
                                                  blurRadius: 15)
                                            ]),
                                            child: Column(
                                              children: [
                                                if (item?["name"] != null)
                                                  Text(
                                                    item?["name"].length > 18
                                                        ? '${item?["name"]?.substring(0, 18)}...'
                                                        : item?["name"],
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                if (item != null)
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      {
                                                        "value":
                                                            item?["totalMission"]
                                                                    .toString() ??
                                                                "",
                                                        "title": "total task"
                                                      },
                                                      {
                                                        "value":
                                                            item?["totalPlayers"]
                                                                    .toString() ??
                                                                "",
                                                        "title": "total players"
                                                      },
                                                      {
                                                        "value":
                                                            'Lv${item["level"].toString()}',
                                                        "title": "reward exp"
                                                      }
                                                    ]
                                                        .map((item) => Row(
                                                              children: [
                                                                Image.asset(item[
                                                                            "title"] ==
                                                                        "total task"
                                                                    ? 'assets/images/ic_doc.png'
                                                                    : item["title"] ==
                                                                            "total players"
                                                                        ? 'assets/images/ic_players.png'
                                                                        : 'assets/images/ic_level.png'),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Text(
                                                                  item["value"]
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                const SizedBox(
                                                                  width: 12,
                                                                ),
                                                              ],
                                                            ))
                                                        .toList(),
                                                  ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList()
                        : [
                            MyWidgetShimmerApp(
                                isLoading: isLoading,
                                child: Card(
                                  child: SizedBox(
                                    width: 200,
                                  ),
                                )),
                          ],
                  ),
                ),
              ],
            )));
  }
}
