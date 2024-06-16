import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/util/status.dart';

class ReferralApp extends StatelessWidget {
  const ReferralApp({
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
    return Referral(
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

class Referral extends StatefulWidget {
  const Referral({
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
  State<Referral> createState() => _ReferralState();
}

class _ReferralState extends State<Referral> {
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
                    name.length > 12
                        ? name.substring(0, 12) + "..."
                        : name ?? "",
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
                    Text(
                        widget.description.length > 12
                            ? widget.description.substring(0, 12) + "..."
                            : widget.description ?? "",
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
                readOnly:
                    !["NOT_SUBMITTED", "REJECTED"].contains(widget.status),
                controller: widget.additionalAttributeAnswerNotes,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                decoration: kTextInputDecoration.copyWith(
                  hintText: ["NOT_SUBMITTED", "REJECTED"].contains(status)
                      ? 'Your answer'
                      : widget.submittedAdditionalAttribute,
                  hintStyle: const TextStyle(color: greySecondaryColor),
                )),
          ),
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
