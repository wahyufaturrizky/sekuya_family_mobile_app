/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/spinner.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

class NotificationApp extends StatelessWidget {
  const NotificationApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Notification();
  }
}

class Notification extends StatefulWidget {
  const Notification({
    super.key,
  });

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  bool isLoadingResNotification = false;

  @override
  Widget build(BuildContext context) {
    if (isLoadingResNotification) {
      return const MyWidgetSpinnerApp();
    } else {
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          title: const Text(
            'Notification',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text('April 2022',
                        style: TextStyle(
                            color: greySoftSecondaryColor,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              Column(
                  children: List.generate(
                      5,
                      (index) => Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                                color: goldenSoftColor,
                                border: Border.symmetric(
                                    horizontal: BorderSide(
                                        color: greySoftFourthColor, width: 1))),
                            child: const Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Mission',
                                      style: TextStyle(
                                        color: goldenColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      '15 minute ago',
                                      style: TextStyle(
                                        color: greySoftThirdColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Mission Complete',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Congratulations! You've successfully completed your mission. Your dedication and effort have paid off. Well done!",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )))
            ],
          ),
          // This is the title in the app bar.
        )),
      ));
    }
  }
}
