/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

class RecoveryEmailBottomSheetApp extends StatelessWidget {
  const RecoveryEmailBottomSheetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RecoveryEmailBottomSheet(),
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

class RecoveryEmailBottomSheet extends StatefulWidget {
  const RecoveryEmailBottomSheet({
    super.key,
  });

  @override
  State<RecoveryEmailBottomSheet> createState() =>
      _RecoveryEmailBottomSheetState();
}

class _RecoveryEmailBottomSheetState extends State<RecoveryEmailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Change Recovery Email",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Would you like to change the recovery email address from dummy@mail.com?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 32,
            ),
            CustomButton(
                buttonText: 'Continue with Gmail',
                onPressed: () {},
                buttonIcon: "ic_google.png",
                isOutlined: true,
                sizeButtonIcon: 20,
                width: 500,
                paddingButton: 0),
            const SizedBox(
              height: 24,
            ),
            CustomButton(
                buttonText: 'with Apple ID',
                isOutlined: true,
                onPressed: () {},
                buttonIcon: "ic_apple.png",
                sizeButtonIcon: 20,
                width: 500,
                paddingButton: 0),
          ],
        ),
        // This is the title in the app bar.
      ),
    ));
  }
}
