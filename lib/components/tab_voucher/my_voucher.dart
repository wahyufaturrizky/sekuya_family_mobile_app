import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

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
    final arguments = MyArgumentsDataDetailVoucherClass(
        widget.resVoucher, widget.index, true);

    Application.router.navigateTo(context, "/detailVoucherScreen",
        transition: TransitionType.native,
        routeSettings: RouteSettings(arguments: arguments));
  }

  @override
  Widget build(BuildContext context) {
    var dataVoucher = widget.resVoucher?["data"]?[widget.index];
    var coverImage = dataVoucher?["coverImage"];
    var name = dataVoucher?["name"];
    var description = dataVoucher?["description"];

    return Card(
      color: blackPrimaryColor,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: InkWell(
        splashColor: yellowPrimaryColor.withAlpha(30),
        onTap: () {
          goToDetailVoucher();
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            image: coverImage != null
                ? DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5), BlendMode.dstATop),
                    image: NetworkImage(coverImage),
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name ?? "",
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
                description ?? "",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
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
  final bool? isFromPageVoucher;

  MyArgumentsDataDetailVoucherClass(
    this.resVoucher,
    this.indexResVoucher,
    this.isFromPageVoucher,
  );
}
