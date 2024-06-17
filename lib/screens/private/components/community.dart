import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/components/shimmer_loading.dart';
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

  var totalPages;
  var currentPageState = 0;
  int itemPerPageState = 0;
  var noDataAnymore = false;

  late ScrollController? nestedScrollViewContoller = ScrollController();

  bool isLoadingResCommunities = false;
  bool refetchResCommunities = false;
  bool isLoadingResCommunitiesCategories = false;

  var resCommunities;
  var resCommunitiesCategories;
  var filterByValueState;

  @override
  void initState() {
    getDataCommunities();

    getDataCommunitiesCategories();

    searchController.addListener(_onSearchChanged);

    nestedScrollViewContoller?.addListener(() {
      if (nestedScrollViewContoller!.position.atEdge) {
        bool isTop = nestedScrollViewContoller!.position.pixels == 0;
        if (isTop) {
          print('At the top');
        } else {
          print('At the bottom');
          getDataCommunities(pageKey: currentPageState + 1, refetch: true);
        }
      }
    });

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
        refetch: true,
      );
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<dynamic> getDataCommunities(
      {pageKey = 1, search, filterByValue, refetch = false}) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          if (refetch) {
            refetchResCommunities = true;
          } else {
            isLoadingResCommunities = true;
          }
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
          if (res?["data"]?["meta"]?["totalPages"] > currentPageState) {
            var response = {
              ...res,
              "data": {
                ...res["data"],
                "data": [
                  ...resCommunities?["data"]?["data"] ?? [],
                  ...res?["data"]?["data"],
                ]
              }
            };

            int tempItemPerPageState = res?["data"]?["data"]?.length;

            setState(() {
              resCommunities = response;
              isLoadingResCommunities = false;
              refetchResCommunities = false;
              totalPages = res?["data"]?["meta"]?["totalPages"];
              currentPageState = res?["data"]?["meta"]?["page"];
              itemPerPageState = itemPerPageState + tempItemPerPageState;
            });
          } else {
            setState(() {
              noDataAnymore = true;
              isLoadingResCommunities = false;
              refetchResCommunities = false;
            });
          }
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
    var dataCommunitiesCategories = resCommunitiesCategories?["data"];

    return Shimmer(
        linearGradient: shimmerGradient,
        child: NestedScrollView(
            physics:
                isLoadingResCommunities || isLoadingResCommunitiesCategories
                    ? NeverScrollableScrollPhysics()
                    : null,
            floatHeaderSlivers: true,
            controller: nestedScrollViewContoller,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              // These are the slivers that show up in the "outer" scroll view.
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    automaticallyImplyLeading: false,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        const Center(
                          child: Text(
                            'Communities',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Center(
                            child: Text(
                          'Discover a supportive and inspiring community! Join in \nand be part of an incredible journey together.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: greySecondaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 20 / 12,
                          ),
                        )),
                        const SizedBox(
                          height: 24,
                        ),
                        CustomTextField(
                          textField: TextField(
                              controller: searchController,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Search',
                                prefixIcon: const Icon(Icons.search),
                                prefixIconColor: greySecondaryColor,
                                hintStyle:
                                    const TextStyle(color: greySecondaryColor),
                              )),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                            height: 260,
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 16,
                                        crossAxisSpacing: 16),
                                itemCount:
                                    dataCommunitiesCategories?.length ?? 6,
                                itemBuilder: (BuildContext context, int index) {
                                  return MyWidgetShimmerApp(
                                      isLoading:
                                          isLoadingResCommunitiesCategories,
                                      child: Card(
                                          color: Colors.black,
                                          child: InkWell(
                                              splashColor: yellowPrimaryColor
                                                  .withAlpha(30),
                                              onTap: () async {
                                                if (resCommunitiesCategories !=
                                                    null) {
                                                  getDataCommunities(
                                                      filterByValue:
                                                          dataCommunitiesCategories?[
                                                              index]?["label"],
                                                      refetch: true);

                                                  setState(() {
                                                    filterByValueState =
                                                        dataCommunitiesCategories?[
                                                            index]?["label"];
                                                  });
                                                }
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: filterByValueState ==
                                                                  dataCommunitiesCategories?[
                                                                          index]
                                                                      ?["label"]
                                                              ? yellowPrimaryColor
                                                              : blackPrimaryColor,
                                                          width: 1),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  16))),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      if (dataCommunitiesCategories?[
                                                                  index]
                                                              ?["image"] !=
                                                          null)
                                                        Center(
                                                          child: Image.network(
                                                            dataCommunitiesCategories?[
                                                                    index]
                                                                ?["image"],
                                                            height: 40,
                                                            width: 40,
                                                          ),
                                                        ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      if (resCommunitiesCategories !=
                                                          null)
                                                        Center(
                                                            child: Text(
                                                          dataCommunitiesCategories?[
                                                              index]?["label"],
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )),
                                                    ],
                                                  )))));
                                })),
                      ],
                    ),
                    floating: true,
                    expandedHeight: 430.0,
                    toolbarHeight: 430,
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
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            'Featured Communities',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                        child: Container(
                      color: Colors.black,
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            sliver: SliverFixedExtentList(
                              itemExtent: 150.0,
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return MyWidgetShimmerApp(
                                      isLoading: isLoadingResCommunities,
                                      child:
                                          TabContentCommunityFeaturedComponentApp(
                                              index: index,
                                              resCommunities: resCommunities));
                                },
                                childCount: itemPerPageState == 0
                                    ? 5
                                    : itemPerPageState,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    // if (noDataAnymore)
                    //   const Center(
                    //     child: Text("👋🏻 Hi your reach the end of the list",
                    //         style:
                    //             TextStyle(color: Colors.white, fontSize: 14)),
                    //   ),
                  ],
                );
              },
            )));
  }
}
