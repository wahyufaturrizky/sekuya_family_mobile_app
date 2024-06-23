import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/spinner.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/featured_community.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/service/profile/profile.dart';

class ProfileDetailBottomSheetApp extends StatelessWidget {
  const ProfileDetailBottomSheetApp({super.key, this.detailProfile});

  final dynamic detailProfile;

  @override
  Widget build(BuildContext context) {
    return ProfileDetailBottomSheet(detailProfile: detailProfile);
  }
}

class ProfileDetailBottomSheet extends StatefulWidget {
  const ProfileDetailBottomSheet({super.key, this.detailProfile});

  final dynamic detailProfile;

  @override
  State<ProfileDetailBottomSheet> createState() => _ProfileDetailBottomSheetState();
}

class _ProfileDetailBottomSheetState extends State<ProfileDetailBottomSheet> {
  bool isLoadingGetDetailProfile = false;

  var resDetailProfile;
  @override
  void initState() {
    super.initState();
    getDataDetailProfile();
  }

  void goToDetailCommunity(data, index) {
    final arguments = MyArgumentsDataDetailCommunityClass(data, index);

    Application.router.navigateTo(context, "/communityDetailScreens", transition: TransitionType.native, routeSettings: RouteSettings(arguments: arguments));
  }

  Future<dynamic> getDataDetailProfile() async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingGetDetailProfile = true;
        });
      }

      final String id = widget.detailProfile?["_id"];

      var res = await handleGetDataDetailProfile(id);

      if (res != null) {
        if (mounted) {
          setState(() {
            resDetailProfile = res;
            isLoadingGetDetailProfile = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingGetDetailProfile = false;
        });
      }

      print('Error getDataProfile = $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = isLoadingGetDetailProfile;

    var dataDetailProfile = resDetailProfile?["data"];
    var profilePic = dataDetailProfile?["profilePic"];
    var username = dataDetailProfile?["username"];
    var email = dataDetailProfile?["email"];
    var level = dataDetailProfile?["level"];
    var exp = dataDetailProfile?["exp"];
    var nextExp = dataDetailProfile?["nextExp"];
    var communities = dataDetailProfile?["communities"];

    if (isLoading) {
      return const MyWidgetSpinnerApp();
    } else {
      return SafeArea(
          child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 135,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF5D5D5D),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 25),
              Column(
                children: [
                  if (profilePic != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(profilePic),
                      radius: 40,
                    ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (username != null)
                    Text(
                      username ?? "",
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  if (email != null)
                    Text(
                      email.substring(0, 14),
                      style: const TextStyle(color: greySecondaryColor, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              // Wrap(
              //   alignment: WrapAlignment.center,
              //   spacing: 16.0,
              //   children: [1, 2, 3]
              //       .map((item) => const CircleAvatar(
              //             backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1'),
              //             radius: 20,
              //           ))
              //       .toList(),
              // ),
              const SizedBox(
                height: 16,
              ),
              Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/bg_progress_xp.png'), fit: BoxFit.fill)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Level ${level}',
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${exp} xp',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      LinearProgressIndicator(
                        value: nextExp * 0.01,
                        color: yellowPrimaryColor,
                        backgroundColor: greyThirdColor,
                      )
                    ],
                  )),
              const SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Communities',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.only(left: 16),
                    height: 150,
                    child: ListView(
                      // This next line does the trick.
                      scrollDirection: Axis.horizontal,
                      children: communities != null
                          ? (communities as List<dynamic>).map((item) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Card(
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
                                        width: 230,
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
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(boxShadow: [BoxShadow(color: blackSolidPrimaryColor, spreadRadius: 15, blurRadius: 15)]),
                                              child: Column(
                                                children: [
                                                  if (item?["name"] != null)
                                                    Text(
                                                      item?["name"] ?? "",
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                                    ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  if (item != null)
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        {
                                                          "title": "total mission",
                                                          "value": item?["totalMission"].toString(),
                                                        },
                                                        {
                                                          "title": "total players",
                                                          "value": item?["totalPlayers"].toString(),
                                                        },
                                                        {
                                                          "title": "level",
                                                          "value": item?["level"].toString(),
                                                        },
                                                      ]
                                                          .map((item) => Row(
                                                                children: [
                                                                  Image.asset(item["title"] == "total mission"
                                                                      ? 'assets/images/ic_total_mission.png'
                                                                      : item["title"] == "total players"
                                                                          ? 'assets/images/ic_total_player.png'
                                                                          : 'assets/images/ic_level_community.png'),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    item["value"].toString(),
                                                                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
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
              ),
            ],
          ),
          // This is the title in the app bar.
        ),
      ));
    }
  }
}
