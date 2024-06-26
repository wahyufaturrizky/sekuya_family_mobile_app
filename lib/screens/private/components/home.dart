// ignore_for_file: prefer_const_constructors

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
    return const SafeArea(child: HomeComponent());
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

    Application.router.navigateTo(context, "/detailMissionScreen", transition: TransitionType.native, routeSettings: RouteSettings(arguments: arguments));
  }

  void goToDetailCommunity(data, index) {
    final arguments = MyArgumentsDataDetailCommunityClass(data, index);

    Application.router.navigateTo(context, "/communityDetailScreens", transition: TransitionType.native, routeSettings: RouteSettings(arguments: arguments));
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

    Application.router.navigateTo(context, "/privateScreens", transition: TransitionType.inFromRight, routeSettings: RouteSettings(arguments: arguments));
  }

  void goToListCommunity() {
    final arguments = MyArgumentsDataClass(false, true, false, false);

    Application.router.navigateTo(context, "/privateScreens", transition: TransitionType.inFromRight, routeSettings: RouteSettings(arguments: arguments));
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
                SizedBox(height: 10),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 185.0,
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
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                )
                              : MyWidgetShimmerApp(
                                  isLoading: isLoading,
                                  child: Card(
                                    child: SizedBox(
                                      width: 350,
                                    ),
                                  ),
                                ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Featured Mission',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      GestureDetector(
                        onTap: () {
                          goToListMission();
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(color: yellowPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.only(left: 16),
                  height: 135,
                  child: ListView(
                    physics: isLoading ? const NeverScrollableScrollPhysics() : null,
                    scrollDirection: Axis.horizontal,
                    children: resDashboard != null
                        ? (resDashboard?["data"]?["featuredMissions"] as List<dynamic>).map((item) {
                            return Builder(
                              builder: (BuildContext context) {
                                var rewards = item?["rewards"];
                                var name = item?["name"];
                                var description = item?["description"];
                                var community = item?["community"];
                                var totalTasks = item?["totalTasks"];
                                var totalExp = item?["totalExp"];
                                return SizedBox(
                                    width: 180,
                                    child: Card(
                                      color: blackPrimaryColor,
                                      clipBehavior: Clip.hardEdge,
                                      margin: const EdgeInsets.only(right: 12),
                                      child: InkWell(
                                        splashColor: yellowPrimaryColor.withAlpha(30),
                                        onTap: () {
                                          var tempItem = {
                                            "data": {"data": []}
                                          };

                                          tempItem["data"]!["data"]?.add(item);

                                          goToDetailMission(tempItem, 0);
                                        },
                                        child: SizedBox(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    if (name != null)
                                                      Text(
                                                        name,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      children: [
                                                        if (community?["image"] != null)
                                                          Image.network(
                                                            community?["image"],
                                                            height: 12,
                                                            width: 12,
                                                          ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        if (description != null)
                                                          Expanded(
                                                            child: Text(
                                                              description,
                                                              style: const TextStyle(
                                                                color: greySecondaryColor,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                color: blackSolidPrimaryColor,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            {
                                                              "title": "Task",
                                                              "value": totalTasks.toString(),
                                                            },
                                                            {
                                                              "title": "Xp",
                                                              "value": totalExp.toStringAsFixed(1),
                                                            },
                                                            {
                                                              "title": rewards.isEmpty ? "" : rewards?[0]?["name"].substring(0, 4) + "...",
                                                              "value": rewards.isEmpty ? "" : rewards?[0]?["maxQty"].toString().substring(0, 1),
                                                              "image": rewards.isEmpty ? null : rewards?[0]?["image"],
                                                            },
                                                          ]
                                                              .map(
                                                                (itemMission) => Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        if (itemMission["image"] != null)
                                                                          Image.network(
                                                                            itemMission["image"]!,
                                                                            width: 10,
                                                                            height: 10,
                                                                          ),
                                                                        Text(
                                                                          itemMission["value"].toString(),
                                                                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                      itemMission["title"].toString(),
                                                                      style: const TextStyle(color: greySecondaryColor, fontSize: 10, fontWeight: FontWeight.w500),
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
                                    ));
                                ;
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
                  height: 32,
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
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                          onTap: () {
                            goToListCommunity();
                          },
                          child: Text(
                            'See All',
                            style: TextStyle(color: yellowPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500),
                          ))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding: const EdgeInsets.only(left: 16),
                  height: 132,
                  child: ListView(
                    // This next line does the trick.
                    scrollDirection: Axis.horizontal,
                    children: resDashboard != null
                        ? (resDashboard?["data"]?["featuredCommunities"] as List<dynamic>).map((item) {
                            var coverImage = item?["coverImage"];
                            var name = item?["name"];
                            var totalMission = item?["totalMission"];
                            var totalPlayers = item?["totalPlayers"];
                            var level = item?["level"];
                            return Builder(
                              builder: (BuildContext context) {
                                return SizedBox(
                                  width: 240,
                                  child: Card(
                                    color: blackPrimaryColor,
                                    clipBehavior: Clip.hardEdge,
                                    margin: const EdgeInsets.only(right: 12),
                                    child: InkWell(
                                      splashColor: yellowPrimaryColor.withAlpha(30),
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
                                            image: (coverImage != null)
                                                ? DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                      coverImage,
                                                    ))
                                                : null),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(boxShadow: [BoxShadow(color: blackSolidPrimaryColor, spreadRadius: 15, blurRadius: 15)]),
                                              child: Column(
                                                children: [
                                                  if (name != null)
                                                    Text(
                                                      name?.length > 18 ? '${name?.substring(0, 18)}...' : name,
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                                                    ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  if (item != null)
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        {"value": totalMission.toString(), "title": "total task"},
                                                        {"value": totalPlayers.toString(), "title": "total players"},
                                                        {"value": 'Lv${level.toString()}', "title": "reward exp"}
                                                      ].map((itemTask) {
                                                        var title = itemTask["title"];
                                                        var value = itemTask["value"];

                                                        return Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 6),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(title == "total task"
                                                                  ? 'assets/images/ic_doc.png'
                                                                  : title == "total players"
                                                                      ? 'assets/images/ic_players.png'
                                                                      : 'assets/images/ic_level.png'),
                                                              const SizedBox(
                                                                width: 4,
                                                              ),
                                                              Text(
                                                                value.toString(),
                                                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }).toList(),
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
