import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/components/shimmer_loading.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/screens/private/recovery_email_bottom_sheet.dart';
import 'package:sekuya_family_mobile_app/service/profile/profile.dart';
import 'package:sekuya_family_mobile_app/service/recovery-email/recovery_email.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const List<String> scopes = <String>[
  'email',
];

GoogleSignIn googleSignIn = kIsWeb
    ? GoogleSignIn(scopes: scopes, clientId: "433294916757-ebvrl9qvhgvn3vqo3j2k9elirj7t1k7r.apps.googleusercontent.com")
    : GoogleSignIn(
        scopes: scopes,
      );

class ProfileDetailApp extends StatelessWidget {
  const ProfileDetailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileDetail();
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
  bool isLoadingRecoveryEmailWithGoogle = false;
  bool isLoadingRecoveryEmailWithApple = false;
  var resProfile;
  dynamic _pickImageError;
  List<XFile>? _mediaFileList;
  String? _retrieveDataError;

  final username = TextEditingController();
  final email = TextEditingController();
  final recoveryEmail = TextEditingController();
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
    recoveryEmail.dispose();
    super.dispose();
  }

  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  Future<dynamic> getDataProfile({refetch = false}) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          if (refetch) {
            isLoadingUpdateProfile = true;
          } else {
            isLoadingGetProfile = true;
          }
        });
      }

      var res = await handleGetDataProfile();

      if (res != null) {
        if (mounted) {
          setState(() {
            resProfile = res;
            log('DATA PROFILE DETAIL ${resProfile?["data"]?["linkedAccount"]}');
            email.text = resProfile["data"]?["email"];
            recoveryEmail.text = resProfile["data"]?["recoveryEmail"];
            username.text = resProfile["data"]?["username"];
            isLoadingGetProfile = false;
            isLoadingUpdateProfile = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingGetProfile = false;
          isLoadingUpdateProfile = false;
        });
      }
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

  Future handleLogout() async {
    FirebaseAuth.instance.signOut().then((value) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.remove('access_token').then((value) {
          Application.router.navigateTo(context, "/", transition: TransitionType.native);

          setState(() {
            isLoadingRecoveryEmailWithGoogle = false;
          });
        }).catchError((onError) {
          setState(() {
            isLoadingRecoveryEmailWithGoogle = false;
          });
        });
      }).catchError((onError) {
        setState(() {
          isLoadingRecoveryEmailWithGoogle = false;
        });
      });
    }).catchError((err) {
      setState(() {
        isLoadingRecoveryEmailWithGoogle = false;
      });
    });
  }

  void handleBack() {
    final arguments = MyArgumentsDataClass(true, false, false, false);

    Application.router.navigateTo(context, "/privateScreens", transition: TransitionType.inFromRight, routeSettings: RouteSettings(arguments: arguments));
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  signInWithGoogle() {
    setState(() {
      isLoadingRecoveryEmailWithGoogle = true;
    });

    FirebaseAuth.instance.signOut().then((value) {
      googleSignIn.signIn().then((result) {
        FirebaseAuth.instance.fetchSignInMethodsForEmail(result!.email).then((valSignInMethods) {
          if (valSignInMethods.contains("google.com")) {
            return "0";
          } else {
            return "1";
          }
        });

        result.authentication.then((GoogleSignInAuthentication googleKey) {
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleKey.accessToken,
            idToken: googleKey.idToken,
          );

          final AuthCredential credentialWeb = GoogleAuthProvider.credential(idToken: googleKey.idToken);

          FirebaseAuth.instance.signInWithCredential(kIsWeb ? credentialWeb : credential).then((valCredential) {
            FirebaseMessaging.instance.getToken().then((valTokenMessageAndroid) {
              FirebaseMessaging.instance.getAPNSToken().then((valueAPNSTokeniOS) {
                var dataAuthLogin = TargetPlatform.iOS == defaultTargetPlatform
                    ? {
                        "id_token": googleKey.idToken,
                        "access_token": googleKey.accessToken,
                        "provider": credential.providerId,
                        "fcm_token": valueAPNSTokeniOS,
                      }
                    : {
                        'id_token': googleKey.idToken,
                        'access_token': googleKey.accessToken,
                        'provider': credential.providerId,
                        "fcm_token": valTokenMessageAndroid,
                      };

                setRecoveryEmail(dataAuthLogin).then((value) {
                  if (value["statusCode"] == 400) {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              backgroundColor: greySmoothColor,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(value["message"].toString(),
                                      textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white)),
                                ],
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomButton(
                                      buttonText: 'OK',
                                      onPressed: () {
                                        Navigator.pop(context, 'OK');
                                      },
                                      labelSize: 12,
                                      height: 36,
                                      width: 100,
                                    ),
                                  ],
                                )
                              ],
                            ));
                  } else {
                    handleLogout();
                  }
                  setState(() {
                    isLoadingRecoveryEmailWithGoogle = false;
                  });
                }).catchError((onError) {
                  setState(() {
                    isLoadingRecoveryEmailWithGoogle = false;
                  });
                });
              }).catchError((onError) {
                setState(() {
                  isLoadingRecoveryEmailWithGoogle = false;
                });
              });
            }).catchError((onError) {
              setState(() {
                isLoadingRecoveryEmailWithGoogle = false;
              });
            });
          }).catchError((err) {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error signInWithCredential'),
                  content: Text(err.toString()),
                );
              },
            );

            setState(() {
              isLoadingRecoveryEmailWithGoogle = false;
            });
          });
        }).catchError((err) {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error signInWithProvider'),
                content: Text(err.toString()),
              );
            },
          );

          setState(() {
            isLoadingRecoveryEmailWithGoogle = false;
          });
        });
      }).catchError((err) {
        setState(() {
          isLoadingRecoveryEmailWithGoogle = false;
        });
      });
    }).catchError((onError) {});
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
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return const Center(child: Text('This image type is not supported'));
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
      return Shimmer(
          linearGradient: shimmerGradient,
          child: isLoadingGetProfile
              ? MyWidgetShimmerApp(
                  isLoading: isLoadingGetProfile,
                  child: const CircleAvatar(
                    radius: 40,
                  ))
              : Text(
                  'Pick image error: $_pickImageError',
                  textAlign: TextAlign.center,
                ));
    }
  }

  Future<dynamic> handleUpdateProfile({context, refetch = false}) async {
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

        getDataProfile(refetch: true);

        setState(() {
          isLoadingUpdateProfile = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingUpdateProfile = false;
      });
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
    if (val == "" || val == null || val.isEmpty || !val.contains("http")) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: blackSolidPrimaryColor,
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 16,
              ),
              Text('Warning!', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
              SizedBox(
                height: 8,
              ),
              Text('Social account link is not valid', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: greySecondaryColor)),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            CustomButton(
              buttonText: 'OK',
              onPressed: () {
                Navigator.pop(context, 'OK');
              },
              labelSize: 12,
              height: 36,
              width: 120,
            ),
          ],
        ),
      );
    } else {
      final Uri url = Uri.parse(val);

      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          handleBack();
        },
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
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                        opacity: 0.7,
                        child: Image.asset(
                          'assets/images/bg_profile.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 170,
                          alignment: Alignment.topCenter,
                        )),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if ((_picker.supportsImageSource(ImageSource.camera))) {
                              _onImageButtonPressed(ImageSource.camera, context: context);
                            }
                          },
                          child: CircleAvatar(
                              radius: 40,
                              child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                                  ? FutureBuilder<void>(
                                      future: retrieveLostData(),
                                      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.none:
                                          case ConnectionState.waiting:
                                            return _previewImages();
                                          // return const Text(
                                          //   'You have not yet picked an image.',
                                          //   textAlign: TextAlign.center,
                                          // );
                                          case ConnectionState.done:
                                            return _previewImages();
                                          case ConnectionState.active:
                                            return _previewImages();
                                          // if (snapshot.hasError) {
                                          //   return Text(
                                          //     'Pick image/video error: ${snapshot.error}}',
                                          //     textAlign: TextAlign.center,
                                          //   );
                                          // } else {
                                          //   return const Text(
                                          //     'You have not yet picked an image.',
                                          //     textAlign: TextAlign.center,
                                          //   );
                                          // }
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Username',
                            style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (isLoadingGetProfile)
                        MyWidgetShimmerApp(
                            isLoading: isLoadingGetProfile,
                            child: const Card(
                              child: SizedBox(
                                width: 320,
                                height: 40,
                              ),
                            )),
                      if (!isLoadingGetProfile)
                        CustomTextField(
                          borderRadius: 4,
                          textField: TextField(
                              controller: username,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Username',
                                hintStyle: const TextStyle(color: greySecondaryColor),
                              )),
                        ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Row(
                        children: [
                          Text(
                            'Email Address',
                            style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (isLoadingGetProfile)
                        MyWidgetShimmerApp(
                            isLoading: isLoadingGetProfile,
                            child: const Card(
                              child: SizedBox(
                                width: 320,
                                height: 40,
                              ),
                            )),
                      if (!isLoadingGetProfile)
                        CustomTextField(
                          isDisabled: true,
                          borderRadius: 4,
                          textField: TextField(
                              enabled: false,
                              controller: email,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Email address',
                                hintStyle: const TextStyle(color: greySecondaryColor),
                              )),
                        ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Row(
                        children: [
                          Text(
                            'Email Recovery',
                            style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (recoveryEmail.text.isNotEmpty)
                        CustomTextField(
                          borderRadius: 4,
                          textField: TextField(
                            onTap: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.black,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const RecoveryEmailBottomSheetApp();
                                  });
                            },
                            readOnly: true,
                            controller: recoveryEmail,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            decoration: kTextInputDecoration.copyWith(
                              hintText: 'Recovery email',
                              hintStyle: const TextStyle(color: greySecondaryColor),
                            ),
                          ),
                        ),
                      if (recoveryEmail.text.isEmpty && Platform.isIOS) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                if (!(isLoadingRecoveryEmailWithGoogle || isLoadingRecoveryEmailWithApple)) {
                                  signInWithGoogle();
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2.3,
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF505052).withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: isLoadingRecoveryEmailWithGoogle
                                    ? const Center(
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: yellowPrimaryColor,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/images/ic_google.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            'with Gmail',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: yellowPrimaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (!(isLoadingRecoveryEmailWithGoogle || isLoadingRecoveryEmailWithApple)) {
                                  signInWithGoogle();
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2.3,
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF505052).withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: isLoadingRecoveryEmailWithGoogle
                                    ? const Center(
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: yellowPrimaryColor,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/images/ic_apple.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            'with Apple ID',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: yellowPrimaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        InkWell(
                          onTap: () {
                            if (!(isLoadingRecoveryEmailWithGoogle || isLoadingRecoveryEmailWithApple)) {
                              signInWithGoogle();
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            decoration: BoxDecoration(
                              color: const Color(0xFF505052).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: isLoadingRecoveryEmailWithGoogle
                                ? const Center(
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: yellowPrimaryColor,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/ic_google.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'with Gmail',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: yellowPrimaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                      const SizedBox(
                        height: 16,
                      ),
                      const Row(
                        children: [
                          Text(
                            'Linked Account',
                            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Column(
                        children: resProfile?["data"]?["linkedAccount"] != null
                            ? (resProfile?["data"]?["linkedAccount"] as Map<String, dynamic>)
                                .entries
                                .map((item) => Column(
                                      children: [
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        CustomButton(
                                            isOutlinedBackgroundColor: blackPrimaryColor,
                                            buttonText: 'Connect to ${item.key}',
                                            isOutlined: true,
                                            onPressed: () {
                                              _launchUrl(item.value);
                                            },
                                            labelSize: 12,
                                            sizeButtonIcon: 20,
                                            buttonIcon: 'ic_${item.key}.png',
                                            width: 500,
                                            paddingButton: 0)
                                      ],
                                    ))
                                .toList()
                            : [],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                      )
                    ],
                  ),
                ),
              ],
            ),
            // This is the title in the app bar.
          ),
          bottomSheet: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black,
              child: Shimmer(
                linearGradient: shimmerGradient,
                child: MyWidgetShimmerApp(
                    isLoading: isLoadingGetProfile,
                    child: CustomButton(
                        isLoading: isLoadingUpdateProfile,
                        buttonText: 'Save',
                        onPressed: () {
                          if (!isLoadingUpdateProfile) {
                            handleUpdateProfile(context: context, refetch: true);
                          }
                        },
                        sizeButtonIcon: 20,
                        labelSize: 14,
                        width: 500,
                        height: 44,
                        paddingButton: 0)),
              )),
        ));
  }
}

class MyArgumentsDataClass {
  final bool goToProfile;
  final bool goToCommunity;
  final bool goToVoucher;
  final bool goToMission;

  MyArgumentsDataClass(this.goToProfile, this.goToCommunity, this.goToVoucher, this.goToMission);
}
