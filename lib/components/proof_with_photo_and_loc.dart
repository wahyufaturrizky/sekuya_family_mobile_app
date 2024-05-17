/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

class ProofWithPhotoAndLocApp extends StatelessWidget {
  const ProofWithPhotoAndLocApp(
      {super.key,
      this.image,
      this.name,
      this.exp,
      this.description,
      this.onTapTakeCamera,
      this.retrieveLostData,
      this.previewImages,
      this.onTapGetCurrentPosition,
      this.isLoadingNameLocation,
      this.nameLocation,
      this.isLoadingTaskMission,
      this.onPressedSubmitTaskMission});

  final dynamic image;
  final dynamic name;
  final dynamic exp;
  final dynamic description;
  final VoidCallback? onTapTakeCamera;
  final dynamic retrieveLostData;
  final dynamic previewImages;
  final dynamic onTapGetCurrentPosition;
  final bool? isLoadingNameLocation;
  final String? nameLocation;
  final bool? isLoadingTaskMission;
  final dynamic onPressedSubmitTaskMission;

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
        isLoadingTaskMission: isLoadingTaskMission,
        onPressedSubmitTaskMission: onPressedSubmitTaskMission);
  }
}

class ProofWithPhotoAndLoc extends StatefulWidget {
  const ProofWithPhotoAndLoc(
      {super.key,
      this.image,
      this.name,
      this.exp,
      this.description,
      this.onTapTakeCamera,
      this.retrieveLostData,
      this.previewImages,
      this.onTapGetCurrentPosition,
      this.isLoadingNameLocation,
      this.nameLocation,
      this.isLoadingTaskMission,
      this.onPressedSubmitTaskMission});

  final dynamic image;
  final dynamic name;
  final dynamic exp;
  final dynamic description;
  final VoidCallback? onTapTakeCamera;
  final dynamic retrieveLostData;
  final dynamic previewImages;
  final dynamic onTapGetCurrentPosition;
  final bool? isLoadingNameLocation;
  final String? nameLocation;
  final bool? isLoadingTaskMission;
  final dynamic onPressedSubmitTaskMission;

  @override
  State<ProofWithPhotoAndLoc> createState() => _ProofWithPhotoAndLocState();
}

class _ProofWithPhotoAndLocState extends State<ProofWithPhotoAndLoc> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        iconColor: Colors.white,
        title: Row(
          children: [
            if (widget.image != null)
              Image.network(
                widget.image,
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
                    widget.name ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                  Text(
                    '${widget.exp ?? ""}xp',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.check_circle,
              color: greenColor,
            )
          ],
        ),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: greySoftColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: const CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 16,
                    child: Text(
                      '1',
                      style: TextStyle(color: yellowPrimaryColor),
                    ),
                  )),
              const SizedBox(
                width: 16,
              ),
              Flexible(
                child: Text(
                  widget.description ?? "",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Chip(
                    avatar: const Icon(
                      Icons.check_circle,
                      color: greenColor,
                    ),
                    label: const Text(
                      'Done',
                    ),
                    color: MaterialStateProperty.all<Color>(Colors.black),
                    labelStyle: const TextStyle(
                        color: greenColor, fontWeight: FontWeight.w500),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: greenColor))),
              ],
            ),
          ),
          CustomButton(
            buttonText: 'Follow',
            onPressed: () {},
            height: 50,
            width: 500,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: greySoftColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: const CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 16,
                    child: Text(
                      '2',
                      style: TextStyle(color: yellowPrimaryColor),
                    ),
                  )),
              const SizedBox(
                width: 16,
              ),
              const Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Proof",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "dictum cursus mauris varius tristique aliquet. Morbi cursus urna in nibh diam dolor lacus sit.",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ))
            ],
          ),
          const SizedBox(
            height: 16,
          ),
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
                            future: widget.retrieveLostData,
                            builder: (BuildContext context,
                                AsyncSnapshot<void> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return const Text(
                                    'You have not yet picked an image.',
                                    textAlign: TextAlign.center,
                                  );
                                case ConnectionState.done:
                                  return widget.previewImages;
                                case ConnectionState.active:
                                  if (snapshot.hasError) {
                                    return Text(
                                      'Pick image/video error: ${snapshot.error}}',
                                      textAlign: TextAlign.center,
                                    );
                                  } else {
                                    return const Text(
                                      'You have not yet picked an image.',
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
              widget.onTapGetCurrentPosition!();
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
                  widget.isLoadingNameLocation!
                      ? "Loading..."
                      : widget.nameLocation ?? "Get Current Location",
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
            isLoading: widget.isLoadingTaskMission!,
            onPressed: () {
              widget.onPressedSubmitTaskMission!();
            },
            width: 500,
          ),
          const SizedBox(
            height: 16,
          ),
        ]);
  }
}
