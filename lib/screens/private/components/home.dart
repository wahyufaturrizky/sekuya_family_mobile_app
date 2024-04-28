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
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            color: yellowPrimaryColor,
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
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
                            resDashboard?["data"]?["coverImage"] ?? "",
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : null,
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(
            height: 15,
          ),
          const Row(
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
              Text(
                'See All',
                style: TextStyle(
                    color: yellowPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            height: 160,
            child: ListView(
              // This next line does the trick.
              scrollDirection: Axis.horizontal,
              children: resDashboard != null
                  ? (resDashboard?["data"]?["featuredMissions"]
                          as List<dynamic>)
                      .map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Card(
                            color: blackPrimaryColor,
                            clipBehavior: Clip.hardEdge,
                            margin: const EdgeInsets.only(right: 12),
                            child: InkWell(
                              splashColor: yellowPrimaryColor.withAlpha(30),
                              onTap: () {
                                debugPrint('Card tapped.');
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
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              if (item["image"] != null)
                                                CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Image.network(
                                                      item["image"]),
                                                ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                item["description"]
                                                        .substring(0, 15) +
                                                    '...',
                                                style: const TextStyle(
                                                    color: greySecondaryColor,
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
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      item["total_mission"]
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    const Text(
                                                      'Task',
                                                      style: TextStyle(
                                                          color:
                                                              greySecondaryColor,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      item["total_players"]
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    const Text(
                                                      'Xp',
                                                      style: TextStyle(
                                                          color:
                                                              greySecondaryColor,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        if (item["image"] !=
                                                            null)
                                                          CircleAvatar(
                                                            radius: 10,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            child:
                                                                Image.network(
                                                              item["image"],
                                                              width: 14,
                                                              height: 14,
                                                            ),
                                                          ),
                                                        Text(
                                                          item["level"]
                                                              .toString(),
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ],
                                                    ),
                                                    const Text(
                                                      'USDT',
                                                      style: TextStyle(
                                                          color:
                                                              greySecondaryColor,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
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
                  : [],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Row(
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
              Text(
                'See All',
                style: TextStyle(
                    color: yellowPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
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
                              splashColor: yellowPrimaryColor.withAlpha(30),
                              onTap: () {
                                debugPrint('Card tapped.');
                              },
                              child: Container(
                                width: 200,
                                height: 150,
                                decoration: BoxDecoration(
                                    image: (item?["cover_image"] != null)
                                        ? DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              item?["cover_image"] ?? "",
                                            ))
                                        : null),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: blackSolidPrimaryColor,
                                                spreadRadius: 15,
                                                blurRadius: 15)
                                          ]),
                                      child: Column(
                                        children: [
                                          if (item?["name"] != null)
                                            Text(
                                              item?["name"].substring(0, 18) +
                                                      '...' ??
                                                  "",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          if (item != null)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                {
                                                  "value": item?["total_task"]
                                                          .toString() ??
                                                      "",
                                                  "title": "total task"
                                                },
                                                {
                                                  "value":
                                                      item?["total_players"]
                                                              .toString() ??
                                                          "",
                                                  "title": "total players"
                                                },
                                                {
                                                  "value": item["reward_exp"]
                                                      .toString(),
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
                                                                fontSize: 12,
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
                  : [],
            ),
          ),
        ],
      ));
    }
  }
}
