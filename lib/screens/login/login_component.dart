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
import 'package:fluro/fluro.dart';
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

GoogleSignIn _googleSignIn = GoogleSignIn(
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAccessToken();
    _sendAnalyticsEvent();
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

  Future<dynamic> signInWithGoogle() async {
    try {
      setState(() {
        isLoading = true;
      });

      _googleSignIn.signIn().then((result) {
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

        result?.authentication.then((googleKey) {
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleKey.accessToken,
            idToken: googleKey.idToken,
          );

          FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((valCredential) {
            dio.post('$baseUrl/auth/login',
                options: Options(
                    validateStatus: (_) => true,
                    contentType: Headers.jsonContentType,
                    responseType: ResponseType.json),
                data: {
                  'id_token': googleKey.idToken,
                  'access_token': googleKey.accessToken,
                  'provider': credential.providerId,
                }).then((valResFromXellar) {
              // print(valResFromXellar);
              SharedPreferences.getInstance().then((prefs) {
                prefs
                    .setString('access_token',
                        valResFromXellar.data['data']['accessToken'])
                    .then((value) {
                  Application.router.navigateTo(context, "/privateScreens",
                      transition: TransitionType.native);

                  setState(() {
                    isLoading = false;
                  });
                }).catchError((onError) {
                  print(onError);

                  setState(() {
                    isLoading = false;
                  });
                });
              }).catchError((onError) {
                print('onError $onError');

                setState(() {
                  isLoading = false;
                });
              });
            }).catchError((onError) {
              print('onError xellar = $onError');

              setState(() {
                isLoading = false;
              });
            });
          }).catchError((err) {
            print('inner error');

            setState(() {
              isLoading = false;
            });
          });
        }).catchError((err) {
          print('inner error');

          setState(() {
            isLoading = false;
          });
        });
      }).catchError((err) {
        print('error occured = $err');

        setState(() {
          isLoading = false;
        });
      });
    } catch (error) {
      print("Error during Google sign-in: $error");

      setState(() {
        isLoading = false;
      });
    }
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
                                isLoading: isLoading,
                                buttonText: 'Continue with Gmail',
                                onPressed: () {
                                  if (!isLoading) {
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
                                isLoading: isLoading,
                                buttonText: 'Continue with Apple ID',
                                isOutlined: true,
                                onPressed: () {
                                  if (!isLoading) {
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
