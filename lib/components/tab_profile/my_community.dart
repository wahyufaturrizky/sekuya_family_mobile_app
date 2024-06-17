import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/featured_community.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
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
  void goToDetailCommunity() {
    final arguments = MyArgumentsDataDetailCommunityClass(
        widget.resMyCommunities, widget.index);

    Application.router.navigateTo(context, "/communityDetailScreens",
        transition: TransitionType.native,
        routeSettings: RouteSettings(arguments: arguments));
  }

  @override
  Widget build(BuildContext context) {
    var dataCommunity =
        widget.resMyCommunities?["data"]?["data"]?[widget.index];

    var image = dataCommunity?["image"];
    var name = dataCommunity?["name"];
    var description = dataCommunity?["description"];
    var totalMission = dataCommunity?["totalMission"];
    var totalPlayers = dataCommunity?["totalPlayers"];
    var level = dataCommunity?["level"];

    return Card(
      color: blackPrimaryColor,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        splashColor: yellowPrimaryColor.withAlpha(30),
        onTap: () {
          if (widget.resMyCommunities != null) {
            goToDetailCommunity();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (image != null)
                    Image.network(
                      image,
                      width: 32,
                      height: 32,
                    ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    name ?? "",
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
                description ?? "",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  {
                    "title": "total mission",
                    "value": totalMission.toString(),
                  },
                  {
                    "title": "total players",
                    "value": totalPlayers.toString(),
                  },
                  {
                    "title": "level",
                    "value": level.toString(),
                  },
                ]
                    .map((item) => Row(
                          children: [
                            Image.asset(item["title"] == "total mission"
                                ? 'assets/images/ic_total_mission.png'
                                : item["title"] == "total players"
                                    ? 'assets/images/ic_total_player.png'
                                    : 'assets/images/ic_level_community.png'),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              item["value"].toString(),
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
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
