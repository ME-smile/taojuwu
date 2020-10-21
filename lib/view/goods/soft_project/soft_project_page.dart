/*
 * @Description:软装方案页面
 * @Author: iamsmiling
 * @Date: 2020-10-10 14:07:14
 * @LastEditTime: 2020-10-16 15:30:36
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/repository/shop/soft_project_list_model.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/view/goods/soft_project/widgets/soft_project_card.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/base_goods_viewmodel.dart';
import 'package:taojuwu/widgets/loading.dart';

class SoftProjectPage extends StatefulWidget {
  final BaseGoodsViewModel model;
  final int goodsId;
  final int scenesId;
  const SoftProjectPage(this.model, this.goodsId, this.scenesId, {Key key})
      : super(key: key);

  @override
  _SoftProjectPageState createState() => _SoftProjectPageState();
}

class _SoftProjectPageState extends State<SoftProjectPage> {
  bool isLoading = true;
  List<SoftProjectBean> list;

  @override
  void initState() {
    OTPService.softProjectList(context,
            params: {'goods_id': widget.goodsId, 'scenes_id': widget.scenesId})
        .then((SoftProjectListResp response) {
          if (response?.valid == true) {
            list = response?.data?.list;
            print(list);
          }
        })
        .catchError((err) => err)
        .whenComplete(() {
          setState(() {
            isLoading = false;
          });
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('软装方案'),
        centerTitle: true,
      ),
      body: isLoading
          ? LoadingCircle()
          : ChangeNotifierProvider<BaseGoodsViewModel>.value(
              value: widget.model,
              builder: (BuildContext context, _) {
                return ListView.separated(
                  separatorBuilder: (BuildContext context, int i) {
                    return Divider(
                      thickness: 10,
                    );
                  },
                  itemBuilder: (BuildContext context, int i) {
                    return SoftProjectCard(list[i]);
                  },
                  itemCount: list.length,
                );
              },
            ),
    );
  }
}
