import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:taojuwu/utils/ui_kit.dart';

import 'loading.dart';

class PhotoGallery extends StatefulWidget {
  final List<String> imgList;
  final int index;
  final String heroTag;
  final PageController controller;
  PhotoGallery(
      {Key key, this.imgList, this.index, this.heroTag, this.controller})
      : super(key: key);

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  int currentIndex = 0;
  List<String> get imgList => widget.imgList;
  int get index => widget.index;
  PageController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Container(
                child: PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    itemCount: imgList.length ?? 0,
                    pageController: controller,
                    enableRotation: false,
                    onPageChanged: (int index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    loadingBuilder: (BuildContext context, _) =>
                        LoadingCircle(),
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(
                            UIKit.getNetworkImgPath(imgList[index])),
                        heroAttributes: widget.heroTag.isNotEmpty
                            ? PhotoViewHeroAttributes(tag: widget.heroTag)
                            : null,
                      );
                    }),
              )),
          Positioned(
              top: MediaQuery.of(context).padding.top + 15,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  '${currentIndex + 1}/${imgList?.length ?? 0}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
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
                },
              ))
        ],
      ),
    );
  }
}
