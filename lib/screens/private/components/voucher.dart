import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/components/shimmer_loading.dart';
import 'package:sekuya_family_mobile_app/components/tab_voucher/my_voucher.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/service/voucher/voucher.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class VoucherComponentApp extends StatelessWidget {
  const VoucherComponentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const VoucherComponent();
  }
}

class VoucherComponent extends StatefulWidget {
  const VoucherComponent({super.key});

  @override
  State<VoucherComponent> createState() => _VoucherComponentState();
}

class _VoucherComponentState extends State<VoucherComponent> {
  late String search;
  String? filterStatus;
  String? filterReward;
  bool isLoadingResVoucher = false;
  bool refetchResVoucher = false;
  bool isLoadingClaimVoucher = false;
  static const pageSize = 5;

  final codeController = TextEditingController();

  var resVoucher;
  var resClaimVoucher;

  @override
  void initState() {
    super.initState();
    // getDataVoucher();
  }

  handleSearchByCode() {
    final code = codeController.text;
    getDataVoucher(code: code, refetch: true);
  }

  Future<dynamic> getDataVoucher({pageKey = 1, code, refetch = false}) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          if (refetch) {
            refetchResVoucher = true;
          } else {
            isLoadingResVoucher = true;
          }
        });
      }

      var queryParameters;

      if (code != null) {
        queryParameters = {
          'code': code,
        };
      } else {
        queryParameters = {
          'page': pageKey.toString(),
          'limit': pageSize.toString(),
        };
      }

      var res = await handleGetDataVoucher(queryParameters);
      var dataVoucher = res?["data"]?.map((e) => e["isClaimed"]);
      var isClaimed = dataVoucher?.contains(true);
      if (isClaimed) {
        const snackBar = SnackBar(
          backgroundColor: blackSolidPrimaryColor,
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 2000),
          content: Text(
            "👋🏻 Voucher already claimed",
            style: TextStyle(color: Colors.white),
          ),
        );
        if (mounted) {
          setState(() {
            isLoadingResVoucher = false;
            refetchResVoucher = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        if (res != null) {
          if (mounted) {
            setState(() {
              resVoucher = res;
              isLoadingResVoucher = false;
              refetchResVoucher = false;
            });
          }
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingResVoucher = false;
          refetchResVoucher = false;
        });
      }

      print('Error getDataVoucher = $e');
    }
  }

  Future<dynamic> onSubmitClaimVoucher(context) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingClaimVoucher = true;
        });
      }

      var data = {
        'code': codeController.text,
      };

      var res = await handleClaimVoucher(data);

      if (res != null) {
        if (mounted) {
          getDataVoucher();

          setState(() {
            resClaimVoucher = res;
            isLoadingClaimVoucher = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingClaimVoucher = false;
        });
      }

      print('Error onSubmitClaimVoucher = $e');
    }
  }

  @override
  Widget build(BuildContext mainContext) {
    var dataVoucher = resVoucher?["data"]?.map((e) => e["isClaimed"]);
    var isClaimed = dataVoucher?.contains(true);

    return Shimmer(
      linearGradient: shimmerGradient,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.75,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        child: Image.asset(
                          'assets/images/bg_voucher_redeem.png',
                          fit: BoxFit.cover,
                          // alignment: Alignment.topCenter,
                        ),
                      )),
                  Positioned(
                      top: 80,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                          decoration: const BoxDecoration(color: blackPrimaryColor, borderRadius: BorderRadius.all(Radius.circular(12))),
                          child: Column(
                            children: [
                              const Center(
                                child: Text(
                                  'Reedem Voucher',
                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Center(
                                child: Text(
                                  'Lorem ipsum dolor sit amet, consectetur adipis\nadipiscing elit, sed do eiusmod tempor',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: greySecondaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      textField: TextField(
                                          controller: codeController,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                          decoration: kTextInputDecoration.copyWith(
                                            hintText: 'Input code',
                                            isDense: true,
                                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                            hintStyle: const TextStyle(color: greySecondaryColor, fontWeight: FontWeight.w500, fontSize: 12),
                                          )),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  CustomButton(
                                      isLoading: refetchResVoucher,
                                      buttonText: refetchResVoucher ? '' : 'Find',
                                      onPressed: () {
                                        if (!refetchResVoucher) {
                                          handleSearchByCode();
                                        }
                                      },
                                      width: 60,
                                      labelSize: 12,
                                      height: 40,
                                      paddingButton: 0)
                                ],
                              ),
                            ],
                          )))
                ],
              ),
            ),
            if (isLoadingResVoucher)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MyWidgetShimmerApp(
                    isLoading: isLoadingResVoucher,
                    child: const Card(
                      child: SizedBox(
                        width: 300,
                        height: 60,
                      ),
                    )),
              ),
            if (resVoucher == null)
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    {"title": "Complete the mission", "desc": "Unlock a variety of rewards by completing community missions.", "img": "voucher_img_01"},
                    {"title": "Get Voucher Code", "desc": "Receive the voucher code as a reward upon completing the mission.", "img": "voucher_img_02"},
                    {"title": "Claim Voucher", "desc": "Search and claim your voucher by using the voucher code you've received.", "img": "voucher_img_03"},
                  ]
                      .map(
                        (item) => Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              Image.asset('assets/images/${item["img"]}.png'),
                              const SizedBox(
                                width: 16,
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.65,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["title"].toString(),
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                                      ),
                                      Text(
                                        item["desc"].toString(),
                                        style: const TextStyle(
                                          color: greySecondaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            if (resVoucher != null && resVoucher?["data"].length > 0)
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0XFF1A1A1C),
                  border: Border.all(
                    color: const Color(0XFF242427),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: resVoucher?["data"]?.length ?? 0,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return TabContentVoucherComponentApp(
                          index: index,
                          resVoucher: resVoucher,
                        );
                      },
                    ),
                    InkWell(
                      onTap: () {
                        if (isClaimed) {
                          const snackBar = SnackBar(
                            backgroundColor: blackSolidPrimaryColor,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(milliseconds: 2000),
                            content: Text(
                              "👋🏻 Voucher already claimed",
                              style: TextStyle(color: Colors.white),
                            ),
                          );

                          ScaffoldMessenger.of(mainContext).showSnackBar(snackBar);
                        } else {
                          if (!isLoadingClaimVoucher) {
                            onSubmitClaimVoucher(mainContext);
                          }
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: yellowPrimaryColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Center(
                          child: Text(
                            'Claim',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: blackSolidPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // if (resVoucher != null && resVoucher?["data"].length > 0)
            //   Container(
            //     padding: const EdgeInsets.symmetric(vertical: 16),
            //     child: CustomButton(
            //       buttonText: 'Claim',
            //       isLoading: isLoadingClaimVoucher,
            //       onPressed: () {
            //         if (isClaimed) {
            //           const snackBar = SnackBar(
            //               backgroundColor: blackSolidPrimaryColor,
            //               behavior: SnackBarBehavior.floating,
            //               duration: Duration(milliseconds: 2000),
            //               content: Text(
            //                 "👋🏻 Voucher already claimed",
            //                 style: TextStyle(color: Colors.white),
            //               ));

            //           ScaffoldMessenger.of(mainContext).showSnackBar(snackBar);
            //         } else {
            //           if (!isLoadingClaimVoucher) {
            //             onSubmitClaimVoucher(mainContext);
            //           }
            //         }
            //       },
            //       width: 500,
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
