import 'package:flutter/material.dart';

const Color kBackgroundColor = Color(0xFFD4DEF7);
const Color kTextColor = Color(0xFF4879C5);
const Color greyColor = Color.fromRGBO(80, 80, 82, 1);
const Color greyDarkColor = Color.fromRGBO(80, 80, 82, 0.3);
const Color mainBlackColor = Color.fromRGBO(15, 15, 16, 1);
const Color blackPrimaryColor = Color.fromRGBO(36, 36, 39, 1);
const Color greySecondaryColor = Color.fromRGBO(135, 135, 135, 1);
const Color greyThirdColor = Color.fromRGBO(158, 158, 158, 1);
const Color bluePrimaryColor = Color.fromRGBO(0, 100, 255, 1);
const Color greySecondWinnerColor = Color.fromRGBO(188, 188, 188, 1);
const Color redThirdWinnerColor = Color.fromRGBO(252, 97, 63, 1);
const Color blueSecondaryColor = Color.fromRGBO(20, 49, 61, 1);
const Color blueSolidSecondaryColor = Color.fromRGBO(42, 182, 242, 1);
const Color blackSolidPrimaryColor = Color.fromRGBO(26, 26, 28, 1);
const Color redSolidPrimaryColor = Color.fromRGBO(242, 42, 42, 1);
const Color yellowPrimaryColor = Color.fromRGBO(252, 193, 63, 1);
const Color yellowPrimaryTransparentColor = Color.fromRGBO(252, 193, 63, 0.16);
const Color greySoftColor = Color.fromRGBO(71, 71, 71, 1);
const Color greySoftSecondaryColor = Color.fromRGBO(129, 133, 139, 1);
const Color greySoftThirdColor = Color.fromRGBO(110, 106, 102, 1);
const Color greySoftFourthColor = Color.fromRGBO(81, 77, 73, 1);
const Color goldenColor = Color.fromRGBO(179, 137, 45, 1);
const Color goldenSoftColor = Color.fromRGBO(252, 193, 63, 0.1);
const Color greenColor = Color.fromRGBO(3, 166, 29, 1);
const Color greySmoothColor = Color.fromRGBO(33, 33, 35, 1);
const Color greyLightColor = Color.fromRGBO(222, 222, 222, 1);
const Color backNavigationColor = Color.fromRGBO(20, 20, 21, 0.48);
const String baseUrl = 'https://api.sekuyafamily.xellar.co/api/v1';
const String baseUrlXellarLabs = 'https://api.sekuyalabs.xellar.co/api/v1';
const String baseUrlMapGoogleApi = 'https://maps.googleapis.com/maps/api';
const InputDecoration kTextInputDecoration = InputDecoration(
  border: InputBorder.none,
  hintText: '',
  // ),
);

const shimmerGradient = LinearGradient(
  colors: [
    Color.fromRGBO(32, 32, 32, 1),
    Color.fromRGBO(68, 68, 68, 1),
    Color.fromRGBO(32, 32, 32, 1),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);
