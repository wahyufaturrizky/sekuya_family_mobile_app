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
import 'package:url_launcher/url_launcher.dart';

Future<void> handleLaunchUrl({context, val}) async {
  if (val == "" || val == null || val.isEmpty || !val.contains("http")) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: blackSolidPrimaryColor,
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 16,
            ),
            Text('Warning!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
            SizedBox(
              height: 8,
            ),
            Text('Social account link is not valid',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: greySecondaryColor)),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          CustomButton(
            buttonText: 'OK',
            onPressed: () {
              Navigator.pop(context, 'OK');
            },
            labelSize: 12,
            height: 36,
            width: 120,
          ),
        ],
      ),
    );
  } else {
    final Uri url = Uri.parse(val);

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
