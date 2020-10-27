/*
 * @Description: 软装方案列表页面布局
 * @Author: iamsmiling
 * @Date: 2020-10-23 10:33:58
 * @LastEditTime: 2020-10-23 11:02:49
 */
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/repository/shop/product/design/soft_design_product_bean.dart';
import 'package:taojuwu/repository/shop/soft_project_list_model.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/view/product/soft_design/widgets/soft_design_product_card.dart';
import 'package:taojuwu/viewmodel/product/base/provider/base_product_provider.dart';
import 'package:taojuwu/widgets/loading.dart';

class SoftDesignPage extends StatefulWidget {
  final BaseProductProvider provider;
  final int goodsId;
  final int scenesId;
  const SoftDesignPage(this.provider, this.goodsId, this.scenesId, {Key key})
      : super(key: key);

  @override
  _SoftDesignPageState createState() => _SoftDesignPageState();
}

class _SoftDesignPageState extends State<SoftDesignPage> {
  bool isLoading = true;
  List<SoftDesignProductBean> list;
  @override
  void initState() {
    OTPService.softProjectList(context,
            params: {'goods_id': 961, 'scenes_id': widget.scenesId})
        .then((SoftProjectListResp response) {
          if (response?.valid == true) {
            list = response?.data?.goodsList;
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
    return PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: isLoading
            ? LoadingCircle()
            : ChangeNotifierProvider<BaseProductProvider>.value(
                value: widget.provider,
                builder: (BuildContext context, _) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('软装方案'),
                      centerTitle: true,
                    ),
                    body: ListView.separated(
                      separatorBuilder: (BuildContext context, int i) {
                        return Divider(
                          thickness: 10,
                        );
                      },
                      itemBuilder: (BuildContext context, int i) {
                        return SoftDesignProductCard(list[i]);
                      },
                      itemCount: list.length,
                    ),
                  );
                },
              ));
  }
}
