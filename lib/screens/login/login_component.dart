/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';

class LoginComponent extends StatefulWidget {
  const LoginComponent({super.key});

  @override
  State createState() => LoginComponentState();
}

class LoginComponentState extends State<LoginComponent> {
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
                          const SizedBox(
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
                                onPressed: () {},
                                buttonIcon: "ic_google.png",
                                isOutlined: true,
                                sizeButtonIcon: 20,
                                width: 500,
                                paddingButton: 0),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Hero(
                            tag: 'signup_btn',
                            child: CustomButton(
                                buttonText: 'Continue with Apple ID',
                                isOutlined: true,
                                onPressed: () {},
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
