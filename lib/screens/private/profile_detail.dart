/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dio = Dio();

class ProfileDetailApp extends StatelessWidget {
  const ProfileDetailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ProfileDetail(),
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

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({super.key});

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  late String username;
  bool isLoading = false;
  var resProfile;

  @override
  void initState() {
    super.initState();
    handleGetDataProfile();
  }

  Future<dynamic> handleGetDataProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final accessToken = prefs.getString('access_token') ?? '';

      if (accessToken != '') {
        final response = await dio.get('$baseUrl/profile/info',
            options: Options(headers: {
              'Authorization': 'Bearer $accessToken',
            }));

        var decodeJsonRes = jsonDecode(response.toString());
        print(decodeJsonRes);

        setState(() {
          resProfile = decodeJsonRes;
        });
      }
    } catch (e) {
      print('Error get dashboard =  $e');
    }
  }

  void handleBack() {
    final arguments = MyArgumentsDataClass(true, false, false, false);

    Application.router.navigateTo(context, "/privateScreens",
        transition: TransitionType.inFromLeft,
        routeSettings: RouteSettings(arguments: arguments));

    setState(() {
      isLoading = false;
    });
  }

  Future<dynamic> handleUpdateProfile() async {
    try {
      setState(() {
        isLoading = true;
      });
      handleBack();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            handleBack();
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
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
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://i.pravatar.cc/150?img=1'),
                      radius: 40,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Username',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextField(
              textField: TextField(
                  onChanged: (value) {
                    username = value;
                  },
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  decoration: kTextInputDecoration.copyWith(
                    hintText: 'Username',
                    hintStyle: const TextStyle(color: greySecondaryColor),
                  )),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Email Address',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextField(
              textField: TextField(
                  onChanged: (value) {
                    username = value;
                  },
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  decoration: kTextInputDecoration.copyWith(
                    hintText: 'Email address',
                    hintStyle: const TextStyle(color: greySecondaryColor),
                  )),
            ),
            Column(
              children: [
                {"title": "Connect to Discord", "icon": "ic_discord.png"},
                {"title": "Connect to Telegram", "icon": "ic_telegram.png"},
                {"title": "Connect to Twitter", "icon": "ic_twitter.png"},
              ]
                  .map((item) => Column(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Hero(
                            tag: item["title"] ?? "",
                            child: CustomButton(
                                isOutlinedBackgroundColor: greyDarkColor,
                                buttonText: item["title"] ?? "",
                                isOutlined: true,
                                onPressed: () {},
                                sizeButtonIcon: 20,
                                buttonIcon: item["icon"] ?? "",
                                width: 500,
                                paddingButton: 0),
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ],
        ),
        // This is the title in the app bar.
      ),
      bottomSheet: Container(
          color: Colors.black,
          child: CustomButton(
              isLoading: isLoading,
              buttonText: 'Save',
              onPressed: () {
                if (!isLoading) {
                  handleUpdateProfile();
                }
              },
              sizeButtonIcon: 20,
              width: 500,
              paddingButton: 0)),
    ));
  }
}

class MyArgumentsDataClass {
  final bool goToProfile;
  final bool goToCommunity;
  final bool goToVoucher;
  final bool goToMission;

  MyArgumentsDataClass(
      this.goToProfile, this.goToCommunity, this.goToVoucher, this.goToMission);
}
