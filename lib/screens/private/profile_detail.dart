/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/components/spinner.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/service/profile/profile.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileDetailApp extends StatelessWidget {
  const ProfileDetailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ProfileDetail(),
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

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({super.key});

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  bool isLoadingGetProfile = false;
  bool isLoadingUpdateProfile = false;
  var resProfile;
  dynamic _pickImageError;
  List<XFile>? _mediaFileList;
  String? _retrieveDataError;

  final username = TextEditingController();
  final email = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getDataProfile();
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    super.dispose();
  }

  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  Future<dynamic> getDataProfile() async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          isLoadingGetProfile = true;
        });
      }

      var res = await handleGetDataProfile();

      if (res != null) {
        if (mounted) {
          setState(() {
            resProfile = res;

            email.text = resProfile["data"]?["email"];
            username.text = resProfile["data"]?["username"];
            isLoadingGetProfile = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingGetProfile = false;
        });
      }

      print('Error getDataProfile = $e');
    }
  }

  Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
      );
      setState(() {
        _setImageFileListFromFile(pickedFile);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  void handleBack() {
    final arguments = MyArgumentsDataClass(true, false, false, false);

    Application.router.navigateTo(context, "/privateScreens",
        transition: TransitionType.inFromLeft,
        routeSettings: RouteSettings(arguments: arguments));
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
      return ClipOval(
          child: SizedBox.fromSize(
              size: const Size.fromRadius(40), // I
              child: Semantics(
                label: 'image_picker_example_picked_image',
                child: Image.file(
                  fit: BoxFit.cover,
                  File(_mediaFileList![0].path),
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return const Center(
                        child: Text('This image type is not supported'));
                  },
                ),
              )));
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else if (resProfile?["data"]?["profilePic"] != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(resProfile?["data"]?["profilePic"]),
        radius: 40,
      );
    } else {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<dynamic> handleUpdateProfile(context) async {
    try {
      setState(() {
        isLoadingUpdateProfile = true;
      });

      final formData = FormData.fromMap({
        'username': username.text.toString(),
        'profilePic': _mediaFileList != null
            ? [
                await MultipartFile.fromFile(
                  _mediaFileList![0].path.toString(),
                  filename: _mediaFileList![0].path.split('/').last,
                )
              ]
            : [resProfile?["data"]?["profilePic"]],
      });

      var res = await handleUpdateDataProfile(formData);

      if (res != null) {
        const snackBar = SnackBar(
            backgroundColor: blackSolidPrimaryColor,
            behavior: SnackBarBehavior.floating,
            duration: Duration(milliseconds: 2000),
            content: Text(
              "👋🏻 Success update profile",
              style: TextStyle(color: Colors.white),
            ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        setState(() {
          isLoadingUpdateProfile = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingUpdateProfile = false;
      });
      print(e);
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

  Future<void> _launchUrl(val) async {
    if (val != "") {
      final Uri url = Uri.parse(val);

      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = isLoadingGetProfile;
    if (isLoading) {
      return const MyWidgetSpinnerApp();
    } else {
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
            'Edit Profile',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/bg_profile.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 170,
                    alignment: Alignment.topCenter,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if ((_picker
                              .supportsImageSource(ImageSource.camera))) {
                            _onImageButtonPressed(ImageSource.camera,
                                context: context);
                          }
                        },
                        child: CircleAvatar(
                            radius: 40,
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
                                : _previewImages()),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        textField: TextField(
                            controller: username,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            decoration: kTextInputDecoration.copyWith(
                              hintText: 'Username',
                              hintStyle:
                                  const TextStyle(color: greySecondaryColor),
                            )),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Email Address',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        textField: TextField(
                            enabled: false,
                            controller: email,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            decoration: kTextInputDecoration.copyWith(
                              hintText: 'Email address',
                              hintStyle:
                                  const TextStyle(color: greySecondaryColor),
                            )),
                      ),
                      Column(
                        children: (resProfile?["data"]?["linkedAccount"]
                                as Map<String, dynamic>)
                            .entries
                            .map((item) => Column(
                                  children: [
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    CustomButton(
                                        isOutlinedBackgroundColor:
                                            greyDarkColor,
                                        buttonText: 'Connect to ${item.key}',
                                        isOutlined: true,
                                        onPressed: () {
                                          _launchUrl(item.value);
                                        },
                                        sizeButtonIcon: 20,
                                        buttonIcon: 'ic_${item.key}.png',
                                        width: 500,
                                        paddingButton: 0)
                                  ],
                                ))
                            .toList(),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                      )
                    ],
                  )),
            ],
          ),
          // This is the title in the app bar.
        ),
        bottomSheet: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black,
            child: CustomButton(
                isLoading: isLoadingUpdateProfile,
                buttonText: 'Save',
                onPressed: () {
                  if (!isLoadingUpdateProfile) {
                    handleUpdateProfile(context);
                  }
                },
                sizeButtonIcon: 20,
                width: 500,
                paddingButton: 0)),
      ));
    }
  }
}

class MyArgumentsDataClass {
  final bool goToProfile;
  final bool goToCommunity;
  final bool goToVoucher;
  final bool goToMission;

  MyArgumentsDataClass(
      this.goToProfile, this.goToCommunity, this.goToVoucher, this.goToMission);
}
