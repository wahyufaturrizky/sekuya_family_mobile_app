/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/components/spinner.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/featured_community.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/service/community/community.dart';

class CommunityComponentApp extends StatelessWidget {
  const CommunityComponentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommunityComponent();
  }
}

class CommunityComponent extends StatefulWidget {
  const CommunityComponent({super.key});

  @override
  State<CommunityComponent> createState() => _CommunityComponentState();
}

class _CommunityComponentState extends State<CommunityComponent> {
  late String search;
  final List<String> tabs = <String>['Mission', 'Leaderboard', 'Members'];

  bool isLoadingResCommunities = false;

  var resCommunities;

  final List<Map<String, String>> gridMenu = <Map<String, String>>[
    {
      "title": "Trending",
      "icon": "ic_trending.png",
    },
    {
      "title": "High Level",
      "icon": "ic_high_level.png",
    },
    {
      "title": "Newest",
      "icon": "ic_newest.png",
    },
    {
      "title": "Most Member",
      "icon": "ic_most_member.png",
    },
    {
      "title": "Top Mission",
      "icon": "ic_top_mission.png",
    },
    {
      "title": "???",
      "icon": "ic_trending.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    getDataCommunities();
  }

  Future<dynamic> getDataCommunities() async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingResCommunities = true;
        });
      }

      var res = await handleGetDataCommunities();

      if (res != null) {
        if (mounted) {
          setState(() {
            resCommunities = res;
            isLoadingResCommunities = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingResCommunities = false;
        });
      }

      print('Error getDataProfile = $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = isLoadingResCommunities;

    if (isLoading) {
      return const MyWidgetSpinner();
    } else {
      return NestedScrollView(
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
                      const Center(
                        child: Text(
                          'Communities',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipis',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: greySecondaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        textField: TextField(
                            onChanged: (value) {
                              search = value;
                            },
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            decoration: kTextInputDecoration.copyWith(
                              hintText: 'Search',
                              prefixIcon: const Icon(Icons.search),
                              prefixIconColor: greySecondaryColor,
                              hintStyle:
                                  const TextStyle(color: greySecondaryColor),
                            )),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                          height: 260,
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16),
                              itemCount: 6,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                    color: Colors.black,
                                    child: InkWell(
                                        splashColor:
                                            yellowPrimaryColor.withAlpha(30),
                                        onTap: () {
                                          debugPrint('Card tapped.');
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: greySecondaryColor,
                                                    width: 1),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(16))),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Image.asset(
                                                    'assets/images/${gridMenu[index]["icon"]}',
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Center(
                                                    child: Text(
                                                  gridMenu[index]["title"]!,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                              ],
                                            ))));
                              })),
                    ],
                  ),
                  floating: true,
                  expandedHeight: 400.0,
                  toolbarHeight: 400,
                  backgroundColor: Colors.black,
                  forceElevated: innerBoxIsScrolled,
                ),
              ),
            ];
          },
          body: Builder(
            builder: (BuildContext context) {
              return Container(
                color: Colors.black,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(8.0),
                      sliver: SliverFixedExtentList(
                        itemExtent: 150.0,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return TabContentCommunityFeaturedComponentApp(
                                index: index, resCommunities: resCommunities);
                          },
                          childCount: resCommunities?["data"]?["data"]?.length,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ));
    }
  }
}
