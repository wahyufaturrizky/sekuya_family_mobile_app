/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

class TabContentProfileMyCommunityComponentApp extends StatelessWidget {
  const TabContentProfileMyCommunityComponentApp(
      {super.key, this.resMyCommunities, this.index});

  final dynamic resMyCommunities;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return TabContentProfileMyCommunityComponent(
        resMyCommunities: resMyCommunities, index: index);
  }
}

class TabContentProfileMyCommunityComponent extends StatefulWidget {
  const TabContentProfileMyCommunityComponent(
      {super.key, this.resMyCommunities, this.index});

  final dynamic resMyCommunities;
  final int? index;

  @override
  State<TabContentProfileMyCommunityComponent> createState() =>
      _TabContentProfileMyCommunityComponentState();
}

class _TabContentProfileMyCommunityComponentState
    extends State<TabContentProfileMyCommunityComponent> {
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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.network(
                    widget.resMyCommunities?["data"]?["data"]?[widget.index]
                            ?["image"] ??
                        "",
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    widget.resMyCommunities?["data"]?["data"]?[widget.index]
                            ?["name"] ??
                        "",
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
                widget.resMyCommunities?["data"]?["data"]?[widget.index]
                        ?["description"] ??
                    "",
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
                  widget.resMyCommunities?["data"]?["data"]?[widget.index]
                              ?["total_mission"]
                          .toString() ??
                      "",
                  widget.resMyCommunities?["data"]?["data"]?[widget.index]
                              ?["total_players"]
                          .toString() ??
                      "",
                  widget.resMyCommunities?["data"]?["data"]?[widget.index]
                              ?["level"]
                          .toString() ??
                      ""
                ]
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
