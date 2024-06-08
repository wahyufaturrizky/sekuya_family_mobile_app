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
    return PopScope(canPop: false, child: PrivateScreen(args: args));
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

  @override
  void initState() {
    super.initState();
    handleRouteCondition();
  }

  void handleRouteCondition() {
    var goToProfile = widget.args?.goToProfile ?? false;
    var goToCommunity = widget.args?.goToCommunity ?? false;
    var goToVoucher = widget.args?.goToVoucher ?? false;
    var goToMission = widget.args?.goToMission ?? false;

    if (goToProfile) {
      setState(() {
        _selectedIndex = 4;
      });
    } else if (goToCommunity) {
      setState(() {
        _selectedIndex = 2;
      });
    } else if (goToVoucher) {
      setState(() {
        _selectedIndex = 3;
      });
    } else if (goToMission) {
      _selectedIndex = 1;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      const HomeComponentApp(),
      const MissionComponentApp(),
      const CommunityComponentApp(),
      const VoucherComponentApp(),
      const ProfileComponentApp(),
    ];

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ballot_outlined),
            label: 'Mission',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.diversity_2_outlined),
            label: 'Community',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number_outlined),
            label: 'Voucher',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
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
