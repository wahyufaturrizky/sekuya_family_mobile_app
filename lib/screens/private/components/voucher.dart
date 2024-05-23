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
  bool isLoadingClaimVoucher = false;
  static const pageSize = 5;

  final codeController = TextEditingController();

  var resVoucher;
  var resClaimVoucher;

  @override
  void initState() {
    super.initState();
    getDataVoucher();
  }

  handleSearchByCode() {
    final code = codeController.text;
    getDataVoucher(code: code);
  }

  Future<dynamic> getDataVoucher({pageKey = 1, code}) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingResVoucher = true;
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

      if (res != null) {
        if (mounted) {
          setState(() {
            resVoucher = res;
            isLoadingResVoucher = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingResVoucher = false;
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
                  Container(
                    height: 220,
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
                                alignment: Alignment.topCenter,
                              ),
                            )),
                        Positioned(
                            top: 80,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                    color: blackPrimaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Column(
                                  children: [
                                    const Center(
                                      child: Text(
                                        'Reedem Voucher',
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
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextField(
                                            textField: TextField(
                                                controller: codeController,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                                decoration: kTextInputDecoration
                                                    .copyWith(
                                                  hintText: 'Input code',
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.all(4),
                                                  hintStyle: const TextStyle(
                                                      color: greySecondaryColor,
                                                      fontSize: 14),
                                                )),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        CustomButton(
                                            buttonText: 'Find',
                                            onPressed: () {
                                              handleSearchByCode();
                                            },
                                            width: 100,
                                            labelSize: 14,
                                            height: 40,
                                            paddingButton: 0)
                                      ],
                                    )
                                  ],
                                )))
                      ],
                    ),
                  )
                ],
              ),
              floating: true,
              expandedHeight: 220.0,
              toolbarHeight: 220,
              backgroundColor: Colors.black,
              forceElevated: innerBoxIsScrolled,
            ),
          ),
        ];
      },
      body: Builder(
        builder: (BuildContext context) {
          if (isLoadingResVoucher) {
            return const MyWidgetSpinnerApp();
          } else {
            return Column(
              children: [
                if (resVoucher?["data"].length == 0)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        {
                          "title": "Complete the mission",
                          "desc":
                              "Unlock a variety of rewards by completing community missions.",
                          "img": "voucher_img_01"
                        },
                        {
                          "title": "Get Voucher Code",
                          "desc":
                              "Receive the voucher code as a reward upon completing the mission.",
                          "img": "voucher_img_02"
                        },
                        {
                          "title": "Claim Voucher",
                          "desc":
                              "Search and claim your voucher by using the voucher code you've received.",
                          "img": "voucher_img_03"
                        },
                      ]
                          .map((item) => Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                children: [
                                  Image.asset(
                                      'assets/images/${item["img"]}.png'),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item["title"].toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
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
                              )))
                          .toList(),
                    ),
                  ),
                Expanded(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverFixedExtentList(
                          itemExtent: 120.0,
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return TabContentVoucherComponentApp(
                                  index: index, resVoucher: resVoucher);
                            },
                            childCount: resVoucher?["data"]?.length ?? 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (resVoucher?["data"].length > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: CustomButton(
                      buttonText: 'Claim',
                      isLoading: isLoadingClaimVoucher,
                      onPressed: () {
                        if (isClaimed) {
                          const snackBar = SnackBar(
                              backgroundColor: blackSolidPrimaryColor,
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(milliseconds: 2000),
                              content: Text(
                                "👋🏻 Voucher already claimed",
                                style: TextStyle(color: Colors.white),
                              ));

                          ScaffoldMessenger.of(mainContext)
                              .showSnackBar(snackBar);
                        } else {
                          if (!isLoadingClaimVoucher) {
                            onSubmitClaimVoucher(mainContext);
                          }
                        }
                      },
                      width: 500,
                    ),
                  )
              ],
            );
          }
        },
      ),
    );
  }
}
