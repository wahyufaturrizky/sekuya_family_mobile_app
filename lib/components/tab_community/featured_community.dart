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
    var dataCommunity = widget.resCommunities?["data"]?["data"]?[widget.index];
    var image = dataCommunity?["image"];
    var name = dataCommunity?["name"];
    var description = dataCommunity?["description"];
    var totalMission = dataCommunity?["totalMission"];
    var totalPlayers = dataCommunity?["totalPlayers"];
    var level = dataCommunity?["level"];

    return Card(
      color: blackPrimaryColor,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        splashColor: yellowPrimaryColor.withAlpha(30),
        onTap: () {
          if (widget.resCommunities != null) {
            goToDetailCommunity();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (image != null)
                    Image.network(
                      image ?? "",
                      width: 32,
                      height: 32,
                    ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    name ?? "",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                description ?? "",
                maxLines: 2,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  {
                    "title": "total mission",
                    "value": totalMission.toString(),
                  },
                  {
                    "title": "total players",
                    "value": totalPlayers.toString(),
                  },
                  {
                    "title": "level",
                    "value": level.toString(),
                  },
                ]
                    .map((item) => Row(
                          children: [
                            Image.asset(item["title"] == "total mission"
                                ? 'assets/images/ic_total_mission.png'
                                : item["title"] == "total players"
                                    ? 'assets/images/ic_total_player.png'
                                    : 'assets/images/ic_level_community.png'),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              item["value"].toString(),
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
