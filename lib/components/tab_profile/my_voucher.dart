/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

class TabContentProfileMyVoucherComponentApp extends StatelessWidget {
  const TabContentProfileMyVoucherComponentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabContentProfileMyVoucherComponent();
  }
}

class TabContentProfileMyVoucherComponent extends StatefulWidget {
  const TabContentProfileMyVoucherComponent({super.key});

  @override
  State<TabContentProfileMyVoucherComponent> createState() =>
      _TabContentProfileMyVoucherComponentState();
}

class _TabContentProfileMyVoucherComponentState
    extends State<TabContentProfileMyVoucherComponent> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: blackPrimaryColor,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        splashColor: yellowPrimaryColor.withAlpha(30),
        onTap: () {
          debugPrint('Card tapped.');
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/banner_home.png'),
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
