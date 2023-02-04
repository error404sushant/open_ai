import 'package:flutter/material.dart';
import 'package:open_ai/util/common_widgets.dart';

class ImageView extends StatefulWidget {
  final String imageUrl;
  const ImageView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body:body(),
    );
  }

  //region AppBar
  AppBar appBar() {
    return AppBar(
      title: const Text("AI Image"),

    );
  }

  //endregion


  //region Body
Widget body(){
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: InteractiveViewer(
        child: CommonWidgets.extendedImage(
          widget.imageUrl,
          context,
          500,
          500,
          fit: BoxFit.contain,
        ),
      ),
    );
}
//endregion

}
