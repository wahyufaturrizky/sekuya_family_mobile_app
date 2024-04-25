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
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

class TabContentCommunityFeaturedComponentApp extends StatelessWidget {
  const TabContentCommunityFeaturedComponentApp({super.key, this.item = 0});

  final int item;

  @override
  Widget build(BuildContext context) {
    return TabContentCommunityFeaturedComponent(item: item);
  }
}

class TabContentCommunityFeaturedComponent extends StatefulWidget {
  const TabContentCommunityFeaturedComponent({super.key, this.item = 0});

  final int item;

  @override
  State<TabContentCommunityFeaturedComponent> createState() =>
      _TabContentCommunityFeaturedComponentState();
}

class _TabContentCommunityFeaturedComponentState
    extends State<TabContentCommunityFeaturedComponent> {
  void goToDetailCommunity() {
    final arguments = MyArgumentsDataDetailCommunityClass(widget.item);

    Application.router.navigateTo(context, "/communityDetailScreens",
        transition: TransitionType.native,
        routeSettings: RouteSettings(arguments: arguments));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: blackPrimaryColor,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        splashColor: yellowPrimaryColor.withAlpha(30),
        onTap: () {
          goToDetailCommunity();
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset('assets/images/ic_crypto.png'),
                  const SizedBox(
                    width: 12,
                  ),
                  const Text(
                    '1000xp',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Description lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor ',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: ['22', '122', '102']
                    .map((item) => Row(
                          children: [
                            Image.asset('assets/images/ic_count.png'),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              item,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                          ],
                        ))
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyArgumentsDataDetailCommunityClass {
  final int id;

  MyArgumentsDataDetailCommunityClass(
    this.id,
  );
}
