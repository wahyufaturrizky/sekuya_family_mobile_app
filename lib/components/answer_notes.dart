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

class AnswerNotesApp extends StatelessWidget {
  const AnswerNotesApp(
      {super.key,
      this.image,
      this.name,
      this.exp,
      this.description,
      this.onTapTakeCamera,
      this.retrieveLostData,
      this.previewImages,
      this.isLoadingTaskMission,
      this.onPressedSubmitTaskMission,
      this.additionalAttributeAnswerNotes,
      this.onExpansionChanged});

  final dynamic image;
  final dynamic name;
  final dynamic exp;
  final dynamic description;
  final VoidCallback? onTapTakeCamera;
  final dynamic retrieveLostData;
  final dynamic previewImages;
  final bool? isLoadingTaskMission;
  final dynamic onPressedSubmitTaskMission;
  final dynamic additionalAttributeAnswerNotes;
  final dynamic onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    return AnswerNotes(
      image: image,
      name: name,
      exp: exp,
      description: description,
      onTapTakeCamera: onTapTakeCamera,
      retrieveLostData: retrieveLostData,
      previewImages: previewImages,
      isLoadingTaskMission: isLoadingTaskMission,
      onPressedSubmitTaskMission: onPressedSubmitTaskMission,
      additionalAttributeAnswerNotes: additionalAttributeAnswerNotes,
      onExpansionChanged: onExpansionChanged,
    );
  }
}

class AnswerNotes extends StatefulWidget {
  const AnswerNotes(
      {super.key,
      this.image,
      this.name,
      this.exp,
      this.description,
      this.onTapTakeCamera,
      this.retrieveLostData,
      this.previewImages,
      this.isLoadingTaskMission,
      this.onPressedSubmitTaskMission,
      this.additionalAttributeAnswerNotes,
      this.onExpansionChanged});

  final dynamic image;
  final dynamic name;
  final dynamic exp;
  final dynamic description;
  final VoidCallback? onTapTakeCamera;
  final dynamic retrieveLostData;
  final dynamic previewImages;
  final bool? isLoadingTaskMission;
  final dynamic onPressedSubmitTaskMission;
  final dynamic additionalAttributeAnswerNotes;
  final dynamic onExpansionChanged;

  @override
  State<AnswerNotes> createState() => _AnswerNotesState();
}

class _AnswerNotesState extends State<AnswerNotes> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        iconColor: Colors.white,
        onExpansionChanged: (bool value) {
          if (value) {
            widget.onExpansionChanged();
          }
        },
        title: Row(
          children: [
            if (widget.image != null)
              Image.network(
                widget.image,
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
                    widget.name ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                  Text(
                    '${widget.exp ?? ""}xp',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.check_circle,
              color: greenColor,
            )
          ],
        ),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: greySoftColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: const CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 16,
                    child: Text(
                      '1',
                      style: TextStyle(color: yellowPrimaryColor),
                    ),
                  )),
              const SizedBox(
                width: 16,
              ),
              Flexible(
                child: Text(
                  widget.description ?? "",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              )
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
                controller: widget.additionalAttributeAnswerNotes,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                decoration: kTextInputDecoration.copyWith(
                  hintText: 'Your answer',
                  hintStyle: const TextStyle(color: greySecondaryColor),
                )),
          ),
          const SizedBox(
            height: 16,
          ),
          CustomButton(
            buttonText: 'Submit',
            isLoading: widget.isLoadingTaskMission!,
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
