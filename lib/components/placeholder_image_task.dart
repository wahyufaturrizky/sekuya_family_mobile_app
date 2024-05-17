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

class PlaceholderImageTaskApp extends StatelessWidget {
  const PlaceholderImageTaskApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PlaceholderImageTask();
  }
}

class PlaceholderImageTask extends StatefulWidget {
  const PlaceholderImageTask({
    super.key,
  });

  @override
  State<PlaceholderImageTask> createState() => _PlaceholderImageTaskState();
}

class _PlaceholderImageTaskState extends State<PlaceholderImageTask> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: greyColor,
          width: 2,
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Add Image',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 8,
          ),
          Icon(Icons.add, color: Colors.white)
        ],
      ),
    );
  }
}
