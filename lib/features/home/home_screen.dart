import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      onTap: (){
        //Close Keyboard
        // FocusScope.of(context).unfocus();
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(child: body()),
      ),
    );
  }


  //region Body
Widget body(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: speak()),
        questionField(),

      ],
    );
}
//endregion

//region Speak
Widget speak(){
    return StreamBuilder<HomeState>(
      stream: homeBloc.homeCtrl.stream,
      initialData:HomeState.Loading ,
      builder: (context, snapshot) {
        if(snapshot.data == HomeState.Success){
          return ListView.builder(
            shrinkWrap: true,
              controller: homeBloc.scrollCtrl,
              padding: EdgeInsets.zero,
              itemCount: homeBloc.openAiDataList.length,
              itemBuilder:(context,index){
                return Align(
                  alignment: homeBloc.openAiDataList[index].messageByUser?Alignment.centerRight:Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: homeBloc.openAiDataList[index].messageByUser?Colors.red:Colors.green),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    child: Text(homeBloc.openAiDataList[index].text!.replaceAll("\n", "")),
                  ),
                );
              });
        }
        return SizedBox();
      }
    );
}
//endregion

//region Message field
Widget questionField(){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: homeBloc.searchTextCtrl,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.blue.withOpacity(0.2),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50)
                ),
              ),
            ),
          ),
          CupertinoButton(child:Icon(Icons.send), onPressed:(){
            homeBloc.onTapSend(message: homeBloc.searchTextCtrl.text);
          })
        ],
      ),
    );
}
//endregion




}
