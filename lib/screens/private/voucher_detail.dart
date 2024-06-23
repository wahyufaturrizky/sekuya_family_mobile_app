import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/tab_voucher/my_voucher.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
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
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.args?.resVoucher?["data"]?[widget.args?.indexResVoucher]?["coverImage"] != null)
                CachedNetworkImage(
                  imageUrl: widget.args?.resVoucher?["data"]?[widget.args?.indexResVoucher]?["coverImage"] ?? "",
                  placeholder: (context, url) => const SizedBox(),
                  height: 140,
                  width: double.infinity,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.args?.resVoucher?["data"]?[widget.args?.indexResVoucher]?["name"] ?? "",
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      widget.args?.resVoucher?["data"]?[widget.args?.indexResVoucher]?["description"] ?? "",
                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: greySecondaryColor),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        if (widget.args?.resVoucher?["data"]?[widget.args?.indexResVoucher]?["coverImage"] != null)
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: greyColor,
                            child: CachedNetworkImage(
                              imageUrl: widget.args?.resVoucher?["data"]?[widget.args?.indexResVoucher]?["image"],
                              placeholder: (context, url) => const SizedBox(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          widget.args?.resVoucher?["data"]?[widget.args?.indexResVoucher]?["name"] ?? "",
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  {
                    "title": "Term and Conditions",
                    "rule": [widget.args?.resVoucher?["data"]?[widget.args?.indexResVoucher]?["tnc"]],
                  },
                  {
                    "title": "How to use",
                    "rule": [widget.args?.resVoucher?["data"]?[widget.args?.indexResVoucher]?["htu"]],
                  },
                ].asMap().entries.map(
                  (item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Column(
                          children: [
                            const Divider(
                              color: Color(0xFF1A1A1C),
                              thickness: 8,
                              height: 32,
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ExpansionTile(
                                shape: Border.all(color: Colors.transparent),
                                iconColor: Colors.white,
                                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                                title: Text(
                                  item.value["title"].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                children: (item.value["rule"] != null)
                                    ? (item.value["rule"] as List<dynamic>)
                                        .map(
                                          (itemRule) => ListTile(
                                            title: Text(
                                              itemRule ?? "",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList()
                                    : [],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ).toList(),
              ),
            ],
          ),

          // This is the title in the app bar.
        ),
      ),
    );
  }
}
