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
import 'package:sekuya_family_mobile_app/components/spinner.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/service/profile/profile.dart';

class ProfileDetailBottomSheetApp extends StatelessWidget {
  const ProfileDetailBottomSheetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ProfileDetailBottomSheet(),
      theme: ThemeData(
        canvasColor: Colors.black,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: yellowPrimaryColor.withOpacity(0.2),
          cursorColor: yellowPrimaryColor,
          selectionHandleColor: yellowPrimaryColor,
        ),
      ),
    );
  }
}

class ProfileDetailBottomSheet extends StatefulWidget {
  const ProfileDetailBottomSheet({super.key});

  @override
  State<ProfileDetailBottomSheet> createState() =>
      _ProfileDetailBottomSheetState();
}

class _ProfileDetailBottomSheetState extends State<ProfileDetailBottomSheet> {
  bool isLoadingGetProfile = false;
  bool isLoadingCommunities = false;

  var resMyCommunities;
  var resProfile;
  @override
  void initState() {
    super.initState();
    getDataProfile();
    getDataMyCommunities();
  }

  Future<dynamic> getDataProfile() async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingGetProfile = true;
        });
      }

      var res = await handleGetDataProfile();

      if (res != null) {
        if (mounted) {
          setState(() {
            resProfile = res;
            isLoadingGetProfile = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingGetProfile = false;
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

  @override
  Widget build(BuildContext context) {
    var isLoading = isLoadingGetProfile || isLoadingCommunities;
    if (isLoading) {
      return const MyWidgetSpinner();
    } else {
      return SafeArea(
          child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
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
                      if (resProfile?["data"]?["profilePic"] != null)
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(resProfile?["data"]?["profilePic"]),
                          radius: 40,
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
                          backgroundImage:
                              NetworkImage('https://i.pravatar.cc/150?img=1'),
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
                          image: AssetImage('assets/images/bg_progress_xp.png'),
                          fit: BoxFit.fill)),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Communities',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 150,
                child: ListView(
                  // This next line does the trick.
                  scrollDirection: Axis.horizontal,
                  children: resMyCommunities != null
                      ? (resMyCommunities?["data"]?["data"] as List<dynamic>)
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
                                                  item?["name"] ?? "",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              if (item != null)
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    item?["total_mission"]
                                                            .toString() ??
                                                        "",
                                                    item?["total_players"]
                                                            .toString() ??
                                                        "",
                                                    item["level"].toString() ??
                                                        ""
                                                  ]
                                                      .map((item) => Row(
                                                            children: [
                                                              Image.asset(
                                                                  'assets/images/ic_count.png'),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text(
                                                                item,
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
                                                )
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
          // This is the title in the app bar.
        ),
      ));
    }
  }
}
