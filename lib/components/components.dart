import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonText,
    this.isOutlined = false,
    required this.onPressed,
    this.width = 280,
    this.height = 60,
    this.border = 2.5,
    this.buttonIcon = "",
    this.isOutlinedBackgroundColor = greyColor,
    this.isOutlinedBorderColor = Colors.transparent,
    this.sizeButtonIcon = 20,
    this.labelSize = 18,
    this.paddingButton = 0,
    this.marginRight = 0,
    this.isLoading = false,
  });

  final String buttonText;
  final Color isOutlinedBackgroundColor;
  final Color isOutlinedBorderColor;
  final bool isOutlined;
  final bool isLoading;
  final double border;
  final Function onPressed;
  final double width;
  final double height;
  final double paddingButton;
  final double sizeButtonIcon;
  final double marginRight;
  final double labelSize;
  final String buttonIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Material(
        borderRadius: BorderRadius.circular(30),
        elevation: isOutlinedBackgroundColor == Colors.transparent ? 0 : 4,
        color: isOutlined ? isOutlinedBackgroundColor : yellowPrimaryColor,
        child: Container(
          width: width,
          height: height,
          margin: EdgeInsets.only(right: marginRight),
          padding: EdgeInsets.all(paddingButton),
          decoration: BoxDecoration(
            color: isOutlined ? isOutlinedBackgroundColor : yellowPrimaryColor,
            border: isOutlined
                ? Border.all(color: isOutlinedBorderColor, width: border)
                : Border.all(color: yellowPrimaryColor, width: border),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  Row(
                    children: [
                      Center(
                          child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: isOutlined
                                    ? yellowPrimaryColor
                                    : Colors.white,
                              ))),
                      const SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                if (buttonIcon != "")
                  CircleAvatar(
                    radius: sizeButtonIcon,
                    backgroundColor: Colors.transparent,
                    child: Image.asset('assets/images/$buttonIcon'),
                  ),
                Text(
                  buttonText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: labelSize,
                    color: isOutlined
                        ? yellowPrimaryColor
                        : blackSolidPrimaryColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopScreenImage extends StatelessWidget {
  const TopScreenImage({super.key, required this.screenImageName});
  final String screenImageName;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage('assets/images/$screenImageName'),
          ),
        ),
      ),
    );
  }
}

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      textAlign: TextAlign.center,
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.textField,
      this.borderRadius = 40.0,
      this.borderWidth = 2.5});
  final TextField textField;
  final double borderRadius;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          width: borderWidth,
          color: Colors.white,
        ),
      ),
      child: textField,
    );
  }
}

class CustomBottomScreen extends StatelessWidget {
  const CustomBottomScreen({
    super.key,
    required this.textButton,
    required this.question,
    this.heroTag = '',
    required this.buttonPressed,
    required this.questionPressed,
  });
  final String textButton;
  final String question;
  final String heroTag;
  final Function buttonPressed;
  final Function questionPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: GestureDetector(
              onTap: () {
                questionPressed();
              },
              child: Text(question),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Hero(
            tag: heroTag,
            child: CustomButton(
              buttonText: textButton,
              width: 150,
              onPressed: () {
                buttonPressed();
              },
            ),
          ),
        ),
      ],
    );
  }
}
