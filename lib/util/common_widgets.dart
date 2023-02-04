import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonWidgets{
  //region Extended image
  static Widget extendedImage(
      String imageUrl,
      BuildContext context,
      int cacheHeight,
      int cacheWidth, {
        bool cache = true,
        BoxFit fit = BoxFit.cover,
      }) {
    return ExtendedImage.network(
      imageUrl,
      width: double.infinity,
      height: double.infinity,
      cacheHeight: cacheHeight,
      cacheWidth: cacheWidth,
      fit: fit,
      retries: 5,
      timeRetry: const Duration(milliseconds: 100),
      cache: cache,
      clearMemoryCacheWhenDispose: true,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
          //_controller.reset();
            return const Icon(Icons.image);
            break;
          case LoadState.completed:
          // return Icon(Icons.flag);
            return ExtendedRawImage(
              image: state.extendedImageInfo?.image,
              fit: fit,
            );
            // TODO: Handle this case.
            break;
          case LoadState.failed:
            return const Icon(Icons.image_not_supported);
            // TODO: Handle this case.
            break;
        }
      },

      //border: Border.all(color: Colors.red, width: 1.0),
      //shape: BoxShape.rectangle,
      //borderRadius: BorderRadius.all(Radius.circular(30.0)),
      //cancelToken: cancellationToken,
    );
  }
//endregion

}