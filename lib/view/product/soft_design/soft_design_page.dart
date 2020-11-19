/*
 * @Description: 软装方案列表页面布局
 * @Author: iamsmiling
 * @Date: 2020-10-23 10:33:58
 * @LastEditTime: 2020-11-19 19:09:24
 */
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/design/soft_design_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/soft_project_list_model.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/view/product/soft_design/widgets/soft_design_product_card.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/network_error.dart';
import 'package:taojuwu/widgets/user_choose_button.dart';

class SoftDesignPage extends StatefulWidget {
  final int goodsId;
  const SoftDesignPage(this.goodsId, {Key key}) : super(key: key);

  @override
  _SoftDesignPageState createState() => _SoftDesignPageState();
}

class _SoftDesignPageState extends State<SoftDesignPage> {
  bool isLoading = true;
  bool hasError = false;
  List<SoftDesignProductDetailBean> list;
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future fetchData() {
    setState(() {
      hasError = false;
      isLoading = true;
    });
    return OTPService.softProjectList(context,
            params: {'goods_id': widget.goodsId})
        .then((SoftProjectListResp response) {
      if (response?.valid == true) {
        list = response?.data?.goodsList;
      }
    }).catchError((err) {
      hasError = true;
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
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
            : hasError
                ? Scaffold(
                    appBar: AppBar(),
                    body: Container(
                        height: double.maxFinite,
                        color: Theme.of(context).primaryColor,
                        child: NetworkErrorWidget(callback: fetchData)),
                  )
                : Scaffold(
                    backgroundColor: Theme.of(context).primaryColor,
                    appBar: AppBar(
                      title: Text('软装方案'),
                      centerTitle: true,
                      actions: [const UserChooseButton()],
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
                  ));
  }
}
