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
import 'package:sekuya_family_mobile_app/components/tab_voucher/my_voucher.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/screens/private/profile_detail.dart';

class VoucherDetailApp extends StatelessWidget {
  const VoucherDetailApp({super.key, this.args});

  final MyArgumentsDataDetailVoucherClass? args;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VoucherDetail(args: args),
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

class VoucherDetail extends StatefulWidget {
  const VoucherDetail({super.key, this.args});

  final MyArgumentsDataDetailVoucherClass? args;

  @override
  State<VoucherDetail> createState() => _VoucherDetailState();
}

class _VoucherDetailState extends State<VoucherDetail> {
  late String username;
  bool isLoading = false;

  List<Map<String, Object>> expandRule = [
    {
      "title": "Term and Conditions",
      "rule": [
        "Voucher ini Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
        "Voucher ini Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
        "Voucher ini Lorem ipsum dolor sit amet, consectetur adipiscing elit."
      ],
    },
    {
      "title": "How to use",
      "rule": [
        "Voucher ini Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
        "Voucher ini Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
        "Voucher ini Lorem ipsum dolor sit amet, consectetur adipiscing elit."
      ],
    },
  ];

  void handleBack() {
    final arguments = MyArgumentsDataClass(false, false, true);

    Application.router.navigateTo(context, "/privateScreens",
        transition: TransitionType.inFromLeft,
        routeSettings: RouteSettings(arguments: arguments));

    setState(() {
      isLoading = false;
    });
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
          'Detail Voucher',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/bg_jco.png',
              fit: BoxFit.cover,
              width: double.infinity,
              alignment: Alignment.topCenter,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Voucher lorem ipsum dolor',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white),
            ),
            const Text(
              'Check out various interesting voucher.',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: greySecondaryColor),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: greyColor,
                  child: Image.asset('assets/images/ic_jco.png'),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  'J.Coffee',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
                children: expandRule.asMap().entries.map((item) {
              return Builder(builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                      shape: Border.all(color: Colors.transparent),
                      iconColor: Colors.white,
                      title: Text(
                        item.value["title"].toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                      children: (item.value["rule"] != null)
                          ? (item.value["rule"] as List<dynamic>)
                              .map((itemRule) => ListTile(
                                      title: Text(
                                    itemRule,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  )))
                              .toList()
                          : []),
                );
              });
            }).toList())
          ],
        ),
        // This is the title in the app bar.
      ),
    ));
  }
}
