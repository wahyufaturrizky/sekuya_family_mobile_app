/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0dAPTnmmqZtmkrMTxguSLuQMl3Aj8m9I',
    appId: '1:433294916757:android:d1b51c9fd4a8832eb96f9c',
    messagingSenderId: '433294916757',
    projectId: 'sekuya-9c1b7',
    storageBucket: 'sekuya-9c1b7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBa7jQIm42TfkSnspvXoxqt4XSuNCWoa60',
    appId: '1:433294916757:ios:03baf1b2b2cac4f5b96f9c',
    messagingSenderId: '433294916757',
    projectId: 'sekuya-9c1b7',
    storageBucket: 'sekuya-9c1b7.appspot.com',
    androidClientId:
        '433294916757-5f4v7hnqiccnnisg4j9rulr4ca85j5qk.apps.googleusercontent.com',
    iosClientId:
        '433294916757-kov26lh9dh5hqdvm1uvpi49sh33q72ub.apps.googleusercontent.com',
    iosBundleId: 'com.example.sekuyaFamilyMobileApp',
  );

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyD8Phbd3dYL02uPBH1iiY4AouxjdtUNq7E",
      authDomain: "sekuya-9c1b7.firebaseapp.com",
      projectId: "sekuya-9c1b7",
      storageBucket: "sekuya-9c1b7.appspot.com",
      messagingSenderId: "433294916757",
      appId: "1:433294916757:web:58ac626f3ba9f086b96f9c",
      measurementId: "G-PH871RQEWH");
}
