import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:open_ai/model/api_response_message.dart';
import 'package:open_ai/model/open_ai_response.dart';
import 'package:open_ai/services/open_service.dart';
enum HomeState { Loading, Success, Failed, Empty, NoPermission }

class HomeBloc{
  //region Common variable
  final BuildContext homeContext;
  FlutterTts flutterTts = FlutterTts();
  late OpenAiServices openAiServices;
  late OpenAiResponse openAiResponse;
  List<Choices> openAiDataList = [];
  //endregion

//region Text Editing Controller
final searchTextCtrl = TextEditingController();
//endregion

//region Controller
  final homeCtrl = StreamController<HomeState>.broadcast();
  final scrollCtrl = ScrollController();
//endregion
  //region Constructor
  HomeBloc({required this.homeContext});
  //endregion
//region Init
void init(){
  openAiServices = OpenAiServices();
}
//endregion


  //region On tap send
  void  onTapSend({required String message}){
  //Add question to list
  openAiDataList.add(Choices(text: message, messageByUser: true,));
  print(openAiDataList.last.messageByUser);
  //Close Keyboard
  // FocusScope.of(context).unfocus();
  FocusScope.of(homeContext).unfocus();

  //Refresh ui
  homeCtrl.sink.add(HomeState.Success);
  //Scroll down to the end of list
  if(scrollCtrl.hasClients){
    scrollCtrl.animateTo(scrollCtrl.position.maxScrollExtent,duration: const Duration(milliseconds: 300),curve: Curves.easeOut,);//Api call

  }
  //Api call
  openAiApiCall(data: message);
  }
  //endregion

  //region Open ai api call
  openAiApiCall({required String data})async{

    try{
      //If empty filed then clear
      searchTextCtrl.clear();
      openAiResponse = await openAiServices.getResults(value: data);
      //Replace \n\n to empty string
      openAiResponse.choices!.first.text!=openAiResponse.choices!.first.text!.replaceAll("\n","");
      //Add false
      for(var data in openAiResponse.choices!){
        data.messageByUser = false;
      }
      openAiDataList.addAll(openAiResponse.choices!);
      homeCtrl.sink.add(HomeState.Success);
      //Speak
      speak(data: openAiResponse.choices!.first.text!);
      //Clear text field
      searchTextCtrl.clear();
    }
    on ApiErrorResponseMessage catch(error){
      print(error.message);
      return;
    }
    catch(error){
      print(error);
      return;
    }


  }
  //endregion

  //region Init flutter tts
void speak({required String data})async{
  flutterTts.stop();
  flutterTts.setPitch(1);
  flutterTts.speak(data);
  // Scroll down to the end of list
  if(scrollCtrl.hasClients){
    scrollCtrl.animateTo(scrollCtrl.position.maxScrollExtent,duration: const Duration(milliseconds: 300),curve: Curves.easeOut,);//Api call

  }
}
//endregion

}