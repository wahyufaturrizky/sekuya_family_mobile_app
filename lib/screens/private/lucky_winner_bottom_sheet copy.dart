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

class LuckyWinnerBottomSheetApp extends StatelessWidget {
  const LuckyWinnerBottomSheetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LuckyWinnerBottomSheet(),
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

class LuckyWinnerBottomSheet extends StatefulWidget {
  const LuckyWinnerBottomSheet({super.key});

  @override
  State<LuckyWinnerBottomSheet> createState() => _LuckyWinnerBottomSheetState();
}

class _LuckyWinnerBottomSheetState extends State<LuckyWinnerBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Lucky Winner',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              ExpansionTile(
                  iconColor: Colors.white,
                  collapsedBackgroundColor: blackPrimaryColor,
                  backgroundColor: blackPrimaryColor,
                  title: const Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            NetworkImage('https://i.pravatar.cc/150?img=1'),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bessie Cooper',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.check_circle,
                        color: greenColor,
                      )
                    ],
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration:
                          const BoxDecoration(color: blackSolidPrimaryColor),
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(
                                      'https://i.pravatar.cc/150?img=1'),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'full name',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Text(
                              '1 BTC',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ]),
                    ),
                  ]),
            ],
          ),
          // This is the title in the app bar.
        ),
      ),
    ));
  }
}
