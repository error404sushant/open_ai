import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:open_ai/features/image_view/image_view.dart';
import 'package:open_ai/features/key_change/key_change.dart';
import 'package:open_ai/model/api_response_message.dart';
import 'package:open_ai/model/chats.dart';
import 'package:open_ai/model/open_ai_response.dart';
import 'package:open_ai/services/open_service.dart';

enum HomeState { Loading, Success, Failed, Empty, NoPermission }

class HomeBloc {
  //region Common variable
  final BuildContext homeContext;
  FlutterTts flutterTts = FlutterTts();
  late OpenAiServices openAiServices;
  late OpenAiResponse openAiResponse = OpenAiResponse();
  List<Chats> chatList = [];

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
  void init() {
    openAiServices = OpenAiServices();
  }

//endregion

  //region On tap send
  void onTapSend({required String message}) {
    //Add question to list
    chatList.add(Chats(text: message, url: "", messageByUser: true));

    ///Check is it a image search or not
    if (returnIsItImageSearch(text: message)) {
      //Api call
      openAiApiCall(data: message, isImage: true);
    } else {
      //Api call
      openAiApiCall(data: message, isImage: false);
    }
    //Close Keyboard
    FocusScope.of(homeContext).unfocus();

    //Refresh ui
    homeCtrl.sink.add(HomeState.Success);
    //Scroll down to the end of list
    scrollDown();
  }

  //endregion

  //region Open ai api call
  openAiApiCall({required String data, required bool isImage}) async {
    //region Try
    try {
      //If empty filed then clear
      searchTextCtrl.clear();
      openAiResponse = await openAiServices.getResults(value: data, isImageSearch: isImage);
      //Check is text empty
      if (openAiResponse.choices == null) {
        chatList.add(Chats(url: openAiResponse.data!.first.url!, text: "", messageByUser: false));
      } else {
        //Replace \n\n to empty string
        chatList.add(Chats(url: "", text: openAiResponse.choices!.first.text!.replaceAll("\n", ""), messageByUser: false));
        // Speak
        speak(data: openAiResponse.choices!.first.text!);
      }
      // chatList.addAll(openAiResponse.choices!);
      homeCtrl.sink.add(HomeState.Success);
      //Clear text field
      searchTextCtrl.clear();
      //Scroll down
    scrollDown();
    }
    //endregion
    on ApiErrorResponseMessage catch (error) {
      print(error.message);
      return;
    } catch (error) {
      print(error);
      return;
    }
  }

  //endregion

  //region On tap key
  onTapKey() {
    return showDialog(
        context: homeContext,
        builder: (_) => AlertDialog(
              // title: Text('Dialog Title'),
              content: KeyChange(),
            )).then((value) {});
  }

  //endregion

  //region Init flutter tts
  void speak({required String data}) async {
    flutterTts.stop();
    flutterTts.setPitch(1);
    flutterTts.speak(data);
    // Scroll down to the end of list
    if (scrollCtrl.hasClients) {
      scrollCtrl.animateTo(
        scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ); //Api call

    }
  }

//endregion

//region Return is it a image search or not
  bool returnIsItImageSearch({required String text}) {
    bool isImage = false;
    List<String> textSplit = text.toLowerCase().split(" ");
    if (textSplit.last.contains("image") || textSplit.last.contains("pic") || textSplit.last.contains("picture")) {
      isImage = true;
    } else {
      isImage = false;
    }
    return isImage;
  }

//endregion

//region Go to image view screen
  void goToImageViewScreen({required String imageUrl}) {
    var screen = ImageView(imageUrl:imageUrl,);
    // var screen = const MyOrdersScreen();
    var route = MaterialPageRoute(builder: (context) => screen);
    Navigator.push(homeContext, route);
  }
//endregion

//region Scroll all the way down
void scrollDown(){
  // Scrollable.ensureVisible(alignment: 1, duration: const Duration(milliseconds: 500),curve:Curves.ease );
  if (scrollCtrl.hasClients) {
    scrollCtrl.animateTo(
      scrollCtrl.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    ); //Api call

  }
}
//endregion

}
