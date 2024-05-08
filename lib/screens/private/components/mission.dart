/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:async';

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
  String? filterStatus;
  String? filterReward;
  bool isLoadingResMission = false;
  Timer? _debounce;
  static const pageSize = 5;

  var totalPages;
  var currentPageState = 0;
  var noDataAnymore = false;

  late ScrollController? nestedScrollViewContoller = ScrollController();

  Duration _debouceDuration = const Duration(milliseconds: 500);

  final searchController = TextEditingController();

  var resMission;

  @override
  void initState() {
    searchController.addListener(_onSearchChanged);
    getDataMission();

    nestedScrollViewContoller?.addListener(() {
      if (nestedScrollViewContoller!.position.atEdge) {
        bool isTop = nestedScrollViewContoller!.position.pixels == 0;
        if (isTop) {
          print('At the top');
        } else {
          print('At the bottom');
          getDataMission(pageKey: currentPageState + 1);
        }
      }
    });

    super.initState();
  }

  _onSearchChanged() async {
    final search = searchController.text;

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(_debouceDuration, () async {
      await getDataMission(
        search: search,
      );
    });
  }

  Future<dynamic> getDataMission({search, filter_by_value, pageKey = 1}) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingResMission = true;
        });
      }

      var queryParameters;

      if (search != null) {
        queryParameters = {
          'search': search,
        };
      } else if (filter_by_value != null) {
        queryParameters = {
          'filter_by_value': filter_by_value,
          'filter_by': 'status',
        };
      } else {
        queryParameters = {
          'page': pageKey.toString(),
          'limit': pageSize.toString(),
        };
      }

      var res = await handleGetDataMission(queryParameters);

      if (res != null) {
        if (mounted) {
          if (res?["data"]?["meta"]?["totalPages"] > currentPageState) {
            var response = {
              ...res,
              "data": {
                ...res["data"],
                "data": [
                  ...res?["data"]?["data"],
                  ...resMission?["data"]?["data"] ?? []
                ]
              }
            };

            setState(() {
              resMission = response;
              isLoadingResMission = false;
              totalPages = res?["data"]?["meta"]?["totalPages"];
              currentPageState = res?["data"]?["meta"]?["page"];
            });
          } else {
            setState(() {
              noDataAnymore = true;
              isLoadingResMission = false;
            });
          }
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
    return NestedScrollView(
      controller: nestedScrollViewContoller,
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
                        controller: searchController,
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
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          width: MediaQuery.of(context).size.width * 0.4,
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

                              getDataMission(filter_by_value: value);
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
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          width: MediaQuery.of(context).size.width * 0.4,
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
                              getDataMission(filter_by_value: value);
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
          return Column(
            children: [
              Expanded(
                  child: Container(
                color: Colors.black,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverFixedExtentList(
                        itemExtent: 180.0,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return TabContentMissionComponentApp(
                              resMission: resMission,
                              index: index,
                            );
                          },
                          childCount: resMission?["data"]?["data"]?.length ?? 0,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              if (noDataAnymore)
                const Center(
                  child: Text("👋🏻 Hi your reach the end of the list",
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              if (isLoadingResMission) const MyWidgetSpinner()
            ],
          );
        },
      ),
    );
  }
}
