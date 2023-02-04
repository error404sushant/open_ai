
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ai/features/key_change/key_change_bloc.dart';

class KeyChange extends StatefulWidget {
  const KeyChange({Key? key}) : super(key: key);

  @override
  State<KeyChange> createState() => _KeyChangeState();
}

class _KeyChangeState extends State<KeyChange> {
  //region Bloc
  late KeyChangeBloc keyChangeBloc;
  //endregion

  //region Init
  @override
  void initState() {
    keyChangeBloc = KeyChangeBloc(context: context);
    // TODO: implement initState
    super.initState();
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: keyChangeBloc.keyController.stream,
      builder: (context, snapshot) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            keyField(),
            SizedBox(height: 20),
            save(),
          ],
        );
      }
    );
  }


  //region Key field
Widget keyField(){
    return TextFormField(
      controller: keyChangeBloc.keyTextCtrl,
      maxLines: 4,
      maxLength:51,
      onChanged: (value){
        if(value.length==51){
           keyChangeBloc.isCorrectKey = true;
        }
        else{
          keyChangeBloc.isCorrectKey = false;
        }
        keyChangeBloc.keyController.sink.add(true);
      },
      //controller: homeBloc.searchTextCtrl,
      decoration: InputDecoration(
        hintText: "Enter key",
        filled: true,
        fillColor: Colors.blue.withOpacity(0.2),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)
        ),
      ),
      textCapitalization: TextCapitalization.sentences,
    );
}
//endregion

//region Apply
Widget save(){
    return CupertinoButton(
      onPressed: (){
        keyChangeBloc.onTapSave();
      },
      color: keyChangeBloc.isCorrectKey?Colors.green:Colors.red,
      child: Text("Save"),
    );
}
//endregion



}
