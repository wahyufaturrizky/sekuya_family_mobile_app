import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/components/tab_community/mission.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class MissionComponentApp extends StatelessWidget {
  const MissionComponentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MissionComponent();
  }
}

class MissionComponent extends StatefulWidget {
  const MissionComponent({super.key});

  @override
  State<MissionComponent> createState() => _MissionComponentState();
}

class _MissionComponentState extends State<MissionComponent> {
  late String search;
  String? filterStatus;
  String? filterReward;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        // These are the slivers that show up in the "outer" scroll view.
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text(
                      'Missions',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipis',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: greySecondaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomTextField(
                    textField: TextField(
                        onChanged: (value) {
                          search = value;
                        },
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        decoration: kTextInputDecoration.copyWith(
                          hintText: 'Search',
                          prefixIcon: const Icon(Icons.search),
                          prefixIconColor: greySecondaryColor,
                          hintStyle: const TextStyle(color: greySecondaryColor),
                        )),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          width: 165,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.0),
                            border: Border.all(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 0.80),
                          ),
                          child: DropdownButton<String>(
                            value: filterStatus,
                            hint: const Text(
                              'All Status',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(Icons.expand_more),
                            iconEnabledColor: Colors.white,
                            elevation: 16,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            underline: Container(height: 0),
                            isExpanded: true,
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                filterStatus = value!;
                              });
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                          )),
                      Container(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          width: 165,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.0),
                            border: Border.all(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 0.80),
                          ),
                          child: DropdownButton<String>(
                            value: filterReward,
                            hint: const Text(
                              'All Reward',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(Icons.expand_more),
                            iconEnabledColor: Colors.white,
                            elevation: 16,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            underline: Container(height: 0),
                            isExpanded: true,
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                filterReward = value!;
                              });
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                          )),
                    ],
                  )
                ],
              ),
              // This is the title in the app bar.
              floating: true,
              expandedHeight: 190.0,
              toolbarHeight: 190,
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
            ),
          ),
        ];
      },
      body: SafeArea(
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
                slivers: <Widget>[
                  SliverOverlapInjector(
                    // This is the flip side of the SliverOverlapAbsorber
                    // above.
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
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
                      itemExtent: 180.0,
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          // This builder is called for each child.
                          // In this example, we just number each list item.
                          return const TabContentCommunityComponent();
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
      ),
    );
  }
}
