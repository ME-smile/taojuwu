/*
 * @Description: 型材详情弹窗视图
 * @Author: iamsmiling
 * @Date: 2020-12-28 11:24:20
 * @LastEditTime: 2020-12-28 15:39:26
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/repository/shop/product_detail/base/spec/product_spec_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/end_product/sectional_product_detail_bean.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class SectionalbarProductDetailModal extends StatefulWidget {
  final SectionalProductDetailBean bean;
  SectionalbarProductDetailModal(this.bean, {Key key}) : super(key: key);

  @override
  _SectionalbarProductDetailModalState createState() =>
      _SectionalbarProductDetailModalState();
}

class _SectionalbarProductDetailModalState
    extends State<SectionalbarProductDetailModal> {
  SectionalProductDetailBean get bean => widget.bean;
  TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: bean.width.toString());
    for (ProductSpecBean specBean in bean?.specList) {
      for (ProductSpecOptionBean optionBean in specBean?.options) {
        optionBean?.isSelected = false;
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 90,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ZYNetImage(
                    imgPath: bean?.mainImg,
                    needAnimation: false,
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(left: 12),
                child: SizedBox(
                  height: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 3.0),
                      //   child: Text(
                      //     '${bean?.goodsName}',
                      //     style: TaojuwuTextStyle.TITLE_TEXT_STYLE,
                      //   ),
                      // ),
                      Spacer(),
                      Text(
                        '¥${bean?.price}',
                        style: TaojuwuTextStyle.RED_TEXT_STYLE
                            .copyWith(fontSize: 14),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          '已选:' + bean?.selectedOptionsName ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: const Color(0xFF6D6D6D)),
                        ),
                      ),
                    ],
                  ),
                ),
              ))
            ],
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '米数',
              style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF333333),
                  fontWeight: FontWeight.w500),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 36,
              maxWidth: 128,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: TextField(
                // autofocus: true,
                controller: _controller,
                onChanged: (String text) {
                  setState(() {
                    bean.width = double.tryParse(text);
                  });
                },
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xFFEFF0F0))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xFFEFF0F0))),
                    contentPadding:
                        EdgeInsets.only(left: 10, top: 8, bottom: 8, right: 10),
                    hintText: "请输入型材米数"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
