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

class PrivateScreenApp extends StatelessWidget {
  const PrivateScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PrivateScreen(),
      theme: ThemeData(
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
  const PrivateScreen({super.key});

  @override
  State<PrivateScreen> createState() => _PrivateScreenState();
}

class _PrivateScreenState extends State<PrivateScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeComponent(),
    MissionComponentApp(),
    CommunityComponentApp(),
    ProfileComponent(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Title bar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
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
    );
  }
}
