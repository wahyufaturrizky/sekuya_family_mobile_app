import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/components/shimmer_loading.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/featured_community.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/leaderboard.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/members.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/mission.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/screens/private/profile_detail.dart';
import 'package:sekuya_family_mobile_app/service/community/community.dart';
import 'package:sekuya_family_mobile_app/util/format_date.dart';
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

class _CommunityComponentDetailState extends State<CommunityComponentDetail>
    with SingleTickerProviderStateMixin {
  bool isLoadingJoinCommunity = false;
  bool isLoadingLeaveCommunity = false;
  bool isJoinCommunity = false;
  bool isJoined = false;

  bool isLoadingCommunitiesMissions = false;
  bool isLoadingCommunitiesMembers = false;
  bool isLoadingCommunitiesLeaderboards = false;
  bool isLoadingCommunitiesDetail = false;

  bool refetchCommunitiesMissions = false;
  bool refetchCommunitiesMembers = false;
  bool refetchCommunitiesLeaderboards = false;
  bool refetchCommunitiesDetail = false;

  var resCommunitiesDetail;
  var resCommunitiesMissions;
  var resCommunitiesMembers;
  var resCommunitiesLeaderboards;

  final List<String> tabs = <String>['Mission', 'Leaderboard', 'Members'];
  late TabController tabController;

  @override
  void initState() {
    getDataCommunitiesDetail();
    getDataCommunitiesMissions();
    getDataCommunitiesMembers();
    getDataCommunitiesLeaderboards();

    tabController = TabController(vsync: this, length: tabs.length);

    super.initState();
  }

  Future<dynamic> getDataCommunitiesDetail({refetch = false}) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          if (refetch) {
            refetchCommunitiesDetail = true;
          } else {
            isLoadingCommunitiesDetail = true;
          }
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
            refetchCommunitiesDetail = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingCommunitiesDetail = false;
          refetchCommunitiesDetail = false;
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
        transition: TransitionType.inFromRight,
        routeSettings: RouteSettings(arguments: arguments));
  }

  Future<void> _launchUrl(val) async {
    if (val == "" || val == null || val.isEmpty || !val.contains("http")) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: blackSolidPrimaryColor,
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 16,
              ),
              Text('Warning!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
              SizedBox(
                height: 8,
              ),
              Text('Social account link is not valid',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: greySecondaryColor)),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            CustomButton(
              buttonText: 'OK',
              onPressed: () {
                Navigator.pop(context, 'OK');
              },
              labelSize: 12,
              height: 36,
              width: 120,
            ),
          ],
        ),
      );
    } else {
      final Uri url = Uri.parse(val);

      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  Future<dynamic> handleJoinCommunity(context) async {
    try {
      setState(() {
        isLoadingJoinCommunity = true;
      });

      String id = widget.args?.resCommunities?["data"]?["data"]
          ?[widget.args?.indexResCommunities]["_id"];

      var res = await handleJoinCommunities(id: id);

      if (res != null) {
        getDataCommunitiesDetail(refetch: true);

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
        getDataCommunitiesDetail(refetch: true);

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
    var isLoading = isLoadingCommunitiesDetail ||
        isLoadingCommunitiesLeaderboards ||
        isLoadingCommunitiesMissions ||
        isLoadingCommunitiesMembers;

    var dataCommunitiesDetail = resCommunitiesDetail?["data"];

    var coverImage = dataCommunitiesDetail?["coverImage"];
    var image = dataCommunitiesDetail?["image"];
    var name = dataCommunitiesDetail?["name"];
    var level = dataCommunitiesDetail?["level"];
    var totalMission = dataCommunitiesDetail?["totalMission"];
    var totalPlayers = dataCommunitiesDetail?["totalPlayers"];
    var description = dataCommunitiesDetail?["description"];
    var social = dataCommunitiesDetail?["social"];
    var createdAt = dataCommunitiesDetail?["createdAt"];

    List<Map<String, String>> headerCards = [
      {
        "title": "Mission",
        "value": totalMission.toString(),
      },
      {
        "title": "Members",
        "value": totalPlayers.toString(),
      },
      {
        "title": "Created",
        "value": handleFormatDate(createdAt.toString()),
      },
    ];

    return Scaffold(
        backgroundColor: Colors.black,
        body: Shimmer(
          linearGradient: shimmerGradient,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  height: MediaQuery.of(context).size.width * 0.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: coverImage != null
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                coverImage,
                              ))
                          : null),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 32, left: 16),
                        color: backNavigationColor,
                        child: IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            // handleBack();
                            Navigator.pop(context, 'Cancel');
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              spreadRadius: 15,
                              blurRadius: 15,
                              offset: Offset(0, 42))
                        ]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (isLoading)
                                MyWidgetShimmerApp(
                                    isLoading: isLoading,
                                    child: const Card(
                                      child: SizedBox(
                                        height: 40,
                                        width: 150,
                                      ),
                                    )),
                              if (!isLoading)
                                Row(
                                  children: [
                                    if (image != null)
                                      Image.network(
                                        image,
                                        width: 48,
                                        height: 48,
                                      ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
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
                                            if (level != null)
                                              Text(
                                                'LEVEL $level',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              MyWidgetShimmerApp(
                                isLoading: isLoading,
                                child: CustomButton(
                                  isOutlined: isJoined,
                                  isOutlinedBackgroundColor: isJoined
                                      ? Colors.transparent
                                      : blackSolidPrimaryColor,
                                  isOutlinedBorderColor: yellowPrimaryColor,
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
                                        handleLeaveCommunity(mainContext);
                                      } else {
                                        handleJoinCommunity(mainContext);
                                      }
                                    }
                                  },
                                  isLoading: isLoadingJoinCommunity ||
                                      isLoadingCommunitiesDetail ||
                                      isLoadingLeaveCommunity,
                                  width: 60,
                                  labelSize: 12,
                                  height: 32,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
              const SizedBox(
                height: 16,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        children: headerCards.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, String> item = entry.value;
                          return Expanded(
                              flex: 1,
                              child: MyWidgetShimmerApp(
                                isLoading: isLoading,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: index == 0 ? 0 : 8,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: blackSolidPrimaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (item["value"] != null &&
                                          item["value"]!.isNotEmpty)
                                        Text(
                                          item["value"]!.length > 8
                                              ? "${item["value"]!.substring(0, 8)}..."
                                              : item["value"]!,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        item["title"]!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: greySecondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        }).toList(),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (description != null)
                        Text(
                          maxLines: 3,
                          description.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Row(
                        children: [
                          Text(
                            'Social Media',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (social != null && social.isNotEmpty && !isLoading)
                        Row(
                            children: (social as Map<String, dynamic>)
                                .entries
                                .map((item) {
                          return Builder(
                            builder: (BuildContext context) {
                              return MyWidgetShimmerApp(
                                  isLoading: isLoading,
                                  child: GestureDetector(
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
                                      )));
                            },
                          );
                        }).toList()),
                    ],
                  )),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                height: 5,
                width: double.infinity,
                color: blackSolidPrimaryColor,
              ),
              TabBar(
                controller: tabController,
                labelStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                labelColor: yellowPrimaryColor,
                unselectedLabelColor: greySecondaryColor,
                dividerColor: blackPrimaryColor,
                overlayColor:
                    MaterialStateProperty.all<Color>(yellowPrimaryColor),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: const BoxDecoration(
                    color: yellowPrimaryTransparentColor,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(4), bottom: Radius.circular(0))),
                tabs: tabs
                    .map((String name) => Tab(
                            child: Text(
                          name,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        )))
                    .toList(),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
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
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            color: Colors.black,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                    child: ListView.builder(
                                        itemCount: name == "Mission"
                                            ? childCountCommunitiesMissions
                                            : name == "Leaderboard"
                                                ? childCountCommunitiesLeaderboards
                                                : childCountCommunitiesMembers,
                                        itemBuilder:
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
                                        }))
                              ],
                            ));
                      },
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ));
  }
}
