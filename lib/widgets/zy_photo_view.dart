// import 'package:flutter/material.dart';

// class ZYPhotoView extends StatelessWidget {
//   final String imgUrl;
//   final double width;
//   const ZYPhotoView(this.imgUrl, {Key key, this.width: 120}) : super(key: key);

//   bool get isNetworkImg => imgUrl?.contains('http');

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => HeroPhotoView(
//                   imageProvider:
//                       isNetworkImg ? NetworkImage(imgUrl) : AssetImage(imgUrl)),
//             ),
//           );
//         },
//         child: Hero(
//             tag: 'X',
//             child: Container(
//               alignment: Alignment.centerLeft,
//               child: isNetworkImg
//                   ? Image.network(
//                       imgUrl,
//                       width: width,
//                     )
//                   : Image.asset(
//                       imgUrl,
//                       width: width,
//                     ),
//             )),
//       ),
//     );
//   }
// }

// class HeroPhotoView extends StatelessWidget {
//   const HeroPhotoView({
//     this.imageProvider,
//   });

//   final ImageProvider imageProvider;

//   @override
//   Widget build(BuildContext context) {
//     return Hero(
//         tag: 'X',
//         child: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Container(
//               constraints: BoxConstraints.expand(
//                 height: MediaQuery.of(context).size.height,
//               ),
//               child: Image(image: imageProvider)),
//         ));
//   }
// }
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ZYPhotoView extends StatelessWidget {
  final String imgUrl;
  final double width;
  final double height;
  final String tag;
  final BoxFit fit;
  const ZYPhotoView(this.imgUrl,
      {Key key,
      this.width: 120,
      this.height: 120,
      this.tag,
      this.fit: BoxFit.fill})
      : super(key: key);

  bool get isNetworkImg => imgUrl?.contains('http');

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ZYPhotoPreviewer(
                  heroTag: tag ?? imgUrl,
                  imageProvider:
                      isNetworkImg ? NetworkImage(imgUrl) : AssetImage(imgUrl)),
            ),
          );
        },
        child: Hero(
            tag: tag ?? imgUrl,
            child: Container(
              alignment: Alignment.centerLeft,
              child: isNetworkImg
                  ? Image.network(
                      imgUrl,
                      width: width,
                      fit: fit,
                      height: height,
                    )
                  : Image.asset(
                      imgUrl,
                      width: width,
                      height: height,
                      fit: fit,
                    ),
            )),
      ),
    );
  }
}

class ZYPhotoPreviewer extends StatelessWidget {
  final ImageProvider imageProvider;
  final Widget loadingWidget;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String heroTag;

  const ZYPhotoPreviewer(
      {Key key,
      this.backgroundDecoration,
      this.heroTag,
      this.imageProvider,
      this.loadingWidget,
      this.maxScale,
      this.minScale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 20,
                right: 10,
                left: 0,
                bottom: 20,
                child: PhotoView(
                  imageProvider: imageProvider,
                  loadingBuilder: (__, _) {
                    return loadingWidget;
                  },
                  backgroundDecoration: backgroundDecoration,
                  minScale: minScale,
                  maxScale: maxScale,
                  heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
                  enableRotation: false,
                )),
            Positioned(
                right: 10,
                top: MediaQuery.of(context).padding.top,
                child: IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })) //右上角关闭按钮
          ],
        ),
      ),
    );
  }
}
