/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/material.dart';

class DemoMessageComponent extends StatelessWidget {
  DemoMessageComponent(
      {required this.message, this.color = const Color(0xFFFFFFFF)});

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: this.color,
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontFamily: "Lazer84",
          ),
        ),
      ),
    );
  }
}
