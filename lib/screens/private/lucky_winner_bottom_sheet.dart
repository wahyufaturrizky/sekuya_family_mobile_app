import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/service/mission/mission.dart';

class LuckyWinnerBottomSheetApp extends StatelessWidget {
  const LuckyWinnerBottomSheetApp({super.key, this.idMission});

  final dynamic idMission;

  @override
  Widget build(BuildContext context) {
    return LuckyWinnerBottomSheet(idMission: idMission);
  }
}

class LuckyWinnerBottomSheet extends StatefulWidget {
  const LuckyWinnerBottomSheet({super.key, this.idMission});

  final dynamic idMission;

  @override
  State<LuckyWinnerBottomSheet> createState() => _LuckyWinnerBottomSheetState();
}

class _LuckyWinnerBottomSheetState extends State<LuckyWinnerBottomSheet> {
  bool refetchLuckyWinners = false;
  bool isLoadingLuckyWinners = false;
  static const pageSizeLuckyWinners = 5;

  var totalPagesLuckyWinners;
  var currentPageLuckyWinners = 0;
  int itemPerPageLuckyWinners = 0;
  var resLuckyWinners;

  @override
  void initState() {
    getDataLuckyWinnersByMissionDetail();

    super.initState();
  }

  Future<dynamic> getDataLuckyWinnersByMissionDetail(
      {pageKey = 1, refetch = false}) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          if (refetch) {
            refetchLuckyWinners = true;
          } else {
            isLoadingLuckyWinners = true;
          }
        });
      }

      var queryParameters;

      queryParameters = {
        'page': pageKey.toString(),
        'limit': pageSizeLuckyWinners.toString(),
      };

      String id = widget.idMission;

      var res =
          await handleGetDataLuckyWinnersByMissionDetail(id, queryParameters);

      if (res != null) {
        if (mounted) {
          if (res?["data"]?["meta"]?["totalPages"] > currentPageLuckyWinners) {
            var response = {
              ...res,
              "data": {
                ...res["data"],
                "data": [
                  ...resLuckyWinners?["data"]?["data"] ?? [],
                  ...res?["data"]?["data"],
                ]
              }
            };

            int tempItemPerPageState = res?["data"]?["data"]?.length;

            setState(() {
              resLuckyWinners = response;
              isLoadingLuckyWinners = false;
              refetchLuckyWinners = false;
              totalPagesLuckyWinners = res?["data"]?["meta"]?["totalPages"];
              currentPageLuckyWinners = res?["data"]?["meta"]?["page"];
              itemPerPageLuckyWinners =
                  itemPerPageLuckyWinners + tempItemPerPageState;
            });
          } else {
            setState(() {
              isLoadingLuckyWinners = false;
              refetchLuckyWinners = false;
            });
          }
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingLuckyWinners = false;
          refetchLuckyWinners = false;
        });
      }

      print('Error getDataLuckyWinnersByMissionDetail = $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var dataLuckyWinners = resLuckyWinners?["data"]?["data"];

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Lucky Winner',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              if (dataLuckyWinners != null && dataLuckyWinners.isNotEmpty)
                Column(
                    children: (dataLuckyWinners as List<dynamic>).map((item) {
                  var profilePic = item?["player"]?["profilePic"];
                  var email = item?["player"]?["email"];
                  var rewards = item?["rewards"];

                  return ExpansionTile(
                      iconColor: Colors.white,
                      collapsedBackgroundColor: blackPrimaryColor,
                      backgroundColor: blackPrimaryColor,
                      title: Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(profilePic),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  email.substring(0, 10),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: greenColor,
                          )
                        ],
                      ),
                      children: rewards != null && rewards.isNotEmpty
                          ? (rewards as List<dynamic>).map((item) {
                              var name = item["name"];
                              var image = item["image"];
                              var maxQty = item["maxQty"];

                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                    color: blackSolidPrimaryColor),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage:
                                                NetworkImage(image),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            name,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        maxQty.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ]),
                              );
                            }).toList()
                          : []);
                }).toList())
            ],
          ),
          // This is the title in the app bar.
        ),
      ),
    ));
  }
}
