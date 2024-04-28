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
import 'package:sekuya_family_mobile_app/util/format_date.dart';

class TabContentVoucherComponentApp extends StatelessWidget {
  const TabContentVoucherComponentApp({super.key, this.index, this.resVoucher});

  final int? index;
  final dynamic resVoucher;

  @override
  Widget build(BuildContext context) {
    return TabContentVoucherComponent(index: index, resVoucher: resVoucher);
  }
}

class TabContentVoucherComponent extends StatefulWidget {
  const TabContentVoucherComponent({super.key, this.index, this.resVoucher});

  final int? index;
  final dynamic resVoucher;

  @override
  State<TabContentVoucherComponent> createState() =>
      _TabContentVoucherComponentState();
}

class _TabContentVoucherComponentState
    extends State<TabContentVoucherComponent> {
  void goToDetailVoucher() {
    final arguments =
        MyArgumentsDataDetailVoucherClass(widget.resVoucher, widget.index);

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
              image: NetworkImage(widget.resVoucher?["data"]?["data"]
                      ?[widget.index]?["image"] ??
                  "https://ralfvanveen.com/wp-content/uploads/2021/06/Placeholder-_-Glossary.svg"),
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

class MyArgumentsDataDetailVoucherClass {
  final dynamic resVoucher;
  final int? indexResVoucher;

  MyArgumentsDataDetailVoucherClass(
    this.resVoucher,
    this.indexResVoucher,
  );
}
