import 'package:avatar_stack/avatar_stack.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/tab_mission/mission.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

class TabContentCommunityMissionsComponentApp extends StatelessWidget {
  const TabContentCommunityMissionsComponentApp(
      {super.key, this.resCommunitiesMissions, this.index});

  final dynamic resCommunitiesMissions;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return TabContentCommunityMissionsComponent(
        resCommunitiesMissions: resCommunitiesMissions, index: index);
  }
}

class TabContentCommunityMissionsComponent extends StatefulWidget {
  const TabContentCommunityMissionsComponent(
      {super.key, this.resCommunitiesMissions, this.index});

  final dynamic resCommunitiesMissions;
  final int? index;

  @override
  State<TabContentCommunityMissionsComponent> createState() =>
      _TabContentCommunityMissionsComponentState();
}

class _TabContentCommunityMissionsComponentState
    extends State<TabContentCommunityMissionsComponent> {
  void goToDetailMission() {
    final arguments = MyArgumentsDataDetailMissionClass(
        widget.resCommunitiesMissions, widget.index);

    Application.router.navigateTo(context, "/detailMissionScreen",
        transition: TransitionType.native,
        routeSettings: RouteSettings(arguments: arguments));
  }

  @override
  Widget build(BuildContext context) {
    var dataCommunitiesMissions =
        widget.resCommunitiesMissions?["data"]?["data"]?[widget.index];
    var name = dataCommunitiesMissions?["name"];
    var status = dataCommunitiesMissions?["status"];
    var community = dataCommunitiesMissions?["community"];
    var totalTasks = dataCommunitiesMissions?["totalTasks"];
    var totalExp = dataCommunitiesMissions?["totalExp"];
    var rewards = dataCommunitiesMissions?["rewards"];
    var totalPlayers = dataCommunitiesMissions?["totalPlayers"];
    var playerSamples = dataCommunitiesMissions?["playerSamples"];
    var id = dataCommunitiesMissions?["_id"];

    return Card(
      color: blackPrimaryColor,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(bottom: 12),
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
                        Text(
                          name ?? "",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      if (status != null)
                        Chip(
                            label: Text(
                              status ?? "",
                            ),
                            color: MaterialStateProperty.all<Color>(
                                blueSecondaryColor),
                            labelStyle: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: blueSolidSecondaryColor),
                            shape: const StadiumBorder(
                                side: BorderSide(color: Colors.transparent)))
                    ],
                  ),
                  if (widget.resCommunitiesMissions != null)
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.transparent,
                          child: community?["image"] != null
                              ? Image.network(community?["image"])
                              : null,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          community?["name"] ?? "",
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
            widget.resCommunitiesMissions != null
                ? Container(
                    color: blackSolidPrimaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(children: [
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
                                  : null,
                              "amount": rewards != null && rewards.isNotEmpty
                                  ? rewards?[0]?["maxQty"]
                                  : null,
                              "icon": rewards != null && rewards.isNotEmpty
                                  ? rewards?[0]?["image"]
                                  : null,
                            }
                          ]
                              .map(
                                (item) => Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    children: [
                                      if (item["icon"] != "")
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 4),
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.transparent,
                                            child: item["icon"] != null
                                                ? Image.network(item["icon"])
                                                : null,
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
                        if (playerSamples != null &&
                            playerSamples.isNotEmpty &&
                            totalPlayers > 1)
                          Flexible(
                              child: AvatarStack(
                            height: 24,
                            avatars: [
                              for (var n = 0; n < totalPlayers; n++)
                                NetworkImage(playerSamples?[n]?["profilePic"])
                            ],
                          ))
                      ]),
                    ),
                  )
                : Container(),
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
