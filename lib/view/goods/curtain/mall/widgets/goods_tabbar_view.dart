// /*
//  * @Description: 商品列表页面tabview封装
//  * @Author: iamsmiling
//  * @Date: 2020-10-10 11:03:22
//  * @LastEditTime: 2020-10-10 11:31:17
//  */
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:provider/provider.dart';
// import 'package:taojuwu/view/goods/curtain/widgets/curtain_list_view.dart';
// import 'package:taojuwu/viewmodel/mall/action_model.dart';

// class GoodsTabBarView extends StatefulWidget {
//   final bool isGridMode;

//   final TabController tabController;
//   const GoodsTabBarView(this.tabController, {Key key, this.isGridMode = true})
//       : super(key: key);

//   @override
//   _GoodsTabBarViewState createState() => _GoodsTabBarViewState();
// }

// class _GoodsTabBarViewState extends State<GoodsTabBarView>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return ChangeNotifierProvider<ActionModel>(
//       create: (BuildContext context) => ActionModel(widget.tabController),
//       builder: (BuildContext context, _) {
//         return widget.isGridMode ? _buildGridView() : _buildListView();
//       },
//     );
//   }

//   GridView _buildGridView() {}

//   ListView _buildListView() {
//     return ListView.builder(
//         // physics: NeverScrollableScrollPhysics(),
//         addAutomaticKeepAlives: false,
//         addRepaintBoundaries: false,
//         controller: scrollController,
//         shrinkWrap: true,
//         itemCount:
//             goodsList != null && goodsList.isNotEmpty ? goodsList?.length : 0,
//         itemBuilder: (BuildContext context, int i) {
//           return AnimationConfiguration.staggeredList(
//             position: i,
//             duration: Duration(milliseconds: 200),
//             child: SlideAnimation(
//                 verticalOffset: 200.0,
//                 child: FadeInAnimation(
//                   child: ListCard(goodsList[i]),
//                 )),
//           );
//         });
//   }

//   @override
//   bool get wantKeepAlive => true;
// }
