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
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/util/status.dart';

class QuizApp extends StatelessWidget {
  QuizApp({
    super.key,
    this.image,
    this.name,
    this.exp,
    this.description,
    this.additionalAttribute,
    this.retrieveLostData,
    this.previewImages,
    this.isLoadingSubmitTaskMission,
    this.onPressedSubmitTaskMission,
    this.additionalAttributeAnswerNotes,
    this.onExpansionChanged,
    this.selectedChoice,
    this.onChangedQuizChoice,
    this.status,
    this.reason,
    this.submittedAdditionalAttribute,
  });

  final dynamic image;
  final dynamic name;
  final dynamic exp;
  final dynamic description;
  final dynamic additionalAttribute;
  final dynamic retrieveLostData;
  final dynamic previewImages;
  final bool? isLoadingSubmitTaskMission;
  final dynamic onPressedSubmitTaskMission;
  final dynamic additionalAttributeAnswerNotes;
  final dynamic onExpansionChanged;
  dynamic selectedChoice;
  dynamic onChangedQuizChoice;
  dynamic status;
  dynamic reason;
  dynamic submittedAdditionalAttribute;

  @override
  Widget build(BuildContext context) {
    return Quiz(
      image: image,
      name: name,
      exp: exp,
      description: description,
      retrieveLostData: retrieveLostData,
      previewImages: previewImages,
      isLoadingSubmitTaskMission: isLoadingSubmitTaskMission,
      onPressedSubmitTaskMission: onPressedSubmitTaskMission,
      additionalAttributeAnswerNotes: additionalAttributeAnswerNotes,
      onExpansionChanged: onExpansionChanged,
      additionalAttribute: additionalAttribute,
      selectedChoice: selectedChoice,
      onChangedQuizChoice: onChangedQuizChoice,
      status: status,
      reason: reason,
      submittedAdditionalAttribute: submittedAdditionalAttribute,
    );
  }
}

class Quiz extends StatefulWidget {
  Quiz({
    super.key,
    this.image,
    this.name,
    this.exp,
    this.description,
    this.retrieveLostData,
    this.previewImages,
    this.isLoadingSubmitTaskMission,
    this.onPressedSubmitTaskMission,
    this.additionalAttributeAnswerNotes,
    this.onExpansionChanged,
    this.additionalAttribute,
    this.selectedChoice,
    this.onChangedQuizChoice,
    this.status,
    this.reason,
    this.submittedAdditionalAttribute,
  });

  final dynamic image;
  final dynamic name;
  final dynamic exp;
  final dynamic description;
  final dynamic retrieveLostData;
  final dynamic previewImages;
  final bool? isLoadingSubmitTaskMission;
  final dynamic onPressedSubmitTaskMission;
  final dynamic additionalAttributeAnswerNotes;
  final dynamic onExpansionChanged;
  final dynamic additionalAttribute;
  dynamic onChangedQuizChoice;
  dynamic selectedChoice;
  dynamic status;
  dynamic reason;
  dynamic submittedAdditionalAttribute;

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  @override
  Widget build(BuildContext context) {
    double contextWidth = MediaQuery.of(context).size.width * 0.8;

    var image = widget.image;
    var name = widget.name;
    var exp = widget.exp;
    var status = widget.status;
    var reason = widget.reason;
    var isLoadingSubmitTaskMission = widget.isLoadingSubmitTaskMission;

    return ExpansionTile(
        iconColor: Colors.white,
        onExpansionChanged: (bool value) {
          if (value) {
            widget.onExpansionChanged();
          }
        },
        title: Row(
          children: [
            if (image != null)
              Image.network(
                image,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                  Text(
                    '${exp ?? ""}xp',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              handleStatusIcon(status),
              color: handleStatusColorIcon(status),
            )
          ],
        ),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container(
              //     decoration: BoxDecoration(
              //         border: Border.all(color: greySoftColor),
              //         borderRadius:
              //             const BorderRadius.all(Radius.circular(20))),
              //     child: const CircleAvatar(
              //       backgroundColor: Colors.black,
              //       radius: 16,
              //       child: Text(
              //         '1',
              //         style: TextStyle(color: yellowPrimaryColor),
              //       ),
              //     )),
              // const SizedBox(
              //   width: 16,
              // ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                width: contextWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (reason != '' && ["REJECTED"].contains(widget.status))
                      Text("Reason rejected: ${reason}",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: redSolidPrimaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    Text(widget.description ?? "",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          if (widget.additionalAttribute["question"].length > 0)
            Column(
                children:
                    (widget.additionalAttribute?["question"] as List<dynamic>)
                        .map((itemQuestion) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                                color: greySmoothColor,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: widget.selectedChoice == itemQuestion
                                        ? yellowPrimaryColor
                                        : Colors.transparent)),
                            child: RadioListTile(
                              activeColor: yellowPrimaryColor,
                              title: Text(
                                itemQuestion ?? "",
                                style: const TextStyle(color: Colors.white),
                              ),
                              value: itemQuestion ?? "",
                              groupValue:
                                  ["NOT_SUBMITTED", "REJECTED"].contains(status)
                                      ? widget.selectedChoice
                                      : widget.submittedAdditionalAttribute,
                              onChanged: (value) {
                                if (["NOT_SUBMITTED", "REJECTED"]
                                    .contains(status)) {
                                  widget.onChangedQuizChoice(value);
                                }
                              },
                            )))
                        .toList()),
          const SizedBox(
            height: 16,
          ),
          CustomButton(
            isOutlined: !["NOT_SUBMITTED", "REJECTED"].contains(status),
            buttonText: 'Submit',
            isLoading: isLoadingSubmitTaskMission!,
            onPressed: () {
              widget.onPressedSubmitTaskMission!();
            },
            width: 500,
          ),
          const SizedBox(
            height: 16,
          ),
        ]);
  }
}
