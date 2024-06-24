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

import '../avatar_stack_widget.dart';

class TabContentMissionComponentApp extends StatelessWidget {
  const TabContentMissionComponentApp({super.key, this.resMission, this.index});

  final dynamic resMission;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return TabContentMissionComponent(resMission: resMission, index: index);
  }
}

class TabContentMissionComponent extends StatefulWidget {
  const TabContentMissionComponent({super.key, this.resMission, this.index});

  final dynamic resMission;
  final int? index;

  @override
  State<TabContentMissionComponent> createState() =>
      _TabContentMissionComponentState();
}

class _TabContentMissionComponentState
    extends State<TabContentMissionComponent> {
  void goToDetailMission() {
    final arguments =
        MyArgumentsDataDetailMissionClass(widget.resMission, widget.index);

    Application.router.navigateTo(context, "/detailMissionScreen",
        transition: TransitionType.native,
        routeSettings: RouteSettings(arguments: arguments));
  }

  var dataMission;

  var rewards;
  var id;
  var name;
  var status;
  var community;
  var totalTasks;
  var totalExp;
  var totalPlayers;
  var playerSamples;

  @override
  void initState() {
    dataMission = widget.resMission[widget.index];
    rewards = dataMission?["rewards"];
    id = dataMission?["_id"];
    name = dataMission?["name"];
    status = dataMission?["status"];
    community = dataMission?["community"];
    totalTasks = dataMission?["totalTasks"];
    totalExp = dataMission?["totalExp"];
    totalPlayers = dataMission?["totalPlayers"];
    playerSamples = dataMission?["playerSamples"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: blackPrimaryColor,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(bottom: 16.0),
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
              padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (name != null)
                        SizedBox(
                          width: 210,
                          child: Text(
                            name ?? "",
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
                            community?["image"],
                            width: 16,
                            height: 16,
                          ),
                        ),
                      const SizedBox(
                        width: 8,
                      ),
                      if (community?["name"] != null)
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.6,
                          child: Text(
                            community?["name"] ?? "",
                            style: const TextStyle(
                              color: greySecondaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
                          "icon": "",
                        },
                        {
                          "title": "Xp",
                          "amount": totalExp.toString(),
                          "icon": "",
                        },
                        {
                          "title": rewards != null && rewards.isNotEmpty
                              ? rewards?[0]?["name"]
                              : "",
                          "amount": rewards != null && rewards.isNotEmpty
                              ? rewards?[0]?["maxQty"]
                              : "",
                          "icon": rewards != null && rewards.isNotEmpty
                              ? rewards?[0]?["image"]
                              : "",
                        }
                      ]
                          .map(
                            (item) => Container(
                              margin: const EdgeInsets.only(right: 20),
                              child: Row(
                                children: [
                                  if (item["icon"] != "" &&
                                      item["icon"] != null)
                                    Container(
                                      margin: const EdgeInsets.only(right: 4),
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.transparent,
                                        child: Image.network(
                                          item["icon"],
                                          width: 16,
                                          height: 16,
                                        ),
                                      ),
                                    ),
                                  Text(
                                    item["amount"].toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    item["title"] ?? "",
                                    style: const TextStyle(
                                      color: greySecondaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    if (totalPlayers != null)
                      AvatarStack(
                        height: 24,
                        width: totalPlayers > 2 ? 50 : 30,
                        borderColor: Colors.transparent,
                        borderWidth: 0,
                        avatars: [
                          for (var n = 0; n < totalPlayers; n++)
                            NetworkImage(
                              playerSamples?[n]?["profilePic"],
                            ),
                        ],
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

class MyArgumentsDataDetailMissionClass {
  final dynamic resMission;
  final int? indexResMission;

  MyArgumentsDataDetailMissionClass(
    this.resMission,
    this.indexResMission,
  );
}
