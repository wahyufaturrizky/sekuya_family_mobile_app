import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/leaderboard.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/mission.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

class CommunityComponentApp extends StatelessWidget {
  const CommunityComponentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommunityComponent();
  }
}

class CommunityComponent extends StatefulWidget {
  const CommunityComponent({super.key});

  @override
  State<CommunityComponent> createState() => _CommunityComponentState();
}

class _CommunityComponentState extends State<CommunityComponent> {
  final List<String> tabs = <String>['Mission', 'Leaderboard', 'Members'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length, // This is the number of tabs.
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Image.asset(
                            'assets/images/banner_home.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/ic_community.png',
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'NFT Communities',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/ic_chart.png',
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'LEVEL 4',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: blackSolidPrimaryColor,
                                borderRadius: BorderRadius.circular(4)),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '2',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Mission',
                                  style: TextStyle(
                                      color: greySecondaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          )),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: blackSolidPrimaryColor,
                                borderRadius: BorderRadius.circular(4)),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '2',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Members',
                                  style: TextStyle(
                                      color: greySecondaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          )),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: blackSolidPrimaryColor,
                                borderRadius: BorderRadius.circular(4)),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '2',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Created',
                                  style: TextStyle(
                                      color: greySecondaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'dictum cursus mauris varius tristique aliquet. Morbi cursus urna in nibh diam dolor lacus sit. Tristique rhoncus amet a congue laoreet amet sodales. Laoreet integer nullam pharetra maecenas sit. Purus adipiscing turpis vestibulum interdum egestas. Ornare tincidunt nunc orci',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Social Media',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                          children: [
                        {"title": "abc", "like": "1.8K"},
                        {"title": "abc", "like": "1.8K"},
                        {"title": "abc", "like": "1.8K"},
                        {"title": "abc", "like": "1.8K"},
                      ].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: blackSolidPrimaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/ic_discord.png',
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    i["like"]!,
                                    style: const TextStyle(
                                        color: yellowPrimaryColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList()),
                    ],
                  ),
                  // This is the title in the app bar.
                  floating: true,
                  expandedHeight: 360.0,
                  toolbarHeight: 360,
                  backgroundColor: Colors.black,
                  // The "forceElevated" property causes the SliverAppBar to show
                  // a shadow. The "innerBoxIsScrolled" parameter is true when the
                  // inner scroll view is scrolled beyond its "zero" point, i.e.
                  // when it appears to be scrolled below the SliverAppBar.
                  // Without this, there are cases where the shadow would appear
                  // or not appear inappropriately, because the SliverAppBar is
                  // not actually aware of the precise position of the inner
                  // scroll views.
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    // These are the widgets to put in each tab in the tab bar.
                    tabs: tabs.map((String name) => Tab(text: name)).toList(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            // These are the contents of the tab views, below the tabs.
            children: tabs.map((String name) {
              return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  // This Builder is needed to provide a BuildContext that is
                  // "inside" the NestedScrollView, so that
                  // sliverOverlapAbsorberHandleFor() can find the
                  // NestedScrollView.
                  builder: (BuildContext context) {
                    return Container(
                      color: Colors.black,
                      child: CustomScrollView(
                        // The "controller" and "primary" members should be left
                        // unset, so that the NestedScrollView can control this
                        // inner scroll view.
                        // If the "controller" property is set, then this scroll
                        // view will not be associated with the NestedScrollView.
                        // The PageStorageKey should be unique to this ScrollView;
                        // it allows the list to remember its scroll position when
                        // the tab view is not on the screen.
                        key: PageStorageKey<String>(name),
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            // This is the flip side of the SliverOverlapAbsorber
                            // above.
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.all(8.0),
                            // In this example, the inner scroll view has
                            // fixed-height list items, hence the use of
                            // SliverFixedExtentList. However, one could use any
                            // sliver widget here, e.g. SliverList or SliverGrid.
                            sliver: SliverFixedExtentList(
                              // The items in this example are fixed to 48 pixels
                              // high. This matches the Material Design spec for
                              // ListTile widgets.
                              itemExtent: name == "Mission" ? 170.0 : 80,
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  // This builder is called for each child.
                                  // In this example, we just number each list item.
                                  return name == "Mission"
                                      ? const TabContentCommunityComponentApp()
                                      : const TabContentCommunityLeaderBoardComponentApp();
                                },
                                // The childCount of the SliverChildBuilderDelegate
                                // specifies how many children this inner list
                                // has. In this example, each tab has a list of
                                // exactly 30 items, but this is arbitrary.
                                childCount: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
