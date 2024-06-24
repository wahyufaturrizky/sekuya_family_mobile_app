import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/components/shimmer_loading.dart';
import 'package:sekuya_family_mobile_app/components/tab_mission/mission.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/service/mission/mission.dart';
import 'package:shimmer/shimmer.dart' as shim;

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
  bool refetchMission = false;
  Timer? _debounce;
  static const pageSize = 5;

  var totalPages;
  var currentPageState = 0;
  int itemPerPageState = 0;
  var noDataAnymore = false;

  late ScrollController? nestedScrollViewContoller = ScrollController();

  Duration _debouceDuration = const Duration(milliseconds: 500);

  final searchController = TextEditingController();

  var resMission;

  List listMission = [];
  List searchListMission = [];

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
          getDataMission(pageKey: currentPageState + 1, refetch: true);
        }
      }
    });

    super.initState();
  }

  _onSearchChanged() async {
    final search = searchController.text;

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(_debouceDuration, () async {
      setState(
        () {
          searchListMission = listMission
              .where(
                (element) => element['name'].toString().toLowerCase().contains(search),
              )
              .toList();
        },
      );
    });
  }

  Future<dynamic> getDataMission({search, filter_by_value, pageKey = 1, refetch = false}) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          if (refetch) {
            refetchMission = true;
          } else {
            isLoadingResMission = true;
          }
        });
      }

      var queryParameters;

      if (search != null) {
        queryParameters = {
          'search': search,
        };
        log('QUERY PARAM $search');
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
                  ...resMission?["data"]?["data"] ?? [],
                  ...res?["data"]?["data"],
                ]
              }
            };

            int tempItemPerPageState = res?["data"]?["data"]?.length;

            setState(() {
              resMission = response;
              listMission = List.from(response['data']['data']);
              isLoadingResMission = false;
              refetchMission = false;
              totalPages = res?["data"]?["meta"]?["totalPages"];
              currentPageState = res?["data"]?["meta"]?["page"];
              itemPerPageState = itemPerPageState + tempItemPerPageState;
            });
          } else {
            setState(() {
              noDataAnymore = true;
              isLoadingResMission = false;
              refetchMission = false;
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
    return Shimmer(
      linearGradient: shimmerGradient,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 55,
            ),
            const Center(
              child: Text(
                'Missions',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Center(
              child: Text(
                'Explore the innovative digital world \nand seize the opportunity to win exciting prizes! ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 20 / 12,
                  color: greySecondaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            CustomTextField(
              padding: 10,
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
                  contentPadding: EdgeInsets.zero,
                  prefixIconColor: greySecondaryColor,
                  hintStyle: const TextStyle(color: greySecondaryColor),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        border: Border.all(color: const Color.fromRGBO(80, 80, 82, 1), style: BorderStyle.solid, width: 0.80),
                      ),
                      child: DropdownButton<String>(
                        value: filterStatus,
                        dropdownColor: Colors.black,
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

                          getDataMission(filter_by_value: value, refetch: true);
                        },
                        items: list.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        height: 36,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          border: Border.all(color: const Color.fromRGBO(80, 80, 82, 1), style: BorderStyle.solid, width: 0.80),
                        ),
                        child: DropdownButton<String>(
                          dropdownColor: Colors.black,
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
                            getDataMission(filter_by_value: value, refetch: true);
                          },
                          items: list.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                              ),
                            );
                          }).toList(),
                        )),
                  ),
                ],
              ),
            ),
            Flexible(
              child: isLoadingResMission
                  ? shim.Shimmer.fromColors(
                      baseColor: const Color(0XFF242427),
                      highlightColor: Colors.grey.withOpacity(0.6),
                      direction: shim.ShimmerDirection.ttb,
                      child: ListView.builder(
                        itemCount: 5,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 122,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: const Color(0XFF242427),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        },
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: searchController.text.isNotEmpty ? searchListMission.length : listMission.length,
                      itemBuilder: (BuildContext context, int index) {
                        return listMission.isNotEmpty
                            ? TabContentMissionComponentApp(
                                resMission: searchController.text.isNotEmpty ? searchListMission : listMission,
                                index: index,
                              )
                            : SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                              );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
