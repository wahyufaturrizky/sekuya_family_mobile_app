/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:io';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/components/tab_mission/mission.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/screens/private/lucky_winner_bottom_sheet%20copy.dart';
import 'package:sekuya_family_mobile_app/screens/private/profile_detail.dart';
import 'package:sekuya_family_mobile_app/service/mission/mission.dart';
import 'package:sekuya_family_mobile_app/util/format_date.dart';

class MissionDetailApp extends StatelessWidget {
  const MissionDetailApp({super.key, this.args});

  final MyArgumentsDataDetailMissionClass? args;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MissionDetail(args: args),
      theme: ThemeData(
        canvasColor: Colors.black,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: yellowPrimaryColor.withOpacity(0.2),
          cursorColor: yellowPrimaryColor,
          selectionHandleColor: yellowPrimaryColor,
        ),
      ),
    );
  }
}

class MissionDetail extends StatefulWidget {
  const MissionDetail({super.key, this.args});

  final MyArgumentsDataDetailMissionClass? args;

  @override
  State<MissionDetail> createState() => _MissionDetailState();
}

class _MissionDetailState extends State<MissionDetail> {
  late String username;
  bool isLoadingTaskMission = false;
  List<XFile>? _mediaFileList;
  dynamic _pickImageError;
  String? _retrieveDataError;

  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  final TextEditingController limitController = TextEditingController();

  void handleBack() {
    final arguments = MyArgumentsDataClass(false, false, false, true);

    Application.router.navigateTo(context, "/privateScreens",
        transition: TransitionType.inFromLeft,
        routeSettings: RouteSettings(arguments: arguments));
  }

  Future<dynamic> handlePostTaskSubmission(taskId) async {
    try {
      setState(() {
        isLoadingTaskMission = true;
      });

      String idMission = widget.args?.resMission?["data"]?["data"]
          ?[widget.args?.indexResMission]?["_id"];

      final formData = FormData.fromMap({
        'taskId': taskId,
        'additionalAttribute': "test additional attribute",
        'proof': [
          await MultipartFile.fromFile(
            _mediaFileList![0].path.toString(),
            filename: _mediaFileList![0].path.split('/').last,
          )
        ],
      });

      var res = await handleTaskSubmission(formData, idMission);

      if (res != null) {
        setState(() {
          isLoadingTaskMission = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingTaskMission = false;
      });
      print(e);
    }
  }

  Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
  }) async {
    if (context.mounted) {
      await _displayPickImageDialog(context, false, (double? maxWidth,
          double? maxHeight, int? quality, int? limit) async {
        try {
          final XFile? pickedFile = await _picker.pickImage(
            source: source,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );
          setState(() {
            _setImageFileListFromFile(pickedFile);
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      });
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_mediaFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            // Why network for web?
            // See https://pub.dev/packages/image_picker_for_web#limitations-on-the-web-platform
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: Image.file(
                File(_mediaFileList![index].path),
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return const Center(
                      child: Text('This image type is not supported'));
                },
              ),
            );
          },
          itemCount: _mediaFileList!.length,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage("assets/images/upload_img_placeholder.png"),
              fit: BoxFit.cover),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: greyColor, width: 2),
        ),
      );
      // You have not yet picked an image.
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _setImageFileListFromFile(response.file);
        } else {
          _mediaFileList = response.files;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

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
            handleBack();
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        title: const Text(
          'Detail Mission',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.args?.resMission?["data"]?["data"]
                      ?[widget.args?.indexResMission]?["name"] ??
                  "",
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                if (widget.args?.resMission?["data"]?["data"]
                            ?[widget.args?.indexResMission]?["community"]
                        ?["image"] !=
                    null)
                  Image.network(
                    widget.args?.resMission?["data"]?["data"]
                        ?[widget.args?.indexResMission]?["community"]?["image"],
                    width: 32,
                    height: 32,
                  ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  widget.args?.resMission?["data"]?["data"]
                      ?[widget.args?.indexResMission]?["community"]?["name"],
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              widget.args?.resMission?["data"]?["data"]
                      ?[widget.args?.indexResMission]?["description"] ??
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
                Chip(
                    label: Text(
                      widget.args?.resMission?["data"]?["data"]
                              ?[widget.args?.indexResMission]?["status"] ??
                          "",
                    ),
                    color: MaterialStateProperty.all<Color>(blueSecondaryColor),
                    labelStyle: const TextStyle(color: blueSolidSecondaryColor),
                    shape: const StadiumBorder(
                        side: BorderSide(color: Colors.transparent))),
                const SizedBox(
                  width: 16,
                ),
                Row(
                  children: [
                    Text(
                      '${handleFormatDate(widget.args?.resMission?["data"]?["data"]?[widget.args?.indexResMission]?["startDate"])} - ',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.white),
                    ),
                    Text(
                      handleFormatDate(widget.args?.resMission?["data"]?["data"]
                          ?[widget.args?.indexResMission]?["endDate"]),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: yellowPrimaryColor.withOpacity(0.2),
                    border: Border.all(
                      color: yellowPrimaryColor,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: Column(
                  children: [
                    const Text(
                      'Mission will end on',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CountDownText(
                      due: DateTime.parse(widget.args?.resMission?["data"]
                          ?["data"]?[widget.args?.indexResMission]?["endDate"]),
                      finishedText: "Mission End",
                      showLabel: true,
                      longDateName: true,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                )),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Rewards',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              children: (widget.args?.resMission?["data"]?["data"]
                          ?[widget.args?.indexResMission]?["rewards"]
                      as List<dynamic>)
                  .map((itemReward) => Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: blackPrimaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Row(
                          children: [
                            if (itemReward["image"] != null)
                              Image.network(
                                itemReward["image"],
                                width: 40,
                                height: 40,
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
                                    '${itemReward["value"].toString()} Xp',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  LinearProgressIndicator(
                                    value: itemReward["value"] * 0.01,
                                    color: yellowPrimaryColor,
                                    backgroundColor: greyThirdColor,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    itemReward["description"],
                                    style: const TextStyle(
                                        color: greySecondaryColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Chip(
                                label: Text(
                                  '${itemReward["maxQty"] / itemReward["value"]}%',
                                ),
                                color: MaterialStateProperty.all<Color>(
                                    blackSolidPrimaryColor),
                                labelStyle: const TextStyle(
                                    color: yellowPrimaryColor,
                                    fontWeight: FontWeight.w600),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                        color: Colors.transparent))),
                          ],
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Lucky Winner',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return const LuckyWinnerBottomSheetApp();
                          });
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(
                          color: yellowPrimaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ))
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(color: blackPrimaryColor),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black),
              child: Row(children: [
                const Flexible(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            NetworkImage('https://i.pravatar.cc/150?img=1'),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'full name',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Flexible(
                    child: AvatarStack(
                  height: 24,
                  avatars: [
                    for (var n = 0; n < 3; n++) NetworkImage(getAvatarUrl(n))
                  ],
                ))
              ]),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Tasks',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              children: (widget.args?.resMission?["data"]?["data"]
                          ?[widget.args?.indexResMission]?["tasks"]
                      as List<dynamic>)
                  .map(
                    (itemTask) => ExpansionTile(
                        iconColor: Colors.white,
                        title: Row(
                          children: [
                            if (itemTask["image"] != null)
                              Image.network(
                                itemTask["image"],
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
                                    itemTask["name"].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                  const Text(
                                    '10xp',
                                    style: TextStyle(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: greySoftColor),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 16,
                                    child: Text(
                                      '1',
                                      style:
                                          TextStyle(color: yellowPrimaryColor),
                                    ),
                                  )),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itemTask["dsecription"].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  CustomButton(
                                    buttonText: 'Follow',
                                    onPressed: () {},
                                    height: 50,
                                    width: 500,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    height: 200,
                                    width: 150,
                                    child: !kIsWeb &&
                                            defaultTargetPlatform ==
                                                TargetPlatform.android
                                        ? FutureBuilder<void>(
                                            future: retrieveLostData(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<void> snapshot) {
                                              switch (
                                                  snapshot.connectionState) {
                                                case ConnectionState.none:
                                                case ConnectionState.waiting:
                                                  return const Text(
                                                    'You have not yet picked an image.',
                                                    textAlign: TextAlign.center,
                                                  );
                                                case ConnectionState.done:
                                                  return _previewImages();
                                                case ConnectionState.active:
                                                  if (snapshot.hasError) {
                                                    return Text(
                                                      'Pick image/video error: ${snapshot.error}}',
                                                      textAlign:
                                                          TextAlign.center,
                                                    );
                                                  } else {
                                                    return const Text(
                                                      'You have not yet picked an image.',
                                                      textAlign:
                                                          TextAlign.center,
                                                    );
                                                  }
                                              }
                                            },
                                          )
                                        : _previewImages(),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  if (_picker
                                      .supportsImageSource(ImageSource.camera))
                                    CustomButton(
                                        isOutlinedBackgroundColor:
                                            greyDarkColor,
                                        buttonText: 'Add Image',
                                        isOutlined: true,
                                        onPressed: () {
                                          _onImageButtonPressed(
                                              ImageSource.camera,
                                              context: context);
                                        },
                                        sizeButtonIcon: 20,
                                        buttonIcon: 'ic_plus.png',
                                        width: 500,
                                        paddingButton: 0),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  CustomButton(
                                    buttonText: 'Submit',
                                    isLoading: isLoadingTaskMission,
                                    onPressed: () {
                                      handlePostTaskSubmission('0');
                                    },
                                    width: 500,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ))
                            ],
                          )
                        ]),
                  )
                  .toList(),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Players',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
                height: 260,
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            mainAxisExtent: 60,
                            crossAxisSpacing: 16),
                    itemCount: 2,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          color: blackPrimaryColor,
                          child: InkWell(
                              splashColor: yellowPrimaryColor.withAlpha(30),
                              onTap: () {
                                debugPrint('Card tapped.');
                              },
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: greySecondaryColor, width: 1),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                  child: const Row(
                                    children: [
                                      Center(
                                          child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage(
                                            'https://i.pravatar.cc/150?img=1'),
                                      )),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'full name',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ))));
                    })),
          ],
        ),
        // This is the title in the app bar.
      ),
    ));
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, bool isMulti, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add optional parameters'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: maxWidthController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Enter maxWidth if desired'),
                ),
                TextField(
                  controller: maxHeightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Enter maxHeight if desired'),
                ),
                TextField(
                  controller: qualityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Enter quality if desired'),
                ),
                if (isMulti)
                  TextField(
                    controller: limitController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: 'Enter limit if desired'),
                  ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    final double? width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    final double? height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    final int? quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    final int? limit = limitController.text.isNotEmpty
                        ? int.parse(limitController.text)
                        : null;
                    onPick(width, height, quality, limit);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}

String getAvatarUrl(int n) {
  final url = 'https://i.pravatar.cc/150?img=$n';
  // final url = 'https://robohash.org/$n?bgset=bg1';
  return url;
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality, int? limit);
