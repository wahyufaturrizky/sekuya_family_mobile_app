/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sekuya_family_mobile_app/api_key.dart';
import 'package:sekuya_family_mobile_app/components/answer_notes.dart';
import 'package:sekuya_family_mobile_app/components/button_click.dart';
import 'package:sekuya_family_mobile_app/components/components.dart';
import 'package:sekuya_family_mobile_app/components/placeholder_image_task.dart';
import 'package:sekuya_family_mobile_app/components/proof_with_photo.dart';
import 'package:sekuya_family_mobile_app/components/proof_with_photo_and_loc.dart';
import 'package:sekuya_family_mobile_app/components/quiz.dart';
import 'package:sekuya_family_mobile_app/components/referral.dart';
import 'package:sekuya_family_mobile_app/components/shimmer_loading.dart';
import 'package:sekuya_family_mobile_app/components/tab_mission/mission.dart';
import 'package:sekuya_family_mobile_app/config/application.dart';
import 'package:sekuya_family_mobile_app/constants.dart';
import 'package:sekuya_family_mobile_app/screens/private/lucky_winner_bottom_sheet.dart';
import 'package:sekuya_family_mobile_app/screens/private/profile_detail.dart';
import 'package:sekuya_family_mobile_app/service/mission/mission.dart';
import 'package:sekuya_family_mobile_app/util/format_date.dart';
import 'package:sekuya_family_mobile_app/util/launch_url.dart';

final dio = Dio();

class MissionDetailApp extends StatelessWidget {
  const MissionDetailApp({super.key, this.args});

  final MyArgumentsDataDetailMissionClass? args;

  @override
  Widget build(BuildContext context) {
    return MissionDetail(args: args);
  }
}

class MissionDetail extends StatefulWidget {
  const MissionDetail({super.key, this.args});

  final MyArgumentsDataDetailMissionClass? args;

  @override
  State<MissionDetail> createState() => _MissionDetailState();
}

class _MissionDetailState extends State<MissionDetail> {
  late String username;
  bool isLoadingTaskMission = false;
  bool isLoadingSubmitTaskMission = false;
  bool isLoadingMissionDetail = false;

  bool isLoadingPlayers = false;
  bool isLoadingLuckyWinners = false;

  bool refetchPlayers = false;
  bool refetchLuckyWinners = false;

  List<XFile>? _mediaFileList;
  dynamic _pickImageError;
  String? _retrieveDataError;
  var lat;
  var long;
  var nameLocation = '';
  var resMissionDetail;
  var resPlayers;
  var resLuckyWinners;

  var isLoadingNameLocation = false;
  var selectedChoice;

  static const pageSizePlayers = 5;
  static const pageSizeLuckyWinners = 5;

  var totalPagesPlayers;
  var currentPagePlayers = 0;
  int itemPerPagePlayers = 0;

  var totalPagesLuckyWinners;
  var currentPageLuckyWinners = 0;
  int itemPerPageLuckyWinners = 0;

  final additionalAttributeAnswerNotes = TextEditingController();
  final additionalAttributeAnswerMultipleChoice = TextEditingController();

  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  bool positionStreamStarted = false;

  @override
  void initState() {
    _toggleServiceStatusStream();
    getDataMissionDetail();

    getDataLuckyWinnersByMissionDetail();
    getDataPlayersByMissionDetail();

    super.initState();
  }

  void _toggleServiceStatusStream() {
    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        String serviceStatusValue;
        if (serviceStatus == ServiceStatus.enabled) {
          if (positionStreamStarted) {
            _toggleListening();
          }
          serviceStatusValue = 'enabled';
        } else {
          if (_positionStreamSubscription != null) {
            setState(() {
              _positionStreamSubscription?.cancel();
              _positionStreamSubscription = null;
              _updatePositionList(
                  _PositionItemType.log, 'Position Stream has been canceled');
            });
          }
          serviceStatusValue = 'disabled';
        }
        _updatePositionList(
          _PositionItemType.log,
          'Location service has been $serviceStatusValue',
        );
      });
    }
  }

  Future<dynamic> getDataLuckyWinnersByMissionDetail(
      {pageKey = 1, refetch = false}) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          if (refetch) {
            refetchLuckyWinners = true;
          } else {
            isLoadingLuckyWinners = true;
          }
        });
      }

      var queryParameters;

      queryParameters = {
        'page': pageKey.toString(),
        'limit': pageSizeLuckyWinners.toString(),
      };

      String id = widget.args?.resMission?["data"]?["data"]
          ?[widget.args?.indexResMission]?["_id"];

      var res =
          await handleGetDataLuckyWinnersByMissionDetail(id, queryParameters);

      if (res != null) {
        if (mounted) {
          if (res?["data"]?["meta"]?["totalPages"] > currentPageLuckyWinners) {
            var response = {
              ...res,
              "data": {
                ...res["data"],
                "data": [
                  ...resLuckyWinners?["data"]?["data"] ?? [],
                  ...res?["data"]?["data"],
                ]
              }
            };

            int tempItemPerPageState = res?["data"]?["data"]?.length;

            setState(() {
              resLuckyWinners = response;
              isLoadingLuckyWinners = false;
              refetchLuckyWinners = false;
              totalPagesLuckyWinners = res?["data"]?["meta"]?["totalPages"];
              currentPageLuckyWinners = res?["data"]?["meta"]?["page"];
              itemPerPageLuckyWinners =
                  itemPerPageLuckyWinners + tempItemPerPageState;
            });
          } else {
            setState(() {
              isLoadingLuckyWinners = false;
              refetchLuckyWinners = false;
            });
          }
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingLuckyWinners = false;
          refetchLuckyWinners = false;
        });
      }

      print('Error getDataLuckyWinnersByMissionDetail = $e');
    }
  }

  Future<dynamic> getDataPlayersByMissionDetail(
      {pageKey = 1, refetch = false}) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          if (refetch) {
            refetchPlayers = true;
          } else {
            isLoadingPlayers = true;
          }
        });
      }

      var queryParameters;

      queryParameters = {
        'page': pageKey.toString(),
        'limit': pageSizePlayers.toString(),
      };

      String id = widget.args?.resMission?["data"]?["data"]
          ?[widget.args?.indexResMission]?["_id"];

      var res = await handleGetDataPlayersByMissionDetail(id, queryParameters);

      if (res != null) {
        if (mounted) {
          if (res?["data"]?["meta"]?["totalPages"] > currentPagePlayers) {
            var response = {
              ...res,
              "data": {
                ...res["data"],
                "data": [
                  ...resPlayers?["data"]?["data"] ?? [],
                  ...res?["data"]?["data"],
                ]
              }
            };

            int tempItemPerPageState = res?["data"]?["data"]?.length;

            setState(() {
              resPlayers = response;
              isLoadingPlayers = false;
              refetchPlayers = false;
              totalPagesPlayers = res?["data"]?["meta"]?["totalPages"];
              currentPagePlayers = res?["data"]?["meta"]?["page"];
              itemPerPagePlayers = itemPerPagePlayers + tempItemPerPageState;
            });
          } else {
            setState(() {
              isLoadingPlayers = false;
              refetchPlayers = false;
            });
          }
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingPlayers = false;
          refetchPlayers = false;
        });
      }

      print('Error getDataLuckyWinnersByMissionDetail = $e');
    }
  }

  Future<dynamic> getDataMissionDetail({isFromSubmit = false}) async {
    if (!mounted) return;
    try {
      if (mounted) {
        setState(() {
          if (isFromSubmit) {
            isLoadingSubmitTaskMission = true;
          } else {
            isLoadingMissionDetail = true;
          }
        });
      }

      String id = widget.args?.resMission?["data"]?["data"]
          ?[widget.args?.indexResMission]?["_id"];

      var res = await handleGetDataMissionDetail(id);

      if (res != null) {
        if (mounted) {
          setState(() {
            resMissionDetail = res;
            isLoadingMissionDetail = false;
            isLoadingSubmitTaskMission = false;
          });
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoadingMissionDetail = false;
          isLoadingSubmitTaskMission = false;
        });
      }

      print('Error handleGetDataCommunitiesDetail = $e');
    }
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = _geolocatorPlatform.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) => _updatePositionList(
            _PositionItemType.position,
            position.toString(),
          ));
      _positionStreamSubscription?.pause();
    }

    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }

      String statusDisplayValue;
      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
        statusDisplayValue = 'resumed';
      } else {
        _positionStreamSubscription!.pause();
        statusDisplayValue = 'paused';
      }

      _updatePositionList(
        _PositionItemType.log,
        'Listening for position updates $statusDisplayValue',
      );
    });
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }

    additionalAttributeAnswerNotes.dispose();
    additionalAttributeAnswerMultipleChoice.dispose();

    super.dispose();
  }

  void _updatePositionList(_PositionItemType type, String displayValue) async {
    _positionItems.add(_PositionItem(type, displayValue));

    if (type != _PositionItemType.log) {
      RegExp regExp = RegExp(
          r'Latitude:\s*([-+]?[0-9]*\.?[0-9]+),\s*Longitude:\s*([-+]?[0-9]*\.?[0-9]+)');

      Match? match = regExp.firstMatch(displayValue);

      if (match != null) {
        double latitude = double.parse(match.group(1)!);
        double longitude = double.parse(match.group(2)!);

        print('Latitude: $latitude, Longitude: $longitude');

        final response = await dio.get(
            '$baseUrlMapGoogleApi/geocode/json?latlng=$latitude,$longitude&key=$apiKeyGoogleApi');

        final res = jsonDecode(response.toString());

        setState(() {
          lat = latitude;
          long = longitude;
          isLoadingNameLocation = false;
          nameLocation = res['results'][0]['formatted_address'];
        });
      } else {
        print('No match found');
      }

      print(displayValue);
      setState(() {});
    }
  }

  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  final TextEditingController limitController = TextEditingController();

  void handleBack() {
    final arguments = MyArgumentsDataClass(false, false, false, true);

    Application.router.navigateTo(context, "/privateScreens",
        transition: TransitionType.inFromLeft,
        routeSettings: RouteSettings(arguments: arguments));
  }

  Future<dynamic> handlePostTaskSubmission({taskId, taskCategoryKey}) async {
    try {
      setState(() {
        isLoadingSubmitTaskMission = true;
      });

      String idMission = widget.args?.resMission?["data"]?["data"]
          ?[widget.args?.indexResMission]?["_id"];

      var formData;

      switch (taskCategoryKey) {
        case "PROOF_WITH_PHOTO_AND_LOCATION":
          if (_mediaFileList == null ||
              _mediaFileList!.isEmpty ||
              lat == null ||
              long == null) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                backgroundColor: blackSolidPrimaryColor,
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Text('Warning!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        'Please provide the required photo, latitude, and longitude.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: greySecondaryColor)),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  CustomButton(
                    buttonText: 'OK',
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      setState(() {
                        isLoadingSubmitTaskMission = false;
                      });
                    },
                    labelSize: 12,
                    height: 36,
                    width: 120,
                  ),
                ],
              ),
            );
            break;
          }

          formData = FormData.fromMap({
            'taskId': taskId,
            'taskCategoryKey': taskCategoryKey,
            'additionalAttribute': '{"lat":$lat,"long":$long}',
            'imageProof': [
              await MultipartFile.fromFile(
                _mediaFileList![0].path.toString(),
                filename: _mediaFileList![0].path.split('/').last,
              )
            ],
          });
          break;
        case "PROOF_WITH_PHOTO":
          if (_mediaFileList == null || _mediaFileList!.isEmpty) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                backgroundColor: blackSolidPrimaryColor,
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Text('Warning!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Please provide the required photo.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: greySecondaryColor)),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  CustomButton(
                    buttonText: 'OK',
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      setState(() {
                        isLoadingSubmitTaskMission = false;
                      });
                    },
                    labelSize: 12,
                    height: 36,
                    width: 120,
                  ),
                ],
              ),
            );

            break;
          }

          formData = FormData.fromMap({
            'taskId': taskId,
            'taskCategoryKey': taskCategoryKey,
            'imageProof': [
              await MultipartFile.fromFile(
                _mediaFileList![0].path.toString(),
                filename: _mediaFileList![0].path.split('/').last,
              )
            ],
          });
          break;
        case "ANSWER_NOTES":
          if (additionalAttributeAnswerNotes.text.isEmpty) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                backgroundColor: blackSolidPrimaryColor,
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Text('Warning!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Please provide the answer notes.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: greySecondaryColor)),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  CustomButton(
                    buttonText: 'OK',
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      setState(() {
                        isLoadingSubmitTaskMission = false;
                      });
                    },
                    labelSize: 12,
                    height: 36,
                    width: 120,
                  ),
                ],
              ),
            );

            break;
          }

          formData = FormData.fromMap({
            'taskId': taskId,
            'taskCategoryKey': taskCategoryKey,
            'additionalAttribute': additionalAttributeAnswerNotes.text,
          });

          break;
        case "REFERRAL":
          if (additionalAttributeAnswerNotes.text.isEmpty) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                backgroundColor: blackSolidPrimaryColor,
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Text('Warning!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Please provide the answer notes.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: greySecondaryColor)),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  CustomButton(
                    buttonText: 'OK',
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      setState(() {
                        isLoadingSubmitTaskMission = false;
                      });
                    },
                    labelSize: 12,
                    height: 36,
                    width: 120,
                  ),
                ],
              ),
            );

            break;
          }

          formData = FormData.fromMap({
            'taskId': taskId,
            'taskCategoryKey': taskCategoryKey,
            'additionalAttribute': additionalAttributeAnswerNotes.text,
          });
          break;
        case "BUTTON_CLICK":
          formData = FormData.fromMap({
            'taskId': taskId,
            'taskCategoryKey': taskCategoryKey,
          });
          break;
        default:
          if (selectedChoice == null) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                backgroundColor: blackSolidPrimaryColor,
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Text('Warning!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Please provide the answer for the multiple choice.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: greySecondaryColor)),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  CustomButton(
                    buttonText: 'OK',
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      setState(() {
                        isLoadingSubmitTaskMission = false;
                      });
                    },
                    labelSize: 12,
                    height: 36,
                    width: 120,
                  ),
                ],
              ),
            );

            break;
          }

          formData = FormData.fromMap({
            'taskId': taskId,
            'taskCategoryKey': taskCategoryKey,
            'additionalAttribute': selectedChoice,
          });
          break;
      }

      if (formData != null) {
        var res = await handleTaskSubmission(formData, idMission);

        if (res != null) {
          getDataMissionDetail(isFromSubmit: true);

          setState(() {
            selectedChoice = '';
            additionalAttributeAnswerMultipleChoice.text = '';
            additionalAttributeAnswerNotes.text = '';
            _mediaFileList = null;
            lat = null;
            long = null;
          });

          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              backgroundColor: blackSolidPrimaryColor,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  const Text('Message!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                      res["statusCode"] == 400
                          ? res['message']
                          : '👋🏻 Success submit Task',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: greySecondaryColor)),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: <Widget>[
                CustomButton(
                  buttonText: 'OK',
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                  },
                  labelSize: 12,
                  height: 36,
                  width: 120,
                ),
              ],
            ),
          ).then((value) {});
        }
      }
    } catch (err) {
      setState(() {
        isLoadingSubmitTaskMission = false;
      });
      print('@handleTaskSubmission: $err');
    }
  }

  Future<void> _getCurrentPosition() async {
    setState(() {
      isLoadingNameLocation = true;
    });
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    _updatePositionList(
      _PositionItemType.position,
      position.toString(),
    );
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _updatePositionList(
        _PositionItemType.log,
        _kLocationServicesDisabledMessage,
      );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _updatePositionList(
          _PositionItemType.log,
          _kPermissionDeniedMessage,
        );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _updatePositionList(
        _PositionItemType.log,
        _kPermissionDeniedForeverMessage,
      );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _updatePositionList(
      _PositionItemType.log,
      _kPermissionGrantedMessage,
    );
    return true;
  }

  Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
  }) async {
    if (context.mounted) {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
        );
        setState(() {
          _setImageFileListFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _previewImages({imageProof = ''}) {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_mediaFileList != null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: FileImage(
              File(_mediaFileList![0].path),
            ),
          ),
          border: Border.all(
            color: greyColor,
            width: 2,
          ),
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return PlaceholderImageTaskApp(imageProof: imageProof);
      // You have not yet picked an image.
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _setImageFileListFromFile(response.file);
        } else {
          _mediaFileList = response.files;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    var dataMissionDetail = resMissionDetail?["data"]?["data"];
    var name = dataMissionDetail?["name"];
    var community = dataMissionDetail?["community"];
    var description = dataMissionDetail?["description"];
    var status = dataMissionDetail?["status"];
    var startDate = dataMissionDetail?["startDate"];
    var endDate = dataMissionDetail?["endDate"];
    var rewards = dataMissionDetail?["rewards"];
    var tasks = dataMissionDetail?["tasks"];
    var dataPlayers = resPlayers?["data"]?["data"];
    var dataLuckyWinners = resLuckyWinners?["data"]?["data"];

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                color: Colors.white,
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  handleBack();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              title: const Text(
                'Detail Mission',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            backgroundColor: Colors.black,
            body: Shimmer(
              linearGradient: shimmerGradient,
              child: SingleChildScrollView(
                  physics: isLoadingMissionDetail
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isLoadingMissionDetail)
                          MyWidgetShimmerApp(
                              isLoading: isLoadingMissionDetail,
                              child: const Card(
                                child: SizedBox(
                                  height: 20,
                                ),
                              )),
                        if (!isLoadingMissionDetail)
                          Text(
                            name.length > 20
                                ? name.substring(0, 20) + "..."
                                : name ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (isLoadingMissionDetail)
                          MyWidgetShimmerApp(
                              isLoading: isLoadingMissionDetail,
                              child: const Card(
                                child: SizedBox(
                                  height: 20,
                                ),
                              )),
                        if (!isLoadingMissionDetail)
                          Row(
                            children: [
                              if (community?["image"] != null)
                                Image.network(
                                  community?["image"],
                                  width: 32,
                                  height: 32,
                                ),
                              const SizedBox(
                                width: 8,
                              ),
                              if (community?["name"] != null)
                                Text(
                                  community?["name"].length > 10
                                      ? community["name"].substring(0, 10) +
                                          "..."
                                      : community?["name"] ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                            ],
                          ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (isLoadingMissionDetail)
                          MyWidgetShimmerApp(
                              isLoading: isLoadingMissionDetail,
                              child: const Card(
                                child: SizedBox(
                                  height: 20,
                                ),
                              )),
                        if (!isLoadingMissionDetail)
                          Text(
                            description ?? "-",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: greySecondaryColor),
                          ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            if (isLoadingMissionDetail)
                              if (isLoadingMissionDetail)
                                MyWidgetShimmerApp(
                                    isLoading: isLoadingMissionDetail,
                                    child: const Card(
                                      child: SizedBox(
                                        width: 100,
                                        height: 30,
                                      ),
                                    )),
                            if (!isLoadingMissionDetail)
                              Chip(
                                  label: Text(
                                    status ?? "",
                                  ),
                                  color: MaterialStateProperty.all<Color>(
                                      blueSecondaryColor),
                                  labelStyle: const TextStyle(
                                      color: blueSolidSecondaryColor),
                                  shape: const StadiumBorder(
                                      side: BorderSide(
                                          color: Colors.transparent))),
                            const SizedBox(
                              width: 16,
                            ),
                            if (isLoadingMissionDetail)
                              MyWidgetShimmerApp(
                                  isLoading: isLoadingMissionDetail,
                                  child: const Card(
                                    child: SizedBox(
                                      width: 100,
                                      height: 30,
                                    ),
                                  )),
                            if (!isLoadingMissionDetail)
                              Row(
                                children: [
                                  Text(
                                    '${handleFormatDate(startDate)} - ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    handleFormatDate(endDate),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Colors.white),
                                  ),
                                ],
                              )
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (isLoadingMissionDetail)
                          MyWidgetShimmerApp(
                              isLoading: isLoadingMissionDetail,
                              child: const Card(
                                child: SizedBox(
                                  width: 320,
                                  height: 60,
                                ),
                              )),
                        if (!isLoadingMissionDetail)
                          Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: yellowPrimaryColor.withOpacity(0.2),
                                  border: Border.all(
                                    color: yellowPrimaryColor,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              child: Column(
                                children: [
                                  const Text(
                                    'Mission will end on',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  if (endDate != null)
                                    CountDownText(
                                      due: DateTime.parse(endDate),
                                      finishedText: "Mission End",
                                      showLabel: true,
                                      longDateName: true,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                ],
                              )),
                        if (rewards != null && rewards.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Text(
                              'Rewards',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        if (isLoadingMissionDetail)
                          MyWidgetShimmerApp(
                              isLoading: isLoadingMissionDetail,
                              child: const Card(
                                child: SizedBox(
                                  height: 200,
                                ),
                              )),
                        if (rewards != null && rewards.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              children: (rewards as List<dynamic>)
                                  .map((itemReward) => Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                            color: blackPrimaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        child: Row(
                                          children: [
                                            if (itemReward["image"] != null)
                                              Image.network(
                                                itemReward["image"],
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${itemReward["maxQty"].toString()} Xp',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  LinearProgressIndicator(
                                                    value:
                                                        itemReward["maxQty"] *
                                                            0.01,
                                                    color: yellowPrimaryColor,
                                                    backgroundColor:
                                                        greyThirdColor,
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    itemReward["description"],
                                                    style: const TextStyle(
                                                        color:
                                                            greySecondaryColor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Chip(
                                                label: Text(
                                                  '${itemReward["maxQty"] / itemReward["maxQty"]}%',
                                                ),
                                                color: MaterialStateProperty
                                                    .all<Color>(
                                                        blackSolidPrimaryColor),
                                                labelStyle: const TextStyle(
                                                    color: yellowPrimaryColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    side: const BorderSide(
                                                        color: Colors
                                                            .transparent))),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        if (dataLuckyWinners != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Lucky Winner',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    String idMission = widget
                                            .args?.resMission?["data"]?["data"]
                                        ?[widget.args?.indexResMission]?["_id"];

                                    showModalBottomSheet(
                                        backgroundColor: Colors.black,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return LuckyWinnerBottomSheetApp(
                                              idMission: idMission);
                                        });
                                  },
                                  child: const Text(
                                    'See All',
                                    style: TextStyle(
                                        color: yellowPrimaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ))
                            ],
                          ),
                        if (dataLuckyWinners != null)
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                border: Border.all(color: blackPrimaryColor),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black),
                            child: Row(children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                          dataLuckyWinners[0]?["player"]
                                              ?["profilePic"]),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "${dataLuckyWinners[0]?["player"]?["email"].substring(0, 6)}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                  child: AvatarStack(
                                height: 24,
                                avatars: [
                                  for (var n = 0;
                                      n < dataLuckyWinners.length;
                                      n++)
                                    NetworkImage(dataLuckyWinners[n]?["player"]
                                        ?["profilePic"])
                                ],
                              ))
                            ]),
                          ),
                        const Text(
                          'Tasks',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (tasks != null)
                          Column(
                            children: (tasks as List<dynamic>).map((itemTask) {
                              return Column(
                                children: [
                                  if (itemTask["taskCategoryKey"] ==
                                      "PROOF_WITH_PHOTO_AND_LOCATION")
                                    ProofWithPhotoAndLocApp(
                                        image: itemTask["image"],
                                        reason: itemTask["reason"],
                                        isLoadingMissionDetail:
                                            isLoadingMissionDetail,
                                        submittedAdditionalAttribute: itemTask[
                                            "submittedAdditionalAttribute"],
                                        status: itemTask["status"],
                                        onExpansionChanged: () {
                                          setState(() {
                                            selectedChoice = null;
                                            _mediaFileList = null;
                                            lat = null;
                                            long = null;
                                            additionalAttributeAnswerNotes
                                                .text = "";
                                            additionalAttributeAnswerMultipleChoice
                                                .text = "";
                                          });
                                        },
                                        name: itemTask["name"],
                                        description: itemTask["description"],
                                        exp: itemTask["exp"],
                                        onTapTakeCamera: () {
                                          if (_picker.supportsImageSource(
                                                  ImageSource.camera) &&
                                              [
                                                "NOT_SUBMITTED",
                                                "REJECTED"
                                              ].contains(itemTask["status"])) {
                                            _onImageButtonPressed(
                                                ImageSource.camera,
                                                context: context);
                                          }
                                        },
                                        retrieveLostData: () async {
                                          await retrieveLostData();
                                        },
                                        previewImages: _previewImages(
                                          imageProof: [
                                            "NOT_SUBMITTED",
                                            "REJECTED"
                                          ].contains(itemTask["status"])
                                              ? ''
                                              : itemTask["imageProof"],
                                        ),
                                        onTapGetCurrentPosition: () {
                                          _getCurrentPosition();
                                        },
                                        isLoadingNameLocation:
                                            isLoadingNameLocation,
                                        nameLocation: nameLocation,
                                        isLoadingSubmitTaskMission:
                                            isLoadingSubmitTaskMission,
                                        onPressedSubmitTaskMission: () {
                                          if (!isLoadingSubmitTaskMission &&
                                              ([
                                                "NOT_SUBMITTED",
                                                "REJECTED"
                                              ].contains(itemTask["status"]))) {
                                            handlePostTaskSubmission(
                                              taskId: itemTask["id"],
                                              taskCategoryKey:
                                                  itemTask["taskCategoryKey"],
                                            );
                                          }
                                        }),
                                  if (itemTask["taskCategoryKey"] ==
                                      "PROOF_WITH_PHOTO")
                                    ProofWithPhotoApp(
                                        image: itemTask["image"],
                                        status: itemTask["status"],
                                        reason: itemTask["reason"],
                                        onExpansionChanged: () {
                                          setState(() {
                                            selectedChoice = null;
                                            _mediaFileList = null;
                                            lat = null;
                                            long = null;
                                            additionalAttributeAnswerNotes
                                                .text = "";
                                            additionalAttributeAnswerMultipleChoice
                                                .text = "";
                                          });
                                        },
                                        name: itemTask["name"],
                                        description: itemTask["description"],
                                        exp: itemTask["exp"],
                                        onTapTakeCamera: () {
                                          if (_picker.supportsImageSource(
                                                  ImageSource.camera) &&
                                              [
                                                "NOT_SUBMITTED",
                                                "REJECTED"
                                              ].contains(itemTask["status"])) {
                                            _onImageButtonPressed(
                                                ImageSource.camera,
                                                context: context);
                                          }
                                        },
                                        retrieveLostData: () async {
                                          await retrieveLostData();
                                        },
                                        previewImages: _previewImages(
                                            imageProof: [
                                          "NOT_SUBMITTED",
                                          "REJECTED"
                                        ].contains(itemTask["status"])
                                                ? ''
                                                : itemTask["imageProof"]),
                                        isLoadingSubmitTaskMission:
                                            isLoadingSubmitTaskMission,
                                        onPressedSubmitTaskMission: () {
                                          if (!isLoadingSubmitTaskMission &&
                                              ([
                                                "NOT_SUBMITTED",
                                                "REJECTED"
                                              ].contains(itemTask["status"]))) {
                                            handlePostTaskSubmission(
                                              taskId: itemTask["id"],
                                              taskCategoryKey:
                                                  itemTask["taskCategoryKey"],
                                            );
                                          }
                                        }),
                                  if (itemTask["taskCategoryKey"] ==
                                      "ANSWER_NOTES")
                                    AnswerNotesApp(
                                        image: itemTask["image"],
                                        submittedAdditionalAttribute: itemTask[
                                            "submittedAdditionalAttribute"],
                                        name: itemTask["name"],
                                        reason: itemTask["reason"],
                                        status: itemTask["status"],
                                        onExpansionChanged: () {
                                          setState(() {
                                            selectedChoice = null;
                                            _mediaFileList = null;
                                            lat = null;
                                            long = null;
                                            additionalAttributeAnswerNotes
                                                .text = "";
                                            additionalAttributeAnswerMultipleChoice
                                                .text = "";
                                          });
                                        },
                                        additionalAttributeAnswerNotes:
                                            additionalAttributeAnswerNotes,
                                        description: itemTask["description"],
                                        exp: itemTask["exp"],
                                        isLoadingSubmitTaskMission:
                                            isLoadingSubmitTaskMission,
                                        onPressedSubmitTaskMission: () {
                                          if (!isLoadingSubmitTaskMission &&
                                              ([
                                                "NOT_SUBMITTED",
                                                "REJECTED"
                                              ].contains(itemTask["status"]))) {
                                            handlePostTaskSubmission(
                                              taskId: itemTask["id"],
                                              taskCategoryKey:
                                                  itemTask["taskCategoryKey"],
                                            );
                                          }
                                        }),
                                  if (itemTask["taskCategoryKey"] == "REFERRAL")
                                    ReferralApp(
                                        image: itemTask["image"],
                                        name: itemTask["name"],
                                        submittedAdditionalAttribute: itemTask[
                                            "submittedAdditionalAttribute"],
                                        reason: itemTask["reason"],
                                        status: itemTask["status"],
                                        onExpansionChanged: () {
                                          setState(() {
                                            selectedChoice = null;
                                            _mediaFileList = null;
                                            lat = null;
                                            long = null;
                                            additionalAttributeAnswerNotes
                                                .text = "";
                                            additionalAttributeAnswerMultipleChoice
                                                .text = "";
                                          });
                                        },
                                        additionalAttributeAnswerNotes:
                                            additionalAttributeAnswerNotes,
                                        description: itemTask["description"],
                                        exp: itemTask["exp"],
                                        isLoadingSubmitTaskMission:
                                            isLoadingSubmitTaskMission,
                                        onPressedSubmitTaskMission: () {
                                          if (!isLoadingSubmitTaskMission &&
                                              ([
                                                "NOT_SUBMITTED",
                                                "REJECTED"
                                              ].contains(itemTask["status"]))) {
                                            handlePostTaskSubmission(
                                              taskId: itemTask["id"],
                                              taskCategoryKey:
                                                  itemTask["taskCategoryKey"],
                                            );
                                          }
                                        }),
                                  if (itemTask["taskCategoryKey"] == "QUIZ")
                                    QuizApp(
                                        image: itemTask["image"],
                                        name: itemTask["name"],
                                        submittedAdditionalAttribute: itemTask[
                                            "submittedAdditionalAttribute"],
                                        reason: itemTask["reason"],
                                        status: itemTask["status"],
                                        selectedChoice: selectedChoice,
                                        onChangedQuizChoice: (value) {
                                          setState(() {
                                            selectedChoice = value;
                                          });
                                        },
                                        description: itemTask["description"],
                                        additionalAttribute:
                                            itemTask["additionalAttribute"],
                                        exp: itemTask["exp"],
                                        onExpansionChanged: () {
                                          setState(() {
                                            selectedChoice = null;
                                            _mediaFileList = null;
                                            lat = null;
                                            long = null;
                                            additionalAttributeAnswerNotes
                                                .text = "";
                                            additionalAttributeAnswerMultipleChoice
                                                .text = "";
                                          });
                                        },
                                        retrieveLostData: () async {
                                          await retrieveLostData();
                                        },
                                        previewImages: _previewImages(),
                                        isLoadingSubmitTaskMission:
                                            isLoadingSubmitTaskMission,
                                        onPressedSubmitTaskMission: () {
                                          if (!isLoadingSubmitTaskMission &&
                                              ([
                                                "NOT_SUBMITTED",
                                                "REJECTED"
                                              ].contains(itemTask["status"]))) {
                                            handlePostTaskSubmission(
                                              taskId: itemTask["id"],
                                              taskCategoryKey:
                                                  itemTask["taskCategoryKey"],
                                            );
                                          }
                                        }),
                                  if (itemTask["taskCategoryKey"] ==
                                      "BUTTON_CLICK")
                                    ButtonClickApp(
                                        image: itemTask["image"],
                                        name: itemTask["name"],
                                        reason: itemTask["reason"],
                                        status: itemTask["status"],
                                        selectedChoice: selectedChoice,
                                        onChangedQuizChoice: (value) {
                                          setState(() {
                                            selectedChoice = value;
                                          });
                                        },
                                        description: itemTask["description"],
                                        additionalAttribute:
                                            itemTask["additionalAttribute"],
                                        exp: itemTask["exp"],
                                        onExpansionChanged: () {
                                          setState(() {
                                            selectedChoice = null;
                                            _mediaFileList = null;
                                            lat = null;
                                            long = null;
                                            additionalAttributeAnswerNotes
                                                .text = "";
                                            additionalAttributeAnswerMultipleChoice
                                                .text = "";
                                          });
                                        },
                                        retrieveLostData: () async {
                                          await retrieveLostData();
                                        },
                                        previewImages: _previewImages(),
                                        isLoadingSubmitTaskMission:
                                            isLoadingSubmitTaskMission,
                                        onPressedSubmitTaskMission: () {
                                          if (!isLoadingSubmitTaskMission &&
                                              ([
                                                "NOT_SUBMITTED",
                                                "REJECTED"
                                              ].contains(itemTask["status"]))) {
                                            handleLaunchUrl(
                                                context: context,
                                                val: itemTask?[
                                                        "additionalAttribute"]
                                                    ?["link"]);

                                            handlePostTaskSubmission(
                                              taskId: itemTask["id"],
                                              taskCategoryKey:
                                                  itemTask["taskCategoryKey"],
                                            );
                                          }
                                        }),
                                ],
                              );
                            }).toList(),
                          ),
                        if (dataPlayers != null)
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: const Text(
                              'Players',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        if (dataPlayers != null)
                          SizedBox(
                              height: 260,
                              child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 16,
                                          mainAxisExtent: 60,
                                          crossAxisSpacing: 16),
                                  itemCount: dataPlayers?.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                        color: blackPrimaryColor,
                                        child: InkWell(
                                            splashColor: yellowPrimaryColor
                                                .withAlpha(30),
                                            onTap: () {
                                              debugPrint('Card tapped.');
                                            },
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            greySecondaryColor,
                                                        width: 1),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                                child: Row(
                                                  children: [
                                                    Center(
                                                        child: CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      backgroundImage: dataPlayers?[
                                                                      index]?[
                                                                  "profilePic"] !=
                                                              null
                                                          ? NetworkImage(
                                                              dataPlayers?[
                                                                      index]?[
                                                                  "profilePic"])
                                                          : null,
                                                    )),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    if (dataPlayers?[index]
                                                                ?["username"] !=
                                                            null ||
                                                        dataPlayers?[index]
                                                                ?["email"] !=
                                                            null)
                                                      Text(
                                                        dataPlayers?[index]?[
                                                                    "username"] ==
                                                                ''
                                                            ? dataPlayers?[
                                                                        index]
                                                                    ?["email"]
                                                                .substring(
                                                                    0, 10)
                                                            : dataPlayers?[
                                                                    index]
                                                                ?["username"],
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                  ],
                                                ))));
                                  })),
                      ],
                    ),
                    // This is the title in the app bar.
                  )),
            )));
  }
}

String getAvatarUrl(int n) {
  final url = 'https://i.pravatar.cc/150?img=$n';
  // final url = 'https://robohash.org/$n?bgset=bg1';
  return url;
}

enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality, int? limit);
