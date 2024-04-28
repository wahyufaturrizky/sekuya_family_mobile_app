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

class TabContentProfileMyRewardComponentApp extends StatelessWidget {
  const TabContentProfileMyRewardComponentApp(
      {super.key, this.resMyReward, this.index});

  final dynamic resMyReward;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return TabContentProfileMyRewardComponent(
        resMyReward: resMyReward, index: index);
  }
}

class TabContentProfileMyRewardComponent extends StatefulWidget {
  const TabContentProfileMyRewardComponent(
      {super.key, this.resMyReward, this.index});

  final dynamic resMyReward;
  final int? index;

  @override
  State<TabContentProfileMyRewardComponent> createState() =>
      _TabContentProfileMyRewardComponentState();
}

class _TabContentProfileMyRewardComponentState
    extends State<TabContentProfileMyRewardComponent> {
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
                      Row(
                        children: [
                          if (widget.resMyReward?["data"]?["data"]
                                  ?[widget.index]?["reward"]?["image"] !=
                              null)
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.transparent,
                              child: Image.network(widget.resMyReward?["data"]
                                          ?["data"]?[widget.index]?["reward"]
                                      ?["image"] ??
                                  ""),
                            ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.resMyReward?["data"]?["data"]?[widget.index]
                                    ?["name"] ??
                                "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            widget.resMyReward?["data"]?["data"]?[widget.index]
                                    ?["name"] ??
                                "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                              onTap: () {},
                              child: Image.asset("assets/images/ic_copy.png"))
                        ],
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
                  Expanded(
                      child: Text(
                    widget.resMyReward?["data"]?["data"]?[widget.index]
                            ?["description"] ??
                        "",
                    style: const TextStyle(
                        color: greySecondaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
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

String getAvatarUrl({indexMyMissions, indexDisplayPlayers, resMyReward}) {
  final url = resMyReward?["data"]?["data"]?[indexMyMissions]
      ?["display_players"]?[indexDisplayPlayers]?["image"];

  if (url != null) {
    return url;
  } else {
    return "";
  }
}
