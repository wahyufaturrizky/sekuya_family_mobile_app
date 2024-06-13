/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/api_key.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/components/placeholder_image_task.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/util/status.dart';

final dio = Dio();

class ProofWithPhotoAndLocApp extends StatelessWidget {
  const ProofWithPhotoAndLocApp({
    super.key,
    this.image,
    this.name,
    this.exp,
    this.description,
    this.onTapTakeCamera,
    this.retrieveLostData,
    this.previewImages,
    this.onTapGetCurrentPosition,
    this.isLoadingNameLocation = false,
    this.nameLocation = '',
    this.isLoadingSubmitTaskMission,
    this.onPressedSubmitTaskMission,
    this.onExpansionChanged,
    this.status,
    this.reason,
    this.submittedAdditionalAttribute,
    this.isLoadingMissionDetail = false,
  });

  final dynamic image;
  final dynamic name;
  final dynamic exp;
  final dynamic description;
  final VoidCallback? onTapTakeCamera;
  final dynamic retrieveLostData;
  final dynamic previewImages;
  final dynamic onTapGetCurrentPosition;
  final bool isLoadingNameLocation;
  final String nameLocation;
  final bool? isLoadingSubmitTaskMission;
  final dynamic onPressedSubmitTaskMission;
  final dynamic onExpansionChanged;
  final dynamic status;
  final dynamic reason;
  final dynamic submittedAdditionalAttribute;
  final bool isLoadingMissionDetail;

  @override
  Widget build(BuildContext context) {
    return ProofWithPhotoAndLoc(
      image: image,
      name: name,
      exp: exp,
      description: description,
      onTapTakeCamera: onTapTakeCamera,
      retrieveLostData: retrieveLostData,
      previewImages: previewImages,
      onTapGetCurrentPosition: onTapGetCurrentPosition,
      isLoadingNameLocation: isLoadingNameLocation,
      nameLocation: nameLocation,
      isLoadingSubmitTaskMission: isLoadingSubmitTaskMission,
      onPressedSubmitTaskMission: onPressedSubmitTaskMission,
      onExpansionChanged: onExpansionChanged,
      status: status,
      reason: reason,
      submittedAdditionalAttribute: submittedAdditionalAttribute,
      isLoadingMissionDetail: isLoadingMissionDetail,
    );
  }
}

class ProofWithPhotoAndLoc extends StatefulWidget {
  const ProofWithPhotoAndLoc({
    super.key,
    this.image,
    this.name,
    this.exp,
    this.description,
    this.onTapTakeCamera,
    this.retrieveLostData,
    this.previewImages,
    this.onTapGetCurrentPosition,
    this.isLoadingNameLocation = false,
    this.nameLocation = '',
    this.isLoadingSubmitTaskMission,
    this.onPressedSubmitTaskMission,
    this.onExpansionChanged,
    this.status,
    this.reason,
    this.submittedAdditionalAttribute,
    this.isLoadingMissionDetail = false,
  });

  final dynamic image;
  final dynamic name;
  final dynamic exp;
  final dynamic description;
  final VoidCallback? onTapTakeCamera;
  final dynamic retrieveLostData;
  final dynamic previewImages;
  final dynamic onTapGetCurrentPosition;
  final bool isLoadingNameLocation;
  final String nameLocation;
  final bool? isLoadingSubmitTaskMission;
  final dynamic onPressedSubmitTaskMission;
  final dynamic onExpansionChanged;
  final dynamic status;
  final dynamic reason;
  final dynamic submittedAdditionalAttribute;
  final bool isLoadingMissionDetail;

  @override
  State<ProofWithPhotoAndLoc> createState() => _ProofWithPhotoAndLocState();
}

class _ProofWithPhotoAndLocState extends State<ProofWithPhotoAndLoc> {
  var submittedLocation = '';

  @override
  void initState() {
    getHttp();

    super.initState();
  }

  void getHttp() async {
    if (widget.submittedAdditionalAttribute != "") {
      var lat = widget.submittedAdditionalAttribute?["lat"];
      var long = widget.submittedAdditionalAttribute?["long"];

      final response = await dio.get(
          '$baseUrlMapGoogleApi/geocode/json?latlng=$lat,$long&key=$apiKeyGoogleApi');

      final res = jsonDecode(response.toString());
      print(res['results'][0]['formatted_address']);
      setState(() {
        submittedLocation = res['results'][0]['formatted_address'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.8;

    var image = widget.image;
    var name = widget.name;
    var exp = widget.exp;
    var status = widget.status;
    var reason = widget.reason;
    var description = widget.description;
    var nameLocation = widget.nameLocation;
    var isLoadingNameLocation = widget.isLoadingNameLocation;
    var isLoadingSubmitTaskMission = widget.isLoadingSubmitTaskMission;

    return ExpansionTile(
        iconColor: Colors.white,
        onExpansionChanged: (bool value) {
          if (value) {
            widget.onExpansionChanged();
          }
        },
        title: Row(
          children: [
            if (image != null)
              Image.network(
                image,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                  Text(
                    '${exp ?? ""}xp',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              handleStatusIcon(status),
              color: handleStatusColorIcon(status),
            )
          ],
        ),
        children: [
          const SizedBox(
            height: 16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //     decoration: BoxDecoration(
              //         border: Border.all(color: greySoftColor),
              //         borderRadius:
              //             const BorderRadius.all(Radius.circular(20))),
              //     child: const CircleAvatar(
              //       backgroundColor: Colors.black,
              //       radius: 16,
              //       child: Text(
              //         '1',
              //         style: TextStyle(color: yellowPrimaryColor),
              //       ),
              //     )),
              // const SizedBox(
              //   width: 16,
              // ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                width: c_width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (reason != '' && ["REJECTED"].contains(widget.status))
                      Text("Reason rejected: ${reason}",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: redSolidPrimaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    Text(description ?? "",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Container(
          //         decoration: BoxDecoration(
          //             border: Border.all(color: greySoftColor),
          //             borderRadius:
          //                 const BorderRadius.all(Radius.circular(20))),
          //         child: const CircleAvatar(
          //           backgroundColor: Colors.black,
          //           radius: 16,
          //           child: Text(
          //             '2',
          //             style: TextStyle(color: yellowPrimaryColor),
          //           ),
          //         )),
          //     const SizedBox(
          //       width: 16,
          //     ),
          //     const Flexible(
          //         child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           "Proof",
          //           style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 14,
          //               fontWeight: FontWeight.w500),
          //         ),
          //         SizedBox(
          //           height: 8,
          //         ),
          //         Text(
          //           "dictum cursus mauris varius tristique aliquet. Morbi cursus urna in nibh diam dolor lacus sit.",
          //           style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 12,
          //               fontWeight: FontWeight.w400),
          //         ),
          //       ],
          //     ))
          //   ],
          // ),
          // const SizedBox(
          //   height: 16,
          // ),
          GestureDetector(
            onTap: () {
              widget.onTapTakeCamera!();
            },
            child: Container(
                height: 200,
                width: 150,
                child:
                    !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                        ? FutureBuilder<void>(
                            future: widget.retrieveLostData!(),
                            builder: (BuildContext context,
                                AsyncSnapshot<void> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return const PlaceholderImageTaskApp(
                                    label: 'You have not yet picked an image.',
                                  );
                                case ConnectionState.done:
                                  return widget.previewImages;
                                case ConnectionState.active:
                                  if (snapshot.hasError) {
                                    return Text(
                                      'Pick image/video error: ${snapshot.error}}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    );
                                  } else {
                                    return const Text(
                                      'You have not yet picked an image.',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    );
                                  }
                              }
                            },
                          )
                        : widget.previewImages),
          ),
          const SizedBox(
            height: 16,
          ),
          // Column(
          //   children: [
          //     ListView.builder(
          //       shrinkWrap: true,
          //       itemCount: _positionItems.length,
          //       itemBuilder: (context, index) {
          //         final positionItem = _positionItems[index];

          //         if (positionItem.type ==
          //             _PositionItemType.log) {
          //           return ListTile(
          //             title: Text(positionItem.displayValue,
          //                 textAlign: TextAlign.center,
          //                 style: const TextStyle(
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.bold,
          //                 )),
          //           );
          //         } else {
          //           return ListTile(
          //             title: Text(
          //               positionItem.displayValue,
          //               style: const TextStyle(
          //                   color: Colors.white),
          //             ),
          //           );
          //         }
          //       },
          //     ),
          //   ],
          // ),
          GestureDetector(
            onTap: () {
              if (["NOT_SUBMITTED", "REJECTED"].contains(widget.status)) {
                widget.onTapGetCurrentPosition!();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.pin_drop_outlined,
                  color: yellowPrimaryColor,
                ),
                Flexible(
                    child: Text(
                  (isLoadingNameLocation
                      ? "Loading..."
                      : ["NOT_SUBMITTED", "REJECTED"].contains(status)
                          ? (nameLocation != ''
                              ? nameLocation
                              : "Get Current Location")
                          : submittedLocation),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: yellowPrimaryColor,
                    decoration: TextDecoration.underline,
                    decorationColor: yellowPrimaryColor,
                  ),
                ))
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          CustomButton(
            buttonText: 'Submit',
            isLoading: isLoadingSubmitTaskMission!,
            onPressed: () {
              widget.onPressedSubmitTaskMission!();
            },
            width: 500,
            isOutlined: !["NOT_SUBMITTED", "REJECTED"].contains(status),
          ),
          const SizedBox(
            height: 16,
          ),
        ]);
  }
}
