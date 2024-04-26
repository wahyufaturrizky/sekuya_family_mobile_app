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
  const TabContentCommunityFeaturedComponentApp(
      {super.key, this.index, this.resCommunities});

  final dynamic resCommunities;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return TabContentCommunityFeaturedComponent(
        resCommunities: resCommunities, index: index);
  }
}

class TabContentCommunityFeaturedComponent extends StatefulWidget {
  const TabContentCommunityFeaturedComponent(
      {super.key, this.index, this.resCommunities});

  final dynamic resCommunities;
  final int? index;

  @override
  State<TabContentCommunityFeaturedComponent> createState() =>
      _TabContentCommunityFeaturedComponentState();
}

class _TabContentCommunityFeaturedComponentState
    extends State<TabContentCommunityFeaturedComponent> {
  void goToDetailCommunity() {
    final arguments = MyArgumentsDataDetailCommunityClass(
        widget.resCommunities, widget.index);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // if (widget.resCommunities?["data"]?["data"]?[widget.index]
                  //         ?["image"] !=
                  //     null)
                  //   Image.network(
                  //     widget.resCommunities?["data"]?["data"]?[widget.index]
                  //             ?["image"] ??
                  //         "",
                  //     width: 32,
                  //     height: 32,
                  //   ),
                  const SizedBox(
                    width: 12,
                  ),
                  // Text(
                  //   widget.resCommunities?["data"]?["data"]?[widget.index]
                  //           ?["name"] ??
                  //       "",
                  //   style: const TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w500),
                  // ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              // Text(
              //   widget.resCommunities?["data"]?["data"]?[widget.index]
              //           ?["description"] ??
              //       "",
              //   style: const TextStyle(
              //       color: Colors.white,
              //       fontSize: 12,
              //       fontWeight: FontWeight.w500),
              // ),
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
  final dynamic resCommunities;
  final int? indexResCommunities;

  MyArgumentsDataDetailCommunityClass(
    this.resCommunities,
    this.indexResCommunities,
  );
}
