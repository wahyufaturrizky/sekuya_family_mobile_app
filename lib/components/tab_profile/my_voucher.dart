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
import 'package:sekuya_family_mobile_app/components/tab_voucher/my_voucher.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/util/format_date.dart';

class TabContentProfileMyVoucherComponentApp extends StatelessWidget {
  const TabContentProfileMyVoucherComponentApp(
      {super.key, this.resVoucher, this.index});

  final dynamic resVoucher;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return TabContentProfileMyVoucherComponent(
        resVoucher: resVoucher, index: index);
  }
}

class TabContentProfileMyVoucherComponent extends StatefulWidget {
  const TabContentProfileMyVoucherComponent(
      {super.key, this.resVoucher, this.index});

  final dynamic resVoucher;
  final int? index;

  @override
  State<TabContentProfileMyVoucherComponent> createState() =>
      _TabContentProfileMyVoucherComponentState();
}

class _TabContentProfileMyVoucherComponentState
    extends State<TabContentProfileMyVoucherComponent> {
  void goToDetailVoucher() {
    final arguments = MyArgumentsDataDetailVoucherClass(
        widget.resVoucher?["data"], widget.index);

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
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstATop),
              image: NetworkImage(widget.resVoucher?["data"]?["data"]
                      ?[widget.index]?["image"] ??
                  ""),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.resVoucher?["data"]?["data"]?[widget.index]?["name"] ??
                    "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                widget.resVoucher?["data"]?["data"]?[widget.index]
                        ?["description"] ??
                    "",
                style: const TextStyle(
                    color: Colors.white,
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
                  Text(
                    'Berlaku hingga ${handleFormatDate(widget.resVoucher?["data"]?["data"]?[widget.index]?["expired_at"] ?? "")}',
                    style: const TextStyle(
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
