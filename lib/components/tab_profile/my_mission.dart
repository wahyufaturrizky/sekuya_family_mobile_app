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
import 'package:sekuya_family_mobile_app/components/tab_mission/mission.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

import '../avatar_stack_widget.dart';

class TabContentProfileMyMissionComponentApp extends StatelessWidget {
  const TabContentProfileMyMissionComponentApp(
      {super.key, this.resMyMission, this.index});

  final dynamic resMyMission;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return TabContentProfileMyMissionComponent(
        resMyMission: resMyMission, index: index);
  }
}

class TabContentProfileMyMissionComponent extends StatefulWidget {
  const TabContentProfileMyMissionComponent(
      {super.key, this.resMyMission, this.index});

  final dynamic resMyMission;
  final int? index;

  @override
  State<TabContentProfileMyMissionComponent> createState() =>
      _TabContentProfileMyMissionComponentState();
}

class _TabContentProfileMyMissionComponentState
    extends State<TabContentProfileMyMissionComponent> {
  void goToDetailMission() {
    final arguments =
        MyArgumentsDataDetailMissionClass(widget.resMyMission, widget.index);

    Application.router.navigateTo(context, "/detailMissionScreen",
        transition: TransitionType.native,
        routeSettings: RouteSettings(arguments: arguments));
  }

  @override
  Widget build(BuildContext context) {
    var dataMyMission = widget.resMyMission?["data"]?["data"]?[widget.index];

    var id = dataMyMission?["_id"];
    var name = dataMyMission?["name"];
    var status = dataMyMission?["status"];
    var rewards = dataMyMission?["rewards"];
    var community = dataMyMission?["community"];
    var totalTasks = dataMyMission?["totalTasks"];
    var totalExp = dataMyMission?["totalExp"];
    var playerSamples = dataMyMission?["playerSamples"];

    return Card(
      color: blackPrimaryColor,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        splashColor: yellowPrimaryColor.withAlpha(30),
        onTap: () {
          if (id != null) {
            goToDetailMission();
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (name != null)
                        SizedBox(
                          width: 180,
                          child: Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: status
                                  .toString()
                                  .toLowerCase()
                                  .contains('completed')
                              ? greenColor.withOpacity(0.2)
                              : const Color(0xFF2AB6F2).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Center(
                          child: Text(
                            status ?? "",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: status
                                      .toString()
                                      .toLowerCase()
                                      .contains('completed')
                                  ? greenColor
                                  : blueSolidSecondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (community?["image"] != null)
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.transparent,
                          child: Image.network(
                            community?["image"] ?? "",
                            width: 16,
                            height: 16,
                          ),
                        ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        community?["name"] ?? "",
                        style: const TextStyle(
                            color: greySecondaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: blackSolidPrimaryColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        {
                          "title": "Task",
                          "amount": totalTasks.toString(),
                          "icon": null,
                        },
                        {
                          "title": "Xp",
                          "amount": totalExp.toString(),
                          "icon": null,
                        },
                        {
                          "title": rewards != null && rewards.isNotEmpty
                              ? "${rewards?[0]?["name"].substring(0, 3)}"
                              : '',
                          "amount": rewards != null && rewards.isNotEmpty
                              ? rewards?[0]?["maxQty"]
                              : '',
                          "icon": rewards != null && rewards.isNotEmpty
                              ? rewards?[0]?["image"]
                              : null,
                        }
                      ]
                          .map(
                            (item) => Container(
                              margin: const EdgeInsets.only(right: 20),
                              child: Row(
                                children: [
                                  if (item["icon"] != null)
                                    Row(
                                      children: [
                                        CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.transparent,
                                            child: Image.network(
                                              item["icon"],
                                              width: 14,
                                              height: 14,
                                            )),
                                      ],
                                    ),
                                  Text(
                                    item["amount"].toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    item["title"] ?? "",
                                    style: const TextStyle(
                                        color: greySecondaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    Flexible(
                      child: AvatarStack(
                        height: 24,
                        borderColor: Colors.transparent,
                        avatars: [
                          if (playerSamples != null && playerSamples.isNotEmpty)
                            for (var n = 0; n < (playerSamples?.length); n++)
                              NetworkImage(
                                playerSamples[n]?["profilePic"],
                              )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getAvatarUrl({indexMyMissions, indexDisplayPlayers, resMyMission}) {
  final url = resMyMission?["data"]?["data"]?[indexMyMissions]
      ?["display_players"]?[indexDisplayPlayers]?["image"];

  if (url != null) {
    return url;
  } else {
    return "";
  }
}
