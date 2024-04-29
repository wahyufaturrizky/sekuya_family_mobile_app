/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/components/spinner.dart';
import 'package:sekuya_family_mobile_app/components/tab_mission/mission.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/service/mission/mission.dart';

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
  bool isLoadingResMission = false;

  var resMission;

  @override
  void initState() {
    super.initState();
    getDataMission();
  }

  Future<dynamic> getDataMission() async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingResMission = true;
        });
      }

      var res = await handleGetDataMission();

      if (res != null) {
        if (mounted) {
          setState(() {
            resMission = res;
            resMission = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingResMission = false;
        });
      }

      print('Error getDataProfile = $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = isLoadingResMission;

    if (!isLoading) {
      return const MyWidgetSpinner();
    } else {
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
                            hintStyle:
                                const TextStyle(color: greySecondaryColor),
                          )),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            width: 170,
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
                              items: list.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                  ),
                                );
                              }).toList(),
                            )),
                        Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            width: 170,
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
                              items: list.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                floating: true,
                expandedHeight: 190.0,
                toolbarHeight: 190,
                backgroundColor: Colors.black,
                forceElevated: innerBoxIsScrolled,
              ),
            ),
          ];
        },
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              color: Colors.black,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: SliverFixedExtentList(
                      itemExtent: 180.0,
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return TabContentMissionComponentApp(
                            resMission: resMission,
                            index: index,
                          );
                        },
                        childCount: resMission?["data"]?["data"]?.length ?? 2,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }
}
