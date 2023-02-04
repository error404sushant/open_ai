import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:open_ai/features/key_change/key_change.dart';
import 'package:open_ai/model/api_response_message.dart';
import 'package:open_ai/model/open_ai_response.dart';
import 'package:open_ai/services/open_service.dart';
import 'package:open_ai/util/app_constants.dart';
enum HomeState { Loading, Success, Failed, Empty, NoPermission }

class KeyChangeBloc{
  //region Common variable
  final BuildContext context;
  bool isCorrectKey = false;
  //endregion

//region Text Controller
final keyTextCtrl = TextEditingController();
//endregion
  //region Controller
  final keyController = StreamController<bool>.broadcast();
  //endregion
  //region Constructor
  KeyChangeBloc({required this.context});
  //endregion
//region Init
  void init(){
  }
//endregion

//region On tap save
void onTapSave(){
    Navigator.pop(context);
    print( AppConstants.token);
}
//endregion


//region




}