/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/featured_community.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/leaderboard.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/mission.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/screens/private/profile_detail.dart';

class CommunityComponentDetailApp extends StatelessWidget {
  const CommunityComponentDetailApp({super.key, this.args});

  final MyArgumentsDataDetailCommunityClass? args;

  @override
  Widget build(BuildContext context) {
    return CommunityComponentDetail(args: args);
  }
}

class CommunityComponentDetail extends StatefulWidget {
  const CommunityComponentDetail({super.key, this.args});

  final MyArgumentsDataDetailCommunityClass? args;

  @override
  State<CommunityComponentDetail> createState() =>
      _CommunityComponentDetailState();
}

class _CommunityComponentDetailState extends State<CommunityComponentDetail> {
  bool isLoading = false;
  final List<String> tabs = <String>['Mission', 'Leaderboard', 'Members'];

  void handleBack() {
    final arguments = MyArgumentsDataClass(false, true);

    Application.router.navigateTo(context, "/privateScreens",
        transition: TransitionType.inFromLeft,
        routeSettings: RouteSettings(arguments: arguments));

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    print(widget.args?.id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length, // This is the number of tabs.
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                automaticallyImplyLeading: false,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.asset(
                          'assets/images/banner_home.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/ic_community.png',
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'NFT Communities',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/ic_chart.png',
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'LEVEL 4',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: blackSolidPrimaryColor,
                              borderRadius: BorderRadius.circular(4)),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '2',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Mission',
                                style: TextStyle(
                                    color: greySecondaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        )),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: blackSolidPrimaryColor,
                              borderRadius: BorderRadius.circular(4)),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '2',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Members',
                                style: TextStyle(
                                    color: greySecondaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        )),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: blackSolidPrimaryColor,
                              borderRadius: BorderRadius.circular(4)),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '2',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Created',
                                style: TextStyle(
                                    color: greySecondaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'dictum cursus mauris varius tristique aliquet. Morbi cursus urna in nibh diam dolor lacus sit. Tristique rhoncus amet a congue laoreet amet sodales. Laoreet integer nullam pharetra maecenas sit. Purus adipiscing turpis vestibulum interdum egestas. Ornare tincidunt nunc orci',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Social Media',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Row(
                        children: [
                      {"title": "abc", "like": "1.8K"},
                      {"title": "abc", "like": "1.8K"},
                      {"title": "abc", "like": "1.8K"},
                      {"title": "abc", "like": "1.8K"},
                    ].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: blackSolidPrimaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/ic_discord.png',
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  i["like"]!,
                                  style: const TextStyle(
                                      color: yellowPrimaryColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList()),
                  ],
                ),
                floating: true,
                expandedHeight: 360.0,
                toolbarHeight: 360,
                backgroundColor: Colors.black,
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  tabs: tabs.map((String name) => Tab(text: name)).toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          children: tabs.map((String name) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Builder(
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
                            itemExtent: name == "Mission" ? 170.0 : 80,
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return name == "Mission"
                                    ? const TabContentCommunityComponentApp()
                                    : const TabContentCommunityLeaderBoardComponentApp();
                              },
                              childCount: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
