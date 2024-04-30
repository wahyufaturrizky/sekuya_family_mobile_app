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
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/components/spinner.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/featured_community.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/leaderboard.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/members.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/mission.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/screens/private/profile_detail.dart';
import 'package:sekuya_family_mobile_app/service/community/community.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool isLoadingJoinCommunity = false;
  bool isLoadingLeaveCommunity = false;
  bool isLoadingCommunitiesDetail = false;
  bool isJoinCommunity = false;
  bool isJoined = false;
  bool isLoadingCommunitiesMissions = false;
  bool isLoadingCommunitiesMembers = false;
  bool isLoadingCommunitiesLeaderboards = false;

  var resCommunitiesDetail;
  var resCommunitiesMissions;
  var resCommunitiesMembers;
  var resCommunitiesLeaderboards;

  final List<String> tabs = <String>['Mission', 'Leaderboard', 'Members'];

  @override
  void initState() {
    super.initState();
    getDataCommunitiesDetail();
    getDataCommunitiesMissions();
    getDataCommunitiesMembers();
    getDataCommunitiesLeaderboards();
  }

  Future<dynamic> getDataCommunitiesDetail() async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingCommunitiesDetail = true;
        });
      }

      String id = widget.args?.resCommunities?["data"]?["data"]
          ?[widget.args?.indexResCommunities]["_id"];

      var res = await handleGetDataCommunitiesDetail(id);

      if (res != null) {
        if (mounted) {
          setState(() {
            resCommunitiesDetail = res;
            isJoined = res?["data"]?["isJoined"];
            isLoadingCommunitiesDetail = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingCommunitiesDetail = false;
        });
      }

      print('Error handleGetDataCommunitiesDetail = $e');
    }
  }

  Future<dynamic> getDataCommunitiesMissions() async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingCommunitiesMissions = true;
        });
      }

      String id = widget.args?.resCommunities?["data"]?["data"]
          ?[widget.args?.indexResCommunities]["_id"];

      var res = await handleGetDataCommunitiesMissions(id);

      if (res != null) {
        if (mounted) {
          setState(() {
            resCommunitiesMissions = res;
            isLoadingCommunitiesMissions = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingCommunitiesMissions = false;
        });
      }

      print('Error getDataCommunitiesMissions = $e');
    }
  }

  Future<dynamic> getDataCommunitiesLeaderboards() async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingCommunitiesLeaderboards = true;
        });
      }

      String id = widget.args?.resCommunities?["data"]?["data"]
          ?[widget.args?.indexResCommunities]["_id"];

      var res = await handleGetDataCommunitiesLeaderboards(id);

      if (res != null) {
        if (mounted) {
          setState(() {
            resCommunitiesLeaderboards = res;
            isLoadingCommunitiesLeaderboards = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingCommunitiesLeaderboards = false;
        });
      }

      print('Error getDataCommunitiesLeaderboards = $e');
    }
  }

  Future<dynamic> getDataCommunitiesMembers() async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingCommunitiesMembers = true;
        });
      }

      String id = widget.args?.resCommunities?["data"]?["data"]
          ?[widget.args?.indexResCommunities]["_id"];

      var res = await handleGetDataCommunitiesMembers(id);

      if (res != null) {
        if (mounted) {
          setState(() {
            resCommunitiesMembers = res;
            isLoadingCommunitiesMembers = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingCommunitiesMembers = false;
        });
      }

      print('Error getDataCommunitiesMembers = $e');
    }
  }

  void handleBack() {
    final arguments = MyArgumentsDataClass(false, true, false, false);

    Application.router.navigateTo(context, "/privateScreens",
        transition: TransitionType.inFromLeft,
        routeSettings: RouteSettings(arguments: arguments));
  }

  Future<void> _launchUrl(val) async {
    final Uri url = Uri.parse(val);

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<dynamic> handleJoinCommunity(context) async {
    try {
      setState(() {
        isLoadingJoinCommunity = true;
      });

      String id = widget.args?.resCommunities?["data"]?["data"]
          ?[widget.args?.indexResCommunities]["_id"];

      var res = await handleJoinCommunities(id);

      if (res != null) {
        getDataCommunitiesDetail();

        const snackBar = SnackBar(
            backgroundColor: yellowPrimaryColor,
            behavior: SnackBarBehavior.floating,
            duration: Duration(milliseconds: 2000),
            content: Text(
              "👋🏻 Success join community",
              style: TextStyle(color: blackSolidPrimaryColor),
            ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        setState(() {
          isLoadingJoinCommunity = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingJoinCommunity = false;
      });
      print(e);
    }
  }

  Future<dynamic> handleLeaveCommunity(context) async {
    try {
      setState(() {
        isLoadingLeaveCommunity = true;
      });

      String id = widget.args?.resCommunities?["data"]?["data"]
          ?[widget.args?.indexResCommunities]["_id"];

      var res = await handleLeaveCommunities(id);

      if (res != null) {
        getDataCommunitiesDetail();

        const snackBar = SnackBar(
            backgroundColor: yellowPrimaryColor,
            behavior: SnackBarBehavior.floating,
            duration: Duration(milliseconds: 2000),
            content: Text(
              "⛹️ Success leave community",
              style: TextStyle(color: blackSolidPrimaryColor),
            ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        setState(() {
          isLoadingLeaveCommunity = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingLeaveCommunity = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext mainContext) {
    var isLoading = isLoadingCommunitiesMissions ||
        isLoadingCommunitiesLeaderboards ||
        isLoadingCommunitiesMembers;

    if (isLoading) {
      return const MyWidgetSpinner();
    } else {
      return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: DefaultTabController(
              length: tabs.length, // This is the number of tabs.
              child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  // These are the slivers that show up in the "outer" scroll view.
                  return <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverAppBar(
                        automaticallyImplyLeading: false,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                if (widget.args?.resCommunities?["data"]
                                                    ?["data"]?[
                                                widget
                                                    .args?.indexResCommunities]
                                            ["coverImage"] !=
                                        null &&
                                    !widget
                                        .args
                                        ?.resCommunities?["data"]?["data"]
                                            ?[widget.args?.indexResCommunities]
                                            ["coverImage"]
                                        .contains("googleapis"))
                                  Image.network(
                                    widget.args?.resCommunities?["data"]
                                                ?["data"]
                                            ?[widget.args?.indexResCommunities]
                                        ["coverImage"],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 150,
                                  ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      color: Colors.white,
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: () {
                                        handleBack();
                                      },
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            if (widget.args?.resCommunities?["data"]
                                                                ?["data"]?[
                                                            widget.args
                                                                ?.indexResCommunities]
                                                        ["image"] !=
                                                    null &&
                                                !widget
                                                    .args
                                                    ?.resCommunities?["data"]
                                                        ?["data"]?[widget.args
                                                            ?.indexResCommunities]
                                                        ["image"]
                                                    .contains("googleapis"))
                                              Image.network(
                                                widget.args?.resCommunities?[
                                                            "data"]?["data"]?[
                                                        widget.args
                                                            ?.indexResCommunities]
                                                    ["image"],
                                                width: 48,
                                                height: 48,
                                              ),
                                            const SizedBox(width: 12),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.args?.resCommunities?[
                                                                      "data"]
                                                                  ?["data"]
                                                              ?[
                                                              widget.args
                                                                  ?.indexResCommunities]
                                                          ["name"] ??
                                                      "",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/ic_level_detail_community.png',
                                                    ),
                                                    const SizedBox(width: 12),
                                                    const Text(
                                                      'LEVEL 4',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        CustomButton(
                                          buttonText: (isLoadingJoinCommunity ||
                                                  isLoadingCommunitiesDetail ||
                                                  isLoadingLeaveCommunity)
                                              ? ''
                                              : isJoined
                                                  ? 'Leave'
                                                  : 'Join',
                                          onPressed: () {
                                            if (!isLoadingJoinCommunity ||
                                                !isLoadingCommunitiesDetail ||
                                                !isLoadingLeaveCommunity) {
                                              if (isJoined) {
                                                handleLeaveCommunity(
                                                    mainContext);
                                              } else {
                                                handleJoinCommunity(
                                                    mainContext);
                                              }
                                            }
                                          },
                                          isLoading: isLoadingJoinCommunity ||
                                              isLoadingCommunitiesDetail ||
                                              isLoadingLeaveCommunity,
                                          width: 100,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
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
                              {
                                "title": "Mission",
                                "value": widget
                                    .args
                                    ?.resCommunities?["data"]?["data"]
                                        ?[widget.args?.indexResCommunities]
                                        ["totalMission"]
                                    .toString(),
                              },
                              {
                                "title": "Members",
                                "value": widget
                                    .args
                                    ?.resCommunities?["data"]?["data"]
                                        ?[widget.args?.indexResCommunities]
                                        ["totalPlayers"]
                                    .toString(),
                              },
                              {
                                "title": "Created",
                                "value": widget
                                    .args
                                    ?.resCommunities?["data"]?["data"]
                                        ?[widget.args?.indexResCommunities]
                                        ["level"]
                                    .toString(),
                              },
                            ]
                                    .map((item) => Expanded(
                                            child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: blackSolidPrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item["value"].toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                item["title"].toString(),
                                                style: const TextStyle(
                                                    color: greySecondaryColor,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )
                                            ],
                                          ),
                                        )))
                                    .toList()),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              widget.args?.resCommunities?["data"]?["data"]
                                          ?[widget.args?.indexResCommunities]
                                      ["description"] ??
                                  "",
                              style: const TextStyle(
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
                                children: (widget.args?.resCommunities?["data"]
                                                ?["data"]
                                            ?[widget.args?.indexResCommunities]
                                        ?["social"] as Map<String, dynamic>)
                                    .entries
                                    .map((item) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                      onTap: () {
                                        _launchUrl(item.value);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: blackSolidPrimaryColor,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              item.key == "discord"
                                                  ? 'assets/images/ic_discord_community.png'
                                                  : item.key == "instagram"
                                                      ? 'assets/images/ic_instagram.png'
                                                      : item.key == "facebook"
                                                          ? 'assets/images/ic_facebook.png'
                                                          : 'assets/images/ic_twitter_social.png',
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              '0',
                                              style: TextStyle(
                                                  color: yellowPrimaryColor,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ));
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
                          tabs: tabs
                              .map((String name) => Tab(text: name))
                              .toList(),
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: tabs.map((String name) {
                    var childCountCommunitiesMissions =
                        resCommunitiesMissions?["data"]?["data"] != null
                            ? resCommunitiesMissions?["data"]?["data"]?.length
                            : 0;

                    var childCountCommunitiesLeaderboards =
                        resCommunitiesLeaderboards?["data"]?["data"] != null
                            ? resCommunitiesLeaderboards?["data"]?["data"]
                                ?.length
                            : 0;

                    var childCountCommunitiesMembers =
                        resCommunitiesMembers?["data"]?["data"] != null
                            ? resCommunitiesMembers?["data"]?["data"]?.length
                            : 0;

                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          color: Colors.black,
                          child: CustomScrollView(
                            key: PageStorageKey<String>(name),
                            slivers: <Widget>[
                              SliverOverlapInjector(
                                handle: NestedScrollView
                                    .sliverOverlapAbsorberHandleFor(context),
                              ),
                              SliverPadding(
                                padding: const EdgeInsets.all(8.0),
                                sliver: SliverFixedExtentList(
                                  itemExtent: name == "Mission" ? 170.0 : 80,
                                  delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                    return name == "Mission"
                                        ? TabContentCommunityMissionsComponentApp(
                                            resCommunitiesMissions:
                                                resCommunitiesMissions,
                                            index: index)
                                        : name == "Leaderboard"
                                            ? TabContentCommunityLeaderBoardComponentApp(
                                                resCommunitiesLeaderboards:
                                                    resCommunitiesLeaderboards,
                                                index: index)
                                            : TabContentCommunityMembersComponentApp(
                                                resCommunitiesMembers:
                                                    resCommunitiesMembers,
                                                index: index);
                                  },
                                      childCount: name == "Mission"
                                          ? childCountCommunitiesMissions
                                          : name == "Leaderboard"
                                              ? childCountCommunitiesLeaderboards
                                              : childCountCommunitiesMembers),
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
            ),
          ));
    }
  }
}
