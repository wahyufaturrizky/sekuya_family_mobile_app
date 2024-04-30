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
import 'package:sekuya_family_mobile_app/components/tab_community/featured_community.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/service/community/community.dart';

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

  Timer? _debounce;

  Duration _debouceDuration = const Duration(milliseconds: 500);

  final searchController = TextEditingController();

  static const pageSize = 5;

  bool isLoadingResCommunities = false;
  bool isLoadingResCommunitiesCategories = false;

  var resCommunities;
  var resCommunitiesCategories;
  var filterByValueState;

  @override
  void initState() {
    getDataCommunities();

    getDataCommunitiesCategories();

    searchController.addListener(_onSearchChanged);

    super.initState();
  }

  _onSearchChanged() async {
    final search = searchController.text;

    setState(() {
      filterByValueState = "";
    });

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(_debouceDuration, () async {
      await getDataCommunities(
        search: search,
      );
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<dynamic> getDataCommunities({pageKey, search, filterByValue}) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingResCommunities = true;
        });
      }

      var queryParameters;

      if (search != null) {
        queryParameters = {
          'search': search,
        };
      } else if (filterByValue != null) {
        queryParameters = {
          'filter_by_value': filterByValue.toUpperCase(),
        };
      } else {
        queryParameters = {
          'page': pageKey.toString(),
          'limit': pageSize.toString(),
        };
      }

      var res = await handleGetDataCommunities(queryParameters);

      if (res != null) {
        if (mounted) {
          setState(() {
            resCommunities = res;
            isLoadingResCommunities = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingResCommunities = false;
        });
      }

      print('Error getDataProfile = $e');
    }
  }

  Future<dynamic> getDataCommunitiesCategories() async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingResCommunitiesCategories = true;
        });
      }

      var res = await handleGetDataCommunitiesCategories();

      if (res != null) {
        if (mounted) {
          setState(() {
            resCommunitiesCategories = res;
            isLoadingResCommunitiesCategories = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingResCommunitiesCategories = false;
        });
      }

      print('Error getDataProfile = $e');
    }
  }

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
                        'Communities',
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
                            hintStyle:
                                const TextStyle(color: greySecondaryColor),
                          )),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (isLoadingResCommunitiesCategories)
                      const MyWidgetSpinner(),
                    if (!isLoadingResCommunitiesCategories)
                      SizedBox(
                          height: 260,
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16),
                              itemCount:
                                  resCommunitiesCategories?["data"]?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                    color: Colors.black,
                                    child: InkWell(
                                        splashColor:
                                            yellowPrimaryColor.withAlpha(30),
                                        onTap: () async {
                                          getDataCommunities(
                                              filterByValue:
                                                  resCommunitiesCategories?[
                                                          "data"]?[index]
                                                      ?["label"]);

                                          setState(() {
                                            filterByValueState =
                                                resCommunitiesCategories?[
                                                    "data"]?[index]?["label"];
                                          });
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: filterByValueState ==
                                                            resCommunitiesCategories?[
                                                                        "data"]
                                                                    ?[index]
                                                                ?["label"]
                                                        ? yellowPrimaryColor
                                                        : greySecondaryColor,
                                                    width: 1),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(16))),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                if (resCommunitiesCategories?[
                                                            "data"]?[index]
                                                        ?["image"] !=
                                                    null)
                                                  Center(
                                                    child: Image.network(
                                                      resCommunitiesCategories?[
                                                              "data"]?[index]
                                                          ?["image"],
                                                      height: 40,
                                                      width: 40,
                                                    ),
                                                  ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Center(
                                                    child: Text(
                                                  resCommunitiesCategories?[
                                                      "data"]?[index]?["label"],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                              ],
                                            ))));
                              })),
                  ],
                ),
                floating: true,
                expandedHeight: 400.0,
                toolbarHeight: 400,
                backgroundColor: Colors.black,
                forceElevated: innerBoxIsScrolled,
              ),
            ),
          ];
        },
        body: Builder(
          builder: (BuildContext context) {
            if (isLoadingResCommunities) {
              return const MyWidgetSpinner();
            } else {
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
                        itemExtent: 150.0,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return TabContentCommunityFeaturedComponentApp(
                                index: index, resCommunities: resCommunities);
                          },
                          childCount:
                              resCommunities?["data"]?["data"]?.length ?? 0,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }
}
