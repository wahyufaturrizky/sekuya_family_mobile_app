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
import 'package:sekuya_family_mobile_app/screens/private/profile_detail_bottom_sheet.dart';

class TabContentCommunityLeaderBoardComponentApp extends StatelessWidget {
  const TabContentCommunityLeaderBoardComponentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabContentCommunityLeaderBoardComponent();
  }
}

class TabContentCommunityLeaderBoardComponent extends StatefulWidget {
  const TabContentCommunityLeaderBoardComponent({super.key});

  @override
  State<TabContentCommunityLeaderBoardComponent> createState() =>
      _TabContentCommunityLeaderBoardComponentState();
}

class _TabContentCommunityLeaderBoardComponentState
    extends State<TabContentCommunityLeaderBoardComponent> {
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
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return const ProfileDetailBottomSheetApp();
              });
        },
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '1st',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      CircleAvatar(
                        radius: 12,
                        backgroundImage:
                            NetworkImage('https://i.pravatar.cc/150?img=1'),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Wahyu Fatur Rizki',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Text(
                    '1000xp',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
