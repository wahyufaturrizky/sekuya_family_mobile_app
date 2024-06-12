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

class AnswerNotesApp extends StatelessWidget {
  const AnswerNotesApp({
    super.key,
    this.image,
    this.name,
    this.exp,
    this.description,
    this.isLoadingSubmitTaskMission,
    this.onPressedSubmitTaskMission,
    this.additionalAttributeAnswerNotes,
    this.onExpansionChanged,
    this.status,
    this.reason,
    this.submittedAdditionalAttribute,
  });

  final dynamic image;
  final dynamic name;
  final dynamic exp;
  final dynamic description;
  final bool? isLoadingSubmitTaskMission;
  final dynamic onPressedSubmitTaskMission;
  final dynamic additionalAttributeAnswerNotes;
  final dynamic onExpansionChanged;
  final dynamic status;
  final dynamic reason;
  final dynamic submittedAdditionalAttribute;

  @override
  Widget build(BuildContext context) {
    return AnswerNotes(
      image: image,
      name: name,
      exp: exp,
      description: description,
      isLoadingSubmitTaskMission: isLoadingSubmitTaskMission,
      onPressedSubmitTaskMission: onPressedSubmitTaskMission,
      additionalAttributeAnswerNotes: additionalAttributeAnswerNotes,
      onExpansionChanged: onExpansionChanged,
      status: status,
      reason: reason,
      submittedAdditionalAttribute: submittedAdditionalAttribute,
    );
  }
}

class AnswerNotes extends StatefulWidget {
  const AnswerNotes({
    super.key,
    this.image,
    this.name,
    this.exp,
    this.description,
    this.isLoadingSubmitTaskMission,
    this.onPressedSubmitTaskMission,
    this.additionalAttributeAnswerNotes,
    this.onExpansionChanged,
    this.status,
    this.reason,
    this.submittedAdditionalAttribute,
  });

  final dynamic image;
  final dynamic name;
  final dynamic exp;
  final dynamic description;
  final bool? isLoadingSubmitTaskMission;
  final dynamic onPressedSubmitTaskMission;
  final dynamic additionalAttributeAnswerNotes;
  final dynamic onExpansionChanged;
  final dynamic status;
  final dynamic reason;
  final dynamic submittedAdditionalAttribute;

  @override
  State<AnswerNotes> createState() => _AnswerNotesState();
}

class _AnswerNotesState extends State<AnswerNotes> {
  @override
  Widget build(BuildContext context) {
    double contextWidth = MediaQuery.of(context).size.width * 0.8;

    var image = widget.image;
    var name = widget.name;
    var exp = widget.exp;
    var status = widget.status;

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
                    if (widget.reason != '')
                      Text("Reason reject: ${widget.reason}",
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
          CustomTextField(
            borderRadius: 4,
            borderWidth: 1,
            textField: TextField(
                maxLines: 8,
                readOnly:
                    !["NOT_SUBMITTED", "REJECTED"].contains(widget.status),
                controller: widget.additionalAttributeAnswerNotes,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                decoration: kTextInputDecoration.copyWith(
                  hintText:
                      ["NOT_SUBMITTED", "REJECTED"].contains(widget.status)
                          ? 'Your answer'
                          : widget.submittedAdditionalAttribute,
                  hintStyle: const TextStyle(color: greySecondaryColor),
                )),
          ),
          const SizedBox(
            height: 16,
          ),
          CustomButton(
            buttonText: 'Submit',
            isLoading: widget.isLoadingSubmitTaskMission!,
            onPressed: () {
              widget.onPressedSubmitTaskMission!();
            },
            width: 500,
            isOutlined: !["NOT_SUBMITTED", "REJECTED"].contains(widget.status),
          ),
          const SizedBox(
            height: 16,
          ),
        ]);
  }
}
