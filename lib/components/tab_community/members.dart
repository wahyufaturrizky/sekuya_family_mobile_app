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
  const TabContentCommunityMembersComponentApp(
      {super.key, this.resCommunitiesMembers, this.index});

  final dynamic resCommunitiesMembers;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return TabContentCommunityMembersComponent(
        resCommunitiesMembers: resCommunitiesMembers, index: index);
  }
}

class TabContentCommunityMembersComponent extends StatefulWidget {
  const TabContentCommunityMembersComponent(
      {super.key, this.resCommunitiesMembers, this.index});

  final dynamic resCommunitiesMembers;
  final int? index;

  @override
  State<TabContentCommunityMembersComponent> createState() =>
      _TabContentCommunityMembersComponentState();
}

class _TabContentCommunityMembersComponentState
    extends State<TabContentCommunityMembersComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: blackPrimaryColor, width: 1),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        splashColor: yellowPrimaryColor.withAlpha(30),
        onTap: () {
          debugPrint('Card tapped.');

          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return ProfileDetailBottomSheetApp(
                    detailProfile: widget.resCommunitiesMembers?["data"]
                        ?["data"]?[widget.index]);
              });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (widget.resCommunitiesMembers?["data"]?["data"]
                              ?[widget.index]?["profilePic"] !=
                          null)
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(
                              widget.resCommunitiesMembers?["data"]?["data"]
                                      ?[widget.index]?["profilePic"] ??
                                  ""),
                        ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        widget.resCommunitiesMembers?["data"]?["data"]
                                ?[widget.index]?["username"] ??
                            "",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Text(
                    '${widget.resCommunitiesMembers?["data"]?["data"]?[widget.index]?["exp"] ?? ""} xp',
                    style: const TextStyle(
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
