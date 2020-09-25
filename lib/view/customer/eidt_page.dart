// /*
//  * @Description:
//  * @Author: iamsmiling
//  * @Date: 2020-09-25 12:15:12
//  * @LastEditTime: 2020-09-25 12:15:21
//  */
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:taojuwu/repository/user/customer_detail_model.dart';
// import 'package:taojuwu/view/customer/widgets/feature_info_segment.dart';

// import 'package:taojuwu/viewmodel/customer/edit_customer_viewmodel.dart';

// import 'widgets/base_info_segment.dart';

// class CustomerEditPage extends StatefulWidget {
//   final String title;
//   final int id;
//   CustomerEditPage({Key key, this.title: '编辑客户', this.id}) : super(key: key);

//   @override
//   _CustomerEditPageState createState() => _CustomerEditPageState();
// }

// class _CustomerEditPageState extends State<CustomerEditPage> {
//   final Map<String, String> params = {
//     'id': '',
//     'client_name': '',
//     'client_mobile': '',
//     'client_wx': '',
//     'client_sex': '',
//     'enter_time': '',
//     'style': '',
//     'goods_category_id': '',
//     'province_id': '',
//     'city_id': '',
//     'district_id': '',
//     'shop_id': '',
//     'client_age': '',
//     'detail_address': ''
//   };
//   CustomerDetailModel bean;
//   void initParams(CustomerDetailModel bean) {
//     params['id'] = '${bean?.id ?? ''}';
//     params['client_name'] = '${bean?.clientName ?? ''}';
//     params['client_sex'] = '${bean?.clientSex ?? '0'}';
//     params['client_mobile'] = '${bean?.clientMobile ?? ''}';
//     params['client_wx'] = '${bean?.clientWx ?? ''}';
//     params['enter_time'] = '${bean?.enterTime ?? ''}';
//     params['province_id'] = '${bean?.provinceId ?? ''}';
//     params['city_id'] = '${bean?.cityId ?? ''}';
//     params['district_id'] = '${bean?.districtId ?? ''}';
//     params['client_age'] = '${bean?.clientAge ?? ''}';
//     params['shop_id'] = '${bean?.shopId ?? ''}';
//     params['detail_address'] = '${bean?.detailAddress ?? ''}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (BuildContext context) =>
//           EditCustomerViewModel(context, widget.id),
//       child: Builder(builder: (BuildContext ctx) {
//         EditCustomerViewModel viewmodel = ctx.watch<EditCustomerViewModel>();
//         return Scaffold(
//           appBar: AppBar(
//             title: Text(widget.title),
//             centerTitle: true,
//             actions: <Widget>[
//               FlatButton(onPressed: viewmodel.addUser, child: Text('完成'))
//             ],
//           ),
//           body: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 // BaseInfoSegment(viewmodel),
//                 // FeatureInfoSegment(viewmodel),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
