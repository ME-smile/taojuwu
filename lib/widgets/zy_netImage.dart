import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';
// import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';

class ZYNetImage extends StatelessWidget {
  final String imgPath;
  final bool isCache;
  final double width;
  final double height;
  final Function callback;
  final BoxFit fit;
  const ZYNetImage(
      {Key key,
      this.imgPath,
      this.isCache: true,
      this.height,
      this.width,
      this.callback,
      this.fit: BoxFit.fill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: ExtendedImage.network(
        UIKit.getNetworkImgPath(imgPath),
        cache: isCache,
        fit: fit,
        width: width,
        height: height,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              {
                return ZYAssetImage(
                  'goods_placeholder.png',
                  callback: callback,
                  width: width,
                  height: height,
                );
              }
            case LoadState.completed:
              {
                return FadeInImage(
                    width: width,
                    height: height,
                    placeholder: AssetImage(UIKit.getAssetsImagePath(
                      'goods_placeholder.png',
                    )),
                    image: ExtendedNetworkImageProvider(
                        UIKit.getNetworkImgPath(imgPath),
                        cache: true));
              }
            case LoadState.failed:
              {
                return ZYAssetImage(
                  'goods_placeholder.png',
                  callback: callback,
                  width: width,
                  height: height,
                );
              }
            default:
              {
                // return LoadingCircle();
                return ZYAssetImage(
                  'goods_placeholder.png',
                  callback: callback,
                  width: width,
                  height: height,
                );
              }
          }
        },
      ),
    );
  }
}
