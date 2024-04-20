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
import 'package:flutter/widgets.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

class TabContentCommunityComponent extends StatelessWidget {
  const TabContentCommunityComponent({
    super.key,
  });

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
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mission ipsumece dolor sit amet',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      Chip(
                          label: const Text(
                            'On Going',
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
                        child: Image.asset('assets/images/ic_apple.png'),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        'NFT Communities',
                        style: TextStyle(
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
                        "amount": "10",
                        "icon": "false",
                      },
                      {
                        "title": "Xp",
                        "amount": "120",
                        "icon": "false",
                      },
                      {
                        "title": "USDT",
                        "amount": "250",
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
                                  item["amount"]!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  item["title"]!,
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
                      for (var n = 0; n < 5; n++) NetworkImage(getAvatarUrl(n))
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

String getAvatarUrl(int n) {
  final url = 'https://i.pravatar.cc/150?img=$n';
  // final url = 'https://robohash.org/$n?bgset=bg1';
  return url;
}
