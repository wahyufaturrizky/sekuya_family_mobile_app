/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

class TabContentVoucherComponentApp extends StatelessWidget {
  const TabContentVoucherComponentApp({super.key, this.item = 0});

  final int item;

  @override
  Widget build(BuildContext context) {
    return TabContentVoucherComponent(item: item);
  }
}

class TabContentVoucherComponent extends StatefulWidget {
  const TabContentVoucherComponent({super.key, this.item = 0});

  final int item;

  @override
  State<TabContentVoucherComponent> createState() =>
      _TabContentVoucherComponentState();
}

class _TabContentVoucherComponentState
    extends State<TabContentVoucherComponent> {
  void goToDetailVoucher() {
    final arguments = MyArgumentsDataDetailVoucherClass(widget!.item);

    Application.router.navigateTo(context, "/detailVoucherScreen",
        transition: TransitionType.native,
        routeSettings: RouteSettings(arguments: arguments));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: blackPrimaryColor,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        splashColor: yellowPrimaryColor.withAlpha(30),
        onTap: () {
          goToDetailVoucher();
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/bg_voucher.png'),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Voucher lorem ipsum dolor',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Check out various interesting voucher promos for you.',
                style: TextStyle(
                    color: greySecondaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Image.asset('assets/images/ic_timer.png'),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    'Berlaku hingga 23 Juni 2024',
                    style: TextStyle(
                        color: yellowPrimaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyArgumentsDataDetailVoucherClass {
  final int id;

  MyArgumentsDataDetailVoucherClass(
    this.id,
  );
}
