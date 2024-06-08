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
  const TabContentCommunityLeaderBoardComponentApp(
      {super.key, this.resCommunitiesLeaderboards, this.index});

  final dynamic resCommunitiesLeaderboards;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return TabContentCommunityLeaderBoardComponent(
        resCommunitiesLeaderboards: resCommunitiesLeaderboards, index: index);
  }
}

class TabContentCommunityLeaderBoardComponent extends StatefulWidget {
  const TabContentCommunityLeaderBoardComponent(
      {super.key, this.resCommunitiesLeaderboards, this.index});

  final dynamic resCommunitiesLeaderboards;
  final int? index;

  @override
  State<TabContentCommunityLeaderBoardComponent> createState() =>
      _TabContentCommunityLeaderBoardComponentState();
}

class _TabContentCommunityLeaderBoardComponentState
    extends State<TabContentCommunityLeaderBoardComponent> {
  @override
  Widget build(BuildContext context) {
    var indexingRank = widget.index! + 1;
    var rank = indexingRank == 1
        ? '${indexingRank}st'
        : indexingRank == 2
            ? '${indexingRank}nd'
            : indexingRank == 3
                ? '${indexingRank}rd'
                : '${indexingRank}th';
    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(4),
          border: widget.index == 0 || widget.index == 1 || widget.index == 2
              ? Border(
                  top: BorderSide(
                    color: widget.index == 0
                        ? yellowPrimaryColor
                        : widget.index == 1
                            ? greySecondWinnerColor
                            : redThirdWinnerColor,
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: widget.index == 0
                        ? yellowPrimaryColor
                        : widget.index == 1
                            ? greySecondWinnerColor
                            : redThirdWinnerColor,
                    width: 1,
                  ),
                  right: BorderSide(
                    color: widget.index == 0
                        ? yellowPrimaryColor
                        : widget.index == 1
                            ? greySecondWinnerColor
                            : redThirdWinnerColor,
                    width: 1,
                  ),
                  left: BorderSide(
                    color: widget.index == 0
                        ? yellowPrimaryColor
                        : widget.index == 1
                            ? greySecondWinnerColor
                            : redThirdWinnerColor,
                    width: 8,
                  ),
                )
              : Border.all(
                  color: blackPrimaryColor,
                  width: 1,
                )),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        splashColor: yellowPrimaryColor.withAlpha(30),
        onTap: () {
          debugPrint('Card tapped.');
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.black,
              builder: (BuildContext context) {
                return ProfileDetailBottomSheetApp(
                    detailProfile: widget.resCommunitiesLeaderboards?["data"]
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
                      if (widget.index == 0 ||
                          widget.index == 1 ||
                          widget.index == 2)
                        Container(
                            margin: const EdgeInsets.only(right: 4),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.transparent,
                              backgroundImage: AssetImage(
                                  'assets/images/ic_${widget.index}.png'),
                            )),
                      Text(
                        rank,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      if (widget.resCommunitiesLeaderboards?["data"]?["data"]
                              ?[widget.index]?["profilePic"] !=
                          null)
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(
                              widget.resCommunitiesLeaderboards?["data"]
                                  ?["data"]?[widget.index]?["profilePic"]),
                        ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        widget.resCommunitiesLeaderboards?["data"]?["data"]
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
                    '${widget.resCommunitiesLeaderboards?["data"]?["data"]?[widget.index]?["exp"].toString() ?? ""} xp',
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
