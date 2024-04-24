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
import 'package:sekuya_family_mobile_app/screens/private/components/community.dart';
import 'package:sekuya_family_mobile_app/screens/private/components/home.dart';
import 'package:sekuya_family_mobile_app/screens/private/components/mission.dart';
import 'package:sekuya_family_mobile_app/screens/private/components/profile.dart';
import 'package:sekuya_family_mobile_app/screens/private/components/voucher.dart';
import 'package:sekuya_family_mobile_app/screens/private/profile_detail.dart';

class PrivateScreenApp extends StatelessWidget {
  const PrivateScreenApp({super.key, this.args});

  final MyArgumentsDataClass? args;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PrivateScreen(args: args),
      theme: ThemeData(
          canvasColor: Colors.black,
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: yellowPrimaryColor.withOpacity(0.2),
            cursorColor: yellowPrimaryColor,
            selectionHandleColor: yellowPrimaryColor,
          ),
          tabBarTheme: TabBarTheme(
              labelColor: yellowPrimaryColor,
              indicatorColor: Colors.transparent,
              unselectedLabelColor: greySecondaryColor,
              dividerColor: greySecondaryColor,
              overlayColor:
                  MaterialStateProperty.all<Color>(yellowPrimaryColor))),
    );
  }
}

class PrivateScreen extends StatefulWidget {
  const PrivateScreen({
    super.key,
    this.args,
  });

  final MyArgumentsDataClass? args;

  @override
  State<PrivateScreen> createState() => _PrivateScreenState();
}

class _PrivateScreenState extends State<PrivateScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeComponentApp(),
    MissionComponentApp(),
    CommunityComponentApp(),
    VoucherComponentApp(),
    ProfileComponentApp(),
  ];

  @override
  void initState() {
    super.initState();
    handleRouteCondition();
  }

  void handleRouteCondition() {
    var goToProfile = widget.args?.goToProfile ?? false;
    var goToCommunity = widget.args?.goToCommunity ?? false;

    if (goToProfile) {
      setState(() {
        _selectedIndex = 4;
      });
    } else if (goToCommunity) {
      setState(() {
        _selectedIndex = 3;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Mission',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Community',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket),
            label: 'Voucher',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Profile',
            backgroundColor: Colors.black,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: yellowPrimaryColor,
        unselectedItemColor: greySecondaryColor,
        onTap: _onItemTapped,
      ),
    ));
  }
}
