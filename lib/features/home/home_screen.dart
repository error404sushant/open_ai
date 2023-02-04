import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ai/util/common_widgets.dart';

import 'home_bloc.dart';

//region Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
//endregion

class _HomeScreenState extends State<HomeScreen> {
  //region Build
  late HomeBloc homeBloc;

  //endregion
  //region Init
  @override
  void initState() {
    homeBloc = HomeBloc(homeContext: context);
    homeBloc.init();
    super.initState();
  }

  //endregion
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Close Keyboard
        // FocusScope.of(context).unfocus();
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: appBar(),
        body: SafeArea(child: body()),
      ),
    );
  }

  //region AppBar
  AppBar appBar() {
    return AppBar(
      title: Text("Open AI"),
      actions: [
        CupertinoButton(
            child: Icon(
              Icons.key,
              color: Colors.white,
            ),
            onPressed: () {
              homeBloc.onTapKey();
            }),
      ],
    );
  }

  //endregion

  //region Body
  Widget body() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: SingleChildScrollView(
            controller: homeBloc.scrollCtrl,
            child: chat())),
        questionField(),
      ],
    );
  }

//endregion

//region Chat
  Widget chat() {
    return StreamBuilder<HomeState>(
        stream: homeBloc.homeCtrl.stream,
        initialData: HomeState.Loading,
        builder: (context, snapshot) {
          if (snapshot.data == HomeState.Success) {
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                // controller: homeBloc.scrollCtrl,
                padding: EdgeInsets.zero,
                itemCount: homeBloc.chatList.length,
                itemBuilder: (context, index) {
                  //If it is a text message
                  if (homeBloc.chatList[index].text.isNotEmpty) {
                    return Align(
                      alignment: homeBloc.chatList[index].messageByUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: homeBloc.chatList[index].messageByUser ? Colors.red : Colors.green),
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        child: Text(homeBloc.chatList[index].text.replaceAll("\n", "")),
                      ),
                    );
                  } else {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(20)),
                        margin: const EdgeInsets.all(10),
                        child: SizedBox(
                            height: 100,
                            width: 100,
                            child: InkWell(
                              onTap: (){
                                homeBloc.goToImageViewScreen(imageUrl: homeBloc.chatList[index].url);
                              },
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CommonWidgets.extendedImage(
                                    homeBloc.chatList[index].url,
                                    context,
                                    200,
                                    200,
                                    fit: BoxFit.fill,
                                  )),
                            )),
                      ),
                    );
                  }
                });
          }
          return SizedBox();
        });
  }

//endregion

//region Message field
  Widget questionField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: homeBloc.searchTextCtrl,
              decoration: InputDecoration(
                hintText: "Ask anything",
                filled: true,
                fillColor: Colors.blue.withOpacity(0.2),
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(50)),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          CupertinoButton(
              child: Icon(Icons.send),
              onPressed: () {
                homeBloc.onTapSend(message: homeBloc.searchTextCtrl.text);
              })
        ],
      ),
    );
  }
//endregion

}
