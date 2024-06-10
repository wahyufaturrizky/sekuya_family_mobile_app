/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dio = Dio();

/// The scopes required by this application.
// #docregion Initialize
const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn googleSignIn = kIsWeb
    ? GoogleSignIn(
        scopes: scopes,
        clientId:
            "433294916757-ebvrl9qvhgvn3vqo3j2k9elirj7t1k7r.apps.googleusercontent.com")
    : GoogleSignIn(
        scopes: scopes,
      );
// #enddocregion Initialize

class LoginScreenApp extends StatelessWidget {
  const LoginScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}

class LoginScreen extends StatefulWidget {
  LoginScreen({
    super.key,
  });

  final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoadingSignInWithApple = false;
  bool isLoadingSignInWithGoogle = false;

  @override
  void initState() {
    _loadAccessToken();
    _sendAnalyticsEvent();

    super.initState();
  }

  Future<void> _sendAnalyticsEvent() async {
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: 'login_page',
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final accessToken = prefs.getString('access_token') ?? '';

      if (accessToken != '') {
        await FirebaseAnalytics.instance.logEvent(
          name: "access_token_Load_Success",
          parameters: {
            "value": accessToken,
          },
        );

        Application.router.navigateTo(
          context,
          "/privateScreens",
          transition: TransitionType.inFromLeft,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();
      await FirebaseAuth.instance.signInWithProvider(appleProvider);
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
    }
  }

  signInWithGoogle() {
    setState(() {
      isLoadingSignInWithGoogle = true;
    });

    googleSignIn.disconnect().then((value) {
      googleSignIn.signIn().then((result) {
        FirebaseAuth.instance
            .fetchSignInMethodsForEmail(result!.email)
            .then((valSignInMethods) {
          if (valSignInMethods.contains("google.com")) {
            print("Email is already associated with a Google Sign-In account.");
            return "0";
          } else {
            print("Email is not associated with any account.");
            return "1";
          }
        });

        result.authentication.then((GoogleSignInAuthentication googleKey) {
          print("googleKey AccessToken = ${googleKey.accessToken}");
          print("googleKey IdToken = ${googleKey.idToken}");

          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleKey.accessToken,
            idToken: googleKey.idToken,
          );

          final AuthCredential credentialWeb =
              GoogleAuthProvider.credential(idToken: googleKey.idToken);

          FirebaseAuth.instance
              .signInWithCredential(kIsWeb ? credentialWeb : credential)
              .then((valCredential) {
            FirebaseMessaging.instance
                .getToken()
                .then((valTokenMessageAndroid) {
              print('@valTokenMessageAndroid = $valTokenMessageAndroid');

              FirebaseMessaging.instance
                  .getAPNSToken()
                  .then((valueAPNSTokeniOS) {
                print('@valueAPNSTokeniOS = $valueAPNSTokeniOS');
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

                print("@dataAuthLogin = $dataAuthLogin");

                dio
                    .post('$baseUrl/auth/login',
                        options: Options(
                            validateStatus: (_) => true,
                            contentType: Headers.jsonContentType,
                            responseType: ResponseType.json),
                        data: dataAuthLogin)
                    .then((valResFromXellar) {
                  print("@valResFromXellar = ${valResFromXellar.data}");

                  if (valResFromXellar.data?["data"]?["recoverToken"] != null) {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              backgroundColor: greySmoothColor,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/images/ic_google_medium.png',
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    width: 250,
                                    decoration: const BoxDecoration(
                                        color: blackSolidPrimaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Column(
                                      children: [
                                        Text(result.displayName.toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white)),
                                        Text(result.email.toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: greySecondaryColor)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                      'This email is registered as recovery email, do you want to recover your account?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: greySecondaryColor)),
                                ],
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomButton(
                                      buttonText: 'Yes',
                                      onPressed: () {
                                        Navigator.pop(context, 'Yes');

                                        dio
                                            .post('$baseUrl/auth/recover-email',
                                                options: Options(
                                                    validateStatus: (_) => true,
                                                    contentType:
                                                        Headers.jsonContentType,
                                                    responseType:
                                                        ResponseType.json,
                                                    headers: {
                                                      'Authorization':
                                                          'Bearer ${valResFromXellar.data?["data"]?["recoverToken"]}'
                                                    }),
                                                data: dataAuthLogin)
                                            .then((resRecoverToken) {
                                          print(
                                              "@resRecoverToken = ${resRecoverToken.data?["data"]?["accessToken"]}");

                                          SharedPreferences.getInstance()
                                              .then((prefs) {
                                            prefs
                                                .setString(
                                                    'access_token',
                                                    resRecoverToken
                                                            .data?["data"]
                                                        ?["accessToken"])
                                                .then((value) {
                                              Application.router.navigateTo(
                                                  context, "/privateScreens",
                                                  transition:
                                                      TransitionType.native);

                                              setState(() {
                                                isLoadingSignInWithGoogle =
                                                    false;
                                              });
                                            }).catchError((onError) {
                                              print(
                                                  "@onError resRecoverToken = $onError");

                                              setState(() {
                                                isLoadingSignInWithGoogle =
                                                    false;
                                              });
                                            });
                                          }).catchError((onError) {
                                            print(
                                                'onError SharedPreferences = $onError');

                                            setState(() {
                                              isLoadingSignInWithGoogle = false;
                                            });
                                          });
                                        }).catchError((onError) {
                                          setState(() {
                                            isLoadingSignInWithGoogle = false;
                                          });
                                          print(
                                              "onError recover-email $onError");
                                        });
                                      },
                                      labelSize: 12,
                                      height: 36,
                                      width: 100,
                                    ),
                                    CustomButton(
                                      buttonText: 'No',
                                      isOutlined: true,
                                      border: 1,
                                      isOutlinedBackgroundColor:
                                          blackSolidPrimaryColor,
                                      isOutlinedBorderColor: yellowPrimaryColor,
                                      labelSize: 12,
                                      width: 100,
                                      height: 36,
                                      onPressed: () {
                                        Navigator.pop(context, 'No');
                                        setState(() {
                                          isLoadingSignInWithGoogle = false;
                                        });
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ));
                  } else {
                    SharedPreferences.getInstance().then((prefs) {
                      prefs
                          .setString('access_token',
                              valResFromXellar.data['data']?['accessToken'])
                          .then((value) {
                        Application.router.navigateTo(
                            context, "/privateScreens",
                            transition: TransitionType.native);

                        setState(() {
                          isLoadingSignInWithGoogle = false;
                        });
                      }).catchError((onError) {
                        print(onError);

                        setState(() {
                          isLoadingSignInWithGoogle = false;
                        });
                      });
                    }).catchError((onError) {
                      print('onError SharedPreferences = $onError');

                      setState(() {
                        isLoadingSignInWithGoogle = false;
                      });
                    });
                  }
                }).catchError((onError) {
                  print('onError auth/login = $onError');

                  setState(() {
                    isLoadingSignInWithGoogle = false;
                  });
                });
              }).catchError((onError) {
                print("onError Token APNS $onError");
                setState(() {
                  isLoadingSignInWithGoogle = false;
                });
              });
            }).catchError((onError) {
              print("onError valTokenMessageAndroid = $onError");
              setState(() {
                isLoadingSignInWithGoogle = false;
              });
            });
          }).catchError((err) {
            print('Error signInWithCredential = $err');

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
              isLoadingSignInWithGoogle = false;
            });
          });
        }).catchError((err) {
          print('Error signInWithProvider = $err');

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
            isLoadingSignInWithGoogle = false;
          });
        });
      }).catchError((err) {
        print('Error signIn = $err');

        setState(() {
          isLoadingSignInWithGoogle = false;
        });
      });
    }).catchError((onError) {
      print("@onError disconnect = $onError");
      setState(() {
        isLoadingSignInWithGoogle = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopScreenImage(screenImageName: 'login_intro.png'),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 15.0, left: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Column(
                        children: [
                          ScreenTitle(title: 'Sign In Your Account'),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Please select your Gmail or Apple ID account to explore and collect your dream NFT.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Hero(
                            tag: 'login_btn',
                            child: CustomButton(
                                isOutlinedBackgroundColor: blackPrimaryColor,
                                isLoading: isLoadingSignInWithGoogle,
                                buttonText: 'Continue with Gmail',
                                onPressed: () {
                                  if (!(isLoadingSignInWithGoogle ||
                                      isLoadingSignInWithApple)) {
                                    signInWithGoogle();
                                  }
                                },
                                buttonIcon: "ic_google.png",
                                isOutlined: true,
                                sizeButtonIcon: 20,
                                width: 500,
                                paddingButton: 0),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Hero(
                            tag: 'signup_btn',
                            child: CustomButton(
                                isOutlinedBackgroundColor: blackPrimaryColor,
                                isLoading: isLoadingSignInWithApple,
                                buttonText: 'Continue with Apple ID',
                                isOutlined: true,
                                onPressed: () {
                                  if (!(isLoadingSignInWithApple ||
                                      isLoadingSignInWithGoogle)) {
                                    signInWithApple();
                                  }
                                },
                                buttonIcon: "ic_apple.png",
                                sizeButtonIcon: 20,
                                width: 500,
                                paddingButton: 0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
