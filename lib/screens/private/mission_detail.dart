/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/components/tab_mission/mission.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/screens/private/profile_detail.dart';

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
  bool isLoading = false;
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

    setState(() {
      isLoading = false;
    });
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
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
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
            const Text(
              'Voucher lorem ipsum dolor',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Image.asset(
                  'assets/images/ic_community.png',
                  width: 32,
                  height: 32,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  'NFT Communities',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Check out various interesting voucher.',
              style: TextStyle(
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
                    label: const Text(
                      'On Going',
                    ),
                    color: MaterialStateProperty.all<Color>(
                        bluePrimaryColor.withOpacity(0.2)),
                    labelStyle: const TextStyle(color: bluePrimaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                const SizedBox(
                  width: 16,
                ),
                const Text(
                  '20 Apr 2024 - 30 May 2024',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.white),
                ),
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          {
                            "title": "1",
                            "type": "Days",
                          },
                          {
                            "title": "23",
                            "type": "Hours",
                          },
                          {
                            "title": "32",
                            "type": "Minutes",
                          },
                          {
                            "title": "44",
                            "type": "Seconds",
                          },
                        ]
                            .map((item) => Column(
                                  children: [
                                    Text(
                                      item["title"].toString(),
                                      style: const TextStyle(
                                          color: yellowPrimaryColor,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      item["type"].toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ))
                            .toList()),
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: blackPrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/ic_cube.png',
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '150 Xp',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        LinearProgressIndicator(
                          value: 0.6,
                          color: yellowPrimaryColor,
                          backgroundColor: greyThirdColor,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'For all task completed',
                          style: TextStyle(
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
                      label: const Text(
                        '40%',
                      ),
                      color: MaterialStateProperty.all<Color>(
                          blackSolidPrimaryColor),
                      labelStyle: const TextStyle(
                          color: yellowPrimaryColor,
                          fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.transparent))),
                ],
              ),
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
            ExpansionTile(
                iconColor: Colors.white,
                title: Row(
                  children: [
                    Image.asset('assets/images/ic_globe.png'),
                    const SizedBox(
                      width: 16,
                    ),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Join ipsum dolor sit amet',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                          Text(
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
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Follow Instagram @sekuya',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomButton(
                            isLoading: isLoading,
                            buttonText: 'Follow',
                            onPressed: () {},
                            height: 50,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            height: 200,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: yellowPrimaryColor),
                            ),
                            child: !kIsWeb &&
                                    defaultTargetPlatform ==
                                        TargetPlatform.android
                                ? FutureBuilder<void>(
                                    future: retrieveLostData(),
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
                                          return _previewImages();
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
                                : _previewImages(),
                          ),
                          if (_picker.supportsImageSource(ImageSource.camera))
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: FloatingActionButton(
                                onPressed: () {
                                  _onImageButtonPressed(ImageSource.camera,
                                      context: context);
                                },
                                heroTag: 'image2',
                                tooltip: 'Take a Photo',
                                child: const Icon(Icons.camera_alt),
                              ),
                            ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ))
                    ],
                  )
                ])
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

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality, int? limit);
