import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/components/placeholder_image_task.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/util/status.dart';

class ProofWithPhotoApp extends StatelessWidget {
  const ProofWithPhotoApp({
    super.key,
    this.image,
    this.name,
    this.exp,
    this.description,
    this.onTapTakeCamera,
    this.retrieveLostData,
    this.previewImages,
    this.isLoadingSubmitTaskMission,
    this.onPressedSubmitTaskMission,
    this.onExpansionChanged,
    this.status,
    this.reason,
  });

  final dynamic image;
  final dynamic name;
  final dynamic exp;
  final dynamic description;
  final VoidCallback? onTapTakeCamera;
  final dynamic retrieveLostData;
  final dynamic previewImages;
  final bool? isLoadingSubmitTaskMission;
  final dynamic onPressedSubmitTaskMission;
  final dynamic onExpansionChanged;
  final dynamic status;
  final dynamic reason;

  @override
  Widget build(BuildContext context) {
    return ProofWithPhoto(
      image: image,
      name: name,
      exp: exp,
      description: description,
      onTapTakeCamera: onTapTakeCamera,
      retrieveLostData: retrieveLostData,
      previewImages: previewImages,
      isLoadingSubmitTaskMission: isLoadingSubmitTaskMission,
      onPressedSubmitTaskMission: onPressedSubmitTaskMission,
      onExpansionChanged: onExpansionChanged,
      status: status,
      reason: reason,
    );
  }
}

class ProofWithPhoto extends StatefulWidget {
  const ProofWithPhoto({
    super.key,
    this.image,
    this.name,
    this.exp,
    this.description,
    this.onTapTakeCamera,
    this.retrieveLostData,
    this.previewImages,
    this.isLoadingSubmitTaskMission,
    this.onPressedSubmitTaskMission,
    this.onExpansionChanged,
    this.status,
    this.reason,
  });

  final dynamic image;
  final dynamic name;
  final dynamic exp;
  final dynamic description;
  final VoidCallback? onTapTakeCamera;
  final dynamic retrieveLostData;
  final dynamic previewImages;
  final bool? isLoadingSubmitTaskMission;
  final dynamic onPressedSubmitTaskMission;
  final dynamic onExpansionChanged;
  final dynamic status;
  final dynamic reason;

  @override
  State<ProofWithPhoto> createState() => _ProofWithPhotoState();
}

class _ProofWithPhotoState extends State<ProofWithPhoto> {
  @override
  Widget build(BuildContext context) {
    double contextWidth = MediaQuery.of(context).size.width * 0.8;

    var image = widget.image;
    var name = widget.name;
    var exp = widget.exp;
    var status = widget.status;
    var reason = widget.reason;
    var isLoadingSubmitTaskMission = widget.isLoadingSubmitTaskMission;

    return ExpansionTile(
        onExpansionChanged: (bool value) {
          if (value) {
            widget.onExpansionChanged();
          }
        },
        iconColor: Colors.white,
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
                width: contextWidth,
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
                    Text(widget.description ?? "",
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
          // Container(
          //   margin: const EdgeInsets.symmetric(vertical: 8),
          //   child: Row(
          //     children: [
          //       Chip(
          //           avatar: const Icon(
          //             Icons.check_circle,
          //             color: greenColor,
          //           ),
          //           label: const Text(
          //             'Done',
          //           ),
          //           color: MaterialStateProperty.all<Color>(Colors.black),
          //           labelStyle: const TextStyle(
          //               color: greenColor, fontWeight: FontWeight.w500),
          //           shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(20),
          //               side: const BorderSide(color: greenColor))),
          //     ],
          //   ),
          // ),
          // const SizedBox(
          //   height: 16,
          // ),
          // CustomButton(
          //   buttonText: 'Follow',
          //   onPressed: () {},
          //   height: 50,
          //   width: 500,
          // ),
          // const SizedBox(
          //   height: 16,
          // ),
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
          CustomButton(
            buttonText: 'Submit',
            isLoading: isLoadingSubmitTaskMission!,
            onPressed: () {
              widget.onPressedSubmitTaskMission!();
            },
            isOutlined: !["NOT_SUBMITTED", "REJECTED"].contains(status),
            width: 500,
          ),
          const SizedBox(
            height: 16,
          ),
        ]);
  }
}
