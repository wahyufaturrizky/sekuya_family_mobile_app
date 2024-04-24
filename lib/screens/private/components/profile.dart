import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/tab_profile/my_community.dart';
import 'package:sekuya_family_mobile_app/components/tab_profile/my_mission.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileComponentApp extends StatelessWidget {
  const ProfileComponentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileComponent();
  }
}

class ProfileComponent extends StatefulWidget {
  const ProfileComponent({super.key});

  @override
  State<ProfileComponent> createState() => _ProfileComponentState();
}

class _ProfileComponentState extends State<ProfileComponent> {
  final List<String> tabs = <String>[
    'My Mission',
    'My Communities',
    'My Voucher'
  ];

  final List<String> menu = <String>[
    'Edit Profile',
    'Logout',
  ];

  Future handleLogout() async {
    FirebaseAuth.instance.signOut().then((value) {
      SharedPreferences.getInstance().then((prefs) {
        prefs
            .remove('access_token')
            .then((value) => {
                  Application.router.navigateTo(context, "/",
                      transition: TransitionType.native)
                })
            .catchError((onError) => print(onError));
      }).catchError((onError) {
        print('onError $onError');
      });
    }).catchError((onError) => {print(onError)});
  }

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
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/bg_profile.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 170,
                            alignment: Alignment.topCenter,
                          ),
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.more_vert,
                                    color: Colors.transparent,
                                  ),
                                  const CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://i.pravatar.cc/150?img=1'),
                                    radius: 40,
                                  ),
                                  PopupMenuButton<String>(
                                      color: Colors.black,
                                      onSelected: (String item) {
                                        if (item == 'Logout') {
                                          handleLogout();
                                        } else {
                                          Application.router.navigateTo(
                                            context,
                                            "/profileDetailScreens",
                                            transition: TransitionType.native,
                                          );
                                        }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return menu
                                            .map((item) =>
                                                PopupMenuItem<String>(
                                                  value: item,
                                                  child: ListTile(
                                                    leading: Icon(
                                                      item == "Logout"
                                                          ? Icons.login_outlined
                                                          : Icons.edit,
                                                      color: item == "Logout"
                                                          ? redSolidPrimaryColor
                                                          : Colors.white,
                                                    ),
                                                    title: Text(
                                                      item == "Logout"
                                                          ? 'Logout'
                                                          : 'Edit Profile',
                                                      style: TextStyle(
                                                          color: item ==
                                                                  "Logout"
                                                              ? redSolidPrimaryColor
                                                              : Colors.white),
                                                    ),
                                                  ),
                                                ))
                                            .toList();
                                      },
                                      child: const Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              const Text(
                                'Wahyu Fatur Rizki',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'wahyufaturrizkyy@gmail.com',
                                style: TextStyle(
                                    color: greySecondaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16.0,
                        children: [1, 2, 3]
                            .map((item) => const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://i.pravatar.cc/150?img=1'),
                                  radius: 20,
                                ))
                            .toList(),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/bg_progress_xp.png'),
                                  fit: BoxFit.fill)),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Level 4',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '255 xp',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              LinearProgressIndicator(
                                value: 0.6,
                                color: yellowPrimaryColor,
                                backgroundColor: greyThirdColor,
                              )
                            ],
                          )),
                    ],
                  ),
                  // This is the title in the app bar.
                  floating: true,
                  expandedHeight: 300.0,
                  toolbarHeight: 300,
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
                              itemExtent: name == "My Mission" ? 170.0 : 80,
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  // This builder is called for each child.
                                  // In this example, we just number each list item.
                                  return name == "My Mission"
                                      ? const TabContentProfileMyCommunityComponentApp()
                                      : const TabContentProfileMyMissionComponentApp();
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
