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

class MyWidgetSpinnerApp extends StatelessWidget {
  const MyWidgetSpinnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyWidgetSpinner();
  }
}

class MyWidgetSpinner extends StatefulWidget {
  const MyWidgetSpinner({super.key});

  @override
  State<MyWidgetSpinner> createState() => _MyWidgetSpinnerState();
}

class _MyWidgetSpinnerState extends State<MyWidgetSpinner> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(
          color: yellowPrimaryColor,
        ),
      ),
    );
  }
}
