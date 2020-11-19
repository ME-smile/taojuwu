// /*
//  * @Description: 商品列表页
//  * @Author: iamsmiling
//  * @Date: 2020-09-25 12:47:45
//  * @LastEditTime: 2020-10-10 11:29:46
//  */
// import 'package:flutter/material.dart';
// import 'package:taojuwu/viewmodel/mall/action_model.dart';
// import 'package:taojuwu/widgets/scan_button.dart';
// import 'package:taojuwu/widgets/zy_assetImage.dart';

// import 'mall/widgets/goods_tabbar_view.dart';
// import 'widgets/goods_filter_header.dart';

// class CurtainMallPage extends StatefulWidget {
//   final String keyword;
//   CurtainMallPage({Key key, this.keyword}) : super(key: key);

//   @override
//   _CurtainMallPageState createState() => _CurtainMallPageState();
// }

// class _CurtainMallPageState extends State<CurtainMallPage>
//     with SingleTickerProviderStateMixin {
//   List<String> tabs = ['窗帘', '床品', '抱枕', '沙发', '搭毯'];

//   TabController _tabController;

//   ActionModel actionModel;

//   bool isGridMode = true; //是否为网格列表模式

//   bool showFloatingButton = true; //是否显示floatingActionButton;

//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     _tabController = TabController(
//       initialIndex: 0,
//       length: tabs.length,
//       vsync: this,
//     )..addListener(() {});
//     actionModel = ActionModel(_tabController);
//     super.initState();
//   }

//   Widget _buildFilter1() {
//     return ZYAssetImage(
//       isGridMode ? 'ic_grid_h.png' : 'ic_grid.png',
//       width: 16,
//       height: 16,
//       callback: () {
//         if (isGridMode) return;
//         setState(() {
//           isGridMode = true;
//         });
//       },
//     );
//   }

//   Widget _buildFilter2() {
//     return ZYAssetImage(
//       isGridMode ? 'ic_list.png' : 'ic_list_h.png',
//       width: 16,
//       height: 16,
//       callback: () {
//         if (!isGridMode) return;
//         setState(() {
//           isGridMode = false;
//         });
//       },
//     );
//   }

//   Widget _buildFilter3() {
//     return Builder(
//       builder: (BuildContext ctx) {
//         return GestureDetector(
//           behavior: HitTestBehavior.deferToChild,
//           onTap: () {},
//           child: Container(
//             padding: EdgeInsets.only(right: 16),
//             child: Row(
//               children: <Widget>[
//                 Text(
//                   '默认排序',
//                   style: TextStyle(fontSize: 13),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 1, left: 5),
//                   child: ZYAssetImage(
//                     'dropdown@2x.png',
//                     width: 12,
//                     height: 12,
//                     callback: () {
//                       // sort(ctx);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFilter4() {
//     return GestureDetector(
//       // onTap: filter,
//       behavior: HitTestBehavior.translucent,
//       child: Container(
//         alignment: Alignment.center,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               '筛选',
//               style: TextStyle(fontSize: 13),
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: 5, top: 1),
//               child: ZYAssetImage(
//                 'filter@2x.png',
//                 width: 12,
//                 height: 12,
//                 // callback: filter,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   PreferredSize _buildAppBarBottom() {
//     return PreferredSize(
//         child: Column(
//           children: [
//             TabBar(
//                 tabs: tabs
//                     ?.map((e) => Container(
//                           height: 24,
//                           alignment: Alignment.center,
//                           child: Text(
//                             e,
//                             textAlign: TextAlign.center,
//                           ),
//                         ))
//                     ?.toList(),
//                 controller: _tabController,
//                 indicatorColor: Colors.transparent,
//                 labelPadding: EdgeInsets.all(0),
//                 labelColor: const Color(0xFF1B1B1B),
//                 unselectedLabelColor: const Color(0xFF6D6D6D),
//                 unselectedLabelStyle:
//                     TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                 labelStyle:
//                     TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
//             GoodsFilterHeader(
//               filter1: _buildFilter1(),
//               filter2: _buildFilter2(),
//               filter3: _buildFilter3(),
//               filter4: _buildFilter4(),
//             )
//           ],
//         ),
//         preferredSize: Size.fromHeight(60));
//   }

//   bool _onScroll(ScrollNotification notofication) {
//     if (notofication.depth == 0) {
//       return false;
//     }
//     if (notofication.runtimeType == ScrollStartNotification) {
//       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//         setState(() {
//           showFloatingButton = false;
//         });
//       });
//     }
//     if (notofication.runtimeType == ScrollEndNotification) {
//       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//         setState(() {
//           showFloatingButton = true;
//         });
//       });
//     }
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         actions: <Widget>[ScanButton()],
//         elevation: 0,
//         bottom: _buildAppBarBottom(),
//       ),
//       body: NotificationListener(
//         onNotification: _onScroll,
//         child: Scaffold(
//           key: _scaffoldKey,
//           body: TabBarView(
//             controller: _tabController,
//             children: tabs.map((e) => GoodsTabBarView(_tabController)).toList(),
//           ),
//           // endDrawer: endDrawer(context),
//         ),
//       ),
//     );
//   }
// }
