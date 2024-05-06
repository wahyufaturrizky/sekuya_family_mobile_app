/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

class BadgeListBottomSheetApp extends StatelessWidget {
  const BadgeListBottomSheetApp({super.key, this.detailProfile});

  final dynamic detailProfile;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BadgeListBottomSheet(detailProfile: detailProfile),
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

class BadgeListBottomSheet extends StatefulWidget {
  const BadgeListBottomSheet({super.key, this.detailProfile});

  final dynamic detailProfile;

  @override
  State<BadgeListBottomSheet> createState() => _BadgeListBottomSheetState();
}

class _BadgeListBottomSheetState extends State<BadgeListBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: const BoxDecoration(
                  color: blackSolidPrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Column(
                children: [
                  const Text(
                    "Display on your profile",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        spacing: 24,
                        children: [1, 2, 3]
                            .map(
                              (item) => Image.asset(
                                "assets/images/empty_badge.png",
                                height: 40,
                                width: 40,
                              ),
                            )
                            .toList(),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Collection Badge",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
                height: 260,
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16),
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          color: Colors.black,
                          child: InkWell(
                              splashColor: yellowPrimaryColor.withAlpha(30),
                              onTap: () {},
                              child: Container(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      "assets/images/empty_badge.png",
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Center(
                                      child: Text(
                                    "Badge",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  )),
                                ],
                              ))));
                    })),
          ],
        ),
        // This is the title in the app bar.
      ),
    ));
  }
}
