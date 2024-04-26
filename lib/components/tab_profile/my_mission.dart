/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

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
  @override
  Widget build(BuildContext context) {
    return Card(
      color: blackPrimaryColor,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        splashColor: yellowPrimaryColor.withAlpha(30),
        onTap: () {
          debugPrint('Card tapped.');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.resMyMission?["data"]?["data"]?[widget.index]
                                ?["name"] ??
                            "",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      Chip(
                          label: Text(
                            widget.resMyMission?["data"]?["data"]?[widget.index]
                                    ?["status"] ??
                                "",
                          ),
                          color: MaterialStateProperty.all<Color>(
                              bluePrimaryColor.withOpacity(0.2)),
                          labelStyle: const TextStyle(color: bluePrimaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.transparent,
                        child: Image.network(widget.resMyMission?["data"]
                                ?["data"]?[widget.index]?["reward"]?["image"] ??
                            ""),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        widget.resMyMission?["data"]?["data"]?[widget.index]
                                ?["community_name"] ??
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
                        "amount": widget.resMyMission?["data"]?["data"]
                                    ?[widget.index]?["total_task"]
                                .toString() ??
                            "",
                        "icon": "false",
                      },
                      {
                        "title": "Xp",
                        "amount": widget.resMyMission?["data"]?["data"]
                                    ?[widget.index]?["reward_exp"]
                                .toString() ??
                            "",
                        "icon": "false",
                      },
                      {
                        "title": "USDT",
                        "amount": RegExp(r'(\d+)')
                                .firstMatch(widget.resMyMission?["data"]
                                            ?["data"]?[widget.index]?["reward"]
                                        ?["name"] ??
                                    "")
                                ?.group(0) ??
                            "",
                        "icon": "true",
                      }
                    ]
                        .map(
                          (item) => Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                if (item["icon"] == "true")
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.transparent,
                                        child: Image.asset(
                                            'assets/images/ic_apple.png'),
                                      ),
                                    ],
                                  ),
                                Text(
                                  item["amount"] ?? "",
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
                    avatars: [
                      for (var n = 0;
                          n <
                              widget
                                  .resMyMission?["data"]?["data"]?[widget.index]
                                      ?["display_players"]
                                  ?.length;
                          n++)
                        NetworkImage(getAvatarUrl(
                            indexMyMissions: widget.index,
                            indexDisplayPlayers: n,
                            resMyMission: widget.resMyMission))
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

String getAvatarUrl({indexMyMissions, indexDisplayPlayers, resMyMission}) {
  final url = resMyMission?["data"]?["data"]?[indexMyMissions]
      ?["display_players"]?[indexDisplayPlayers]?["image"];
  return url;
}
