/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:avatar_stack/avatar_stack.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

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

  @override
  Widget build(BuildContext context) {
    var dataMission = widget.resMission?["data"]?["data"]?[widget.index];

    var rewards = dataMission?["rewards"];

    return Card(
      color: blackPrimaryColor,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        splashColor: yellowPrimaryColor.withAlpha(30),
        onTap: () {
          if (widget.resMission?["data"]?["data"]?[widget.index]?["_id"] !=
              null) {
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
                      if (widget.resMission?["data"]?["data"]?[widget.index]
                              ?["name"] !=
                          null)
                        Text(
                          widget
                                      .resMission?["data"]?["data"]
                                          ?[widget.index]?["name"]
                                      ?.length >
                                  20
                              ? widget.resMission?["data"]?["data"]
                                          ?[widget.index]?["name"]
                                      .substring(0, 20) +
                                  "..."
                              : widget.resMission?["data"]?["data"]
                                      ?[widget.index]?["name"] ??
                                  "",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      Chip(
                          label: Text(
                            widget.resMission?["data"]?["data"]?[widget.index]
                                    ?["status"] ??
                                "",
                          ),
                          color: MaterialStateProperty.all<Color>(
                              blueSecondaryColor),
                          labelStyle:
                              const TextStyle(color: blueSolidSecondaryColor),
                          shape: const StadiumBorder(
                              side: BorderSide(color: Colors.transparent)))
                    ],
                  ),
                  Row(
                    children: [
                      if (widget.resMission?["data"]?["data"]?[widget.index]
                              ?["community"]?["image"] !=
                          null)
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.transparent,
                          child: Image.network(widget.resMission?["data"]
                              ?["data"]?[widget.index]?["community"]?["image"]),
                        ),
                      const SizedBox(
                        width: 8,
                      ),
                      if (widget.resMission?["data"]?["data"]?[widget.index]
                              ?["community"]?["name"] !=
                          null)
                        Text(
                          widget
                                      .resMission?["data"]?["data"]
                                          ?[widget.index]?["community"]?["name"]
                                      ?.length >
                                  15
                              ? widget.resMission?["data"]["data"]
                                          ?[widget.index]?["community"]?["name"]
                                      .substring(0, 15) +
                                  "..."
                              : widget.resMission?["data"]["data"]
                                      ?[widget.index]?["community"]?["name"] ??
                                  "",
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
                child: Row(children: [
                  Row(
                    children: [
                      {
                        "title": "Task",
                        "amount": widget.resMission?["data"]?["data"]
                                    ?[widget.index]?["totalTasks"]
                                .toString() ??
                            "",
                        "icon": "",
                      },
                      {
                        "title": "Xp",
                        "amount": widget.resMission?["data"]?["data"]
                                    ?[widget.index]?["totalExp"]
                                .toString() ??
                            "",
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
                            margin: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                if (item["icon"] != "" && item["icon"] != null)
                                  Container(
                                    margin: const EdgeInsets.only(right: 4),
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.transparent,
                                      child: Image.network(item["icon"]),
                                    ),
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
                  if (widget.resMission?["data"]?["data"]?[widget.index]
                          ?["totalPlayers"] !=
                      null)
                    Flexible(
                        child: AvatarStack(
                      height: 24,
                      avatars: [
                        for (var n = 0;
                            n <
                                widget.resMission?["data"]?["data"]
                                    ?[widget.index]?["totalPlayers"];
                            n++)
                          NetworkImage(widget.resMission?["data"]?["data"]
                                  ?[widget.index]?["playerSamples"]?[n]
                              ?["profilePic"])
                      ],
                    ))
                ]),
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
