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

class TabContentCommunityMembersComponentApp extends StatelessWidget {
  const TabContentCommunityMembersComponentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabContentCommunityMembersComponent();
  }
}

class TabContentCommunityMembersComponent extends StatefulWidget {
  const TabContentCommunityMembersComponent({super.key});

  @override
  State<TabContentCommunityMembersComponent> createState() =>
      _TabContentCommunityMembersComponentState();
}

class _TabContentCommunityMembersComponentState
    extends State<TabContentCommunityMembersComponent> {
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
                return const ProfileDetailBottomSheet();
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
