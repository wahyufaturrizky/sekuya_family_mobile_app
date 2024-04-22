/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
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
  // Optional clientId
  clientId:
      '433294916757-ebvrl9qvhgvn3vqo3j2k9elirj7t1k7r.apps.googleusercontent.com',
  scopes: scopes,
);
// #enddocregion Initialize

class LoginScreenApp extends StatelessWidget {
  const LoginScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';
  ValueNotifier userCredential = ValueNotifier('');

  @override
  void initState() {
    print('--- initState ---');

    print('userCredential = $userCredential');
    super.initState();

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      bool isAuthorized = account != null;

      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });
    });
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

  Future<void> signInWithGoogle() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<dynamic> signInWithGoogle2() async {
    print("--- signInWithGoogle ---");

    try {
      _googleSignIn.signIn().then((result) {
        print('@result = $result');

        // FirebaseAuth.instance
        //     .fetchSignInMethodsForEmail(result!.email)
        //     .then((valSignInMethods) {
        //   if (valSignInMethods.contains("google.com")) {
        //     print("Email is already associated with a Google Sign-In account.");
        //     return "0";
        //   } else {
        //     print("Email is not associated with any account.");
        //     return "1";
        //   }
        // });

        // result?.authentication.then((googleKey) async {
        //   print(googleKey.accessToken);
        //   print(googleKey.idToken);
        //   print(_googleSignIn.currentUser?.displayName);

        //   final AuthCredential credential = GoogleAuthProvider.credential(
        //     accessToken: googleKey.accessToken,
        //     idToken: googleKey.idToken,
        //   );

        //   FirebaseAuth.instance
        //       .signInWithCredential(credential)
        //       .then((valCredential) {
        //     print('@valCredential = $valCredential');

        //     dio.post('$baseUrl/account/google', data: {
        //       'id_token': googleKey.idToken,
        //       'access_token': googleKey.accessToken,
        //       'provider': credential.providerId,
        //     }).then((valResFromXellar) {
        //       print('@valResFromXellar = $valResFromXellar');

        //       SharedPreferences.getInstance().then((prefs) {
        //         prefs
        //             .setInt('access_token', valResFromXellar.data.accessToken)
        //             .then((value) => {
        //                   Application.router.navigateTo(
        //                       context, "/privatescreens",
        //                       transition: TransitionType.native)
        //                 })
        //             .catchError((onError) => print(onError));
        //       }).catchError((onError) {
        //         print('onError $onError');
        //       });
        //     }).catchError((onError) {
        //       print('onError xellar = $onError');
        //     });
        //   }).catchError((err) {
        //     print('inner error');
        //   });
        // }).catchError((err) {
        //   print('inner error');
        // });
      }).catchError((err) {
        print('error occured');
      });
    } catch (error) {
      print("Error during Google sign-in: $error");
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
                                buttonText: 'Continue with Gmail',
                                onPressed: () {
                                  signInWithGoogle();
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
                                buttonText: 'Continue with Apple ID',
                                isOutlined: true,
                                onPressed: () {
                                  signInWithApple();
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
