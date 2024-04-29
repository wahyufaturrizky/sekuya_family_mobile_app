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

  var resVoucher;

  @override
  void initState() {
    super.initState();
    getDataVoucher();
  }

  Future<dynamic> getDataVoucher() async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingResVoucher = true;
        });
      }

      var res = await handleGetDataVoucher();

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

      print('Error getDataProfile = $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = isLoadingResVoucher;

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
                              width: 350,
                              child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                      color: blackPrimaryColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
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
                                                  onChanged: (value) {
                                                    search = value;
                                                  },
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                  decoration:
                                                      kTextInputDecoration
                                                          .copyWith(
                                                    hintText: 'Input code',
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(4),
                                                    hintStyle: const TextStyle(
                                                        color:
                                                            greySecondaryColor,
                                                        fontSize: 14),
                                                  )),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          CustomButton(
                                              buttonText: 'Find',
                                              onPressed: () {},
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
            return Column(
              children: [
                Expanded(
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
                              return TabContentVoucherComponentApp(
                                  index: index, resVoucher: resVoucher);
                            },
                            childCount:
                                resVoucher?["data"]?["data"]?.length ?? 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CustomButton(
                    buttonText: 'Claim',
                    onPressed: () {},
                    width: 500,
                  ),
                )
              ],
            );
          },
        ),
      );
    }
  }
}
