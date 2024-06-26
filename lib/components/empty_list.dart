/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

class MyWidgetEmptyListApp extends StatelessWidget {
  const MyWidgetEmptyListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyWidgetEmptyList();
  }
}

class MyWidgetEmptyList extends StatefulWidget {
  const MyWidgetEmptyList({super.key});

  @override
  State<MyWidgetEmptyList> createState() => _MyWidgetEmptyListState();
}

class _MyWidgetEmptyListState extends State<MyWidgetEmptyList> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Image.asset(
          'assets/images/empty_state.png',
        ),
        const SizedBox(
          width: 250,
          child: Text(
            "Looks like there's nothing here yet. Start exploring to fill this space",
            style: TextStyle(color: greySecondaryColor, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        )
      ],
    ));
  }
}
