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
    var dataMyReward = widget.resMyReward?["data"]?["data"]?[widget.index];
    var image = dataMyReward["image"];
    var name = dataMyReward["name"];
    var status = dataMyReward["status"];
    var description = dataMyReward["description"];

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
              padding: const EdgeInsets.only(
                  left: 12, top: 12, right: 12, bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (image != null)
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.transparent,
                          child: Image.network(image),
                        ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        name ?? "",
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
                        status ?? "",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      // GestureDetector(
                      //     onTap: () {},
                      //     child: Image.asset("assets/images/ic_copy.png"))
                    ],
                  )
                ],
              ),
            ),
            Container(
              color: blackSolidPrimaryColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(children: [
                  if (description != null)
                    Expanded(
                        child: Text(
                      "${description?.length > 18 ? description?.substring(0, 18) : description}",
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
