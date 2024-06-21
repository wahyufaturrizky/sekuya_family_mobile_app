import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/tab_voucher/my_voucher.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/screens/private/profile_detail.dart';

class VoucherDetailApp extends StatelessWidget {
  const VoucherDetailApp({super.key, this.args});

  final MyArgumentsDataDetailVoucherClass? args;

  @override
  Widget build(BuildContext context) {
    return VoucherDetail(args: args);
  }
}

class VoucherDetail extends StatefulWidget {
  const VoucherDetail({super.key, this.args});

  final MyArgumentsDataDetailVoucherClass? args;

  @override
  State<VoucherDetail> createState() => _VoucherDetailState();
}

class _VoucherDetailState extends State<VoucherDetail> {
  late String username;
  bool isLoading = false;

  List<Map<String, Object>> expandRule = [
    {
      "title": "Term and Conditions",
      "rule": [
        "Voucher ini Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
        "Voucher ini Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
        "Voucher ini Lorem ipsum dolor sit amet, consectetur adipiscing elit."
      ],
    },
    {
      "title": "How to use",
      "rule": [
        "Voucher ini Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
        "Voucher ini Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
        "Voucher ini Lorem ipsum dolor sit amet, consectetur adipiscing elit."
      ],
    },
  ];

  // void handleBack() {
  //   final arguments = widget.args!.isFromPageVoucher == true
  //       ? MyArgumentsDataClass(false, false, true, false)
  //       : MyArgumentsDataClass(true, false, false, false);

  //   Application.router.navigateTo(context, "/privateScreens",
  //       transition: TransitionType.inFromRight,
  //       routeSettings: RouteSettings(arguments: arguments));

  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        title: const Text(
          'Detail Voucher',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.args?.resVoucher?["data"]?[widget.args?.indexResVoucher]
                    ?["coverImage"] !=
                null)
              Image.network(
                widget.args?.resVoucher?["data"]?[widget.args?.indexResVoucher]
                        ?["coverImage"] ??
                    "",
                fit: BoxFit.cover,
                width: double.infinity,
                alignment: Alignment.center,
                height: 140,
              ),
            const SizedBox(
              height: 16,
            ),
            Text(
              widget.args?.resVoucher?["data"]?[widget.args?.indexResVoucher]
                      ?["name"] ??
                  "",
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white),
            ),
            Text(
              widget.args?.resVoucher?["data"]?[widget.args?.indexResVoucher]
                      ?["description"] ??
                  "",
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: greySecondaryColor),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                if (widget.args?.resVoucher?["data"]
                        ?[widget.args?.indexResVoucher]?["coverImage"] !=
                    null)
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: greyColor,
                    child: Image.network(widget.args?.resVoucher?["data"]
                        ?[widget.args?.indexResVoucher]?["image"]),
                  ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  widget.args?.resVoucher?["data"]
                          ?[widget.args?.indexResVoucher]?["name"] ??
                      "",
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
                children: [
              {
                "title": "Term and Conditions",
                "rule": [
                  widget.args?.resVoucher?["data"]
                      ?[widget.args?.indexResVoucher]?["tnc"]
                ],
              },
              {
                "title": "How to use",
                "rule": [
                  widget.args?.resVoucher?["data"]
                      ?[widget.args?.indexResVoucher]?["htu"]
                ],
              },
            ].asMap().entries.map((item) {
              return Builder(builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                      shape: Border.all(color: Colors.transparent),
                      iconColor: Colors.white,
                      title: Text(
                        item.value["title"].toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                      children: (item.value["rule"] != null)
                          ? (item.value["rule"] as List<dynamic>)
                              .map((itemRule) => ListTile(
                                      title: Text(
                                    itemRule ?? "",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  )))
                              .toList()
                          : []),
                );
              });
            }).toList())
          ],
        ),
        // This is the title in the app bar.
      )),
    ));
  }
}
