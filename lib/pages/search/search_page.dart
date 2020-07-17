import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class SearchPage extends StatefulWidget {
  final int type; // 1 商品搜索 2 客户搜索 3 订单搜索
  SearchPage({Key key, this.type: 1}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const HINT_TEXT_MAP = {1: '搜索窗帘', 2: '搜索客户', 3: '搜索订单'};
  int type;
  List<String> history = [];
  UserProvider provider;
  TextEditingController inputController;
  @override
  void initState() {
    super.initState();
    type = widget.type;
    provider = Provider.of<UserProvider>(context, listen: false);
    inputController = TextEditingController();
    loadHistory();
  }

  void loadHistory() {
    switch (type) {
      case 1:
        {
          provider?.loadProductHistory();
          history = provider?.productHistory ?? [];
          break;
        }
      case 2:
        {
          provider?.loadClientHistory();
          history = provider?.clientHistory ?? [];
          break;
        }
      case 3:
        {
          provider?.loadOrderHistory();
          history = provider?.orderHistory ?? [];
          break;
        }
    }
  }

  void clearHistory() {
    switch (type) {
      case 1:
        {
          provider?.clearProductHistory();
          setState(() {});
          break;
        }
      case 2:
        {
          provider?.clearClientHistory();
          setState(() {});
          break;
        }
      case 3:
        {
          provider?.clearOrderHistory();
          setState(() {});
          break;
        }
    }
  }

  void jumpTo(String keyword) {
    switch (type) {
      case 1:
        {
          RouteHandler.goCurtainMallPage(context, keyword: keyword);
          break;
        }
      case 2:
        {
          RouteHandler.goCustomerSearchPage(context, keyword: keyword);
          break;
        }
      case 3:
        {
          RouteHandler.goOrderSearchPage(context, keyword: keyword);
        }
    }
  }

  void addHistory(text) {
    switch (type) {
      case 1:
        {
          provider?.addProductHistory(text);
          setState(() {});
          break;
        }
      case 2:
        {
          provider?.addClientHistory(text);
          setState(() {});
          break;
        }
      case 3:
        {
          provider?.addOrderHistory(text);
          setState(() {});
          break;
        }
    }
  }

  void showDelDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('删除搜索记录'),
              content: Text('你确定要清空搜索记录吗？'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('确定'),
                  onPressed: () {
                    clearHistory();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('删除搜索记录'),
              content: Text('你确定要清空搜索记录吗？'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('取消'),
                ),
                FlatButton(
                  onPressed: () {
                    clearHistory();
                    Navigator.of(context).pop();
                  },
                  child: Text('确定'),
                )
              ],
            );
          });
    }
  }

  @override
  void dispose() {
    super.dispose();
    inputController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: Container(
            margin: EdgeInsets.only(
                top: MediaQueryData.fromWindow(window).padding.top),
            padding: EdgeInsets.symmetric(
                horizontal: UIKit.width(15), vertical: UIKit.height(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 36,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: TextField(
                      controller: inputController,
                      // enableInteractiveSelection: false,
                      // textAlignVertical: TextAlignVertical(y: .5),
                      onSubmitted: (String text) {
                        if (text?.trim()?.isEmpty == true) {
                          return CommonKit.showInfo('请输入关键字');
                        }
                        addHistory(text);
                        jumpTo(text);
                      },

                      decoration: InputDecoration(
                          // fillColor: Colors.grey,

                          filled: true,
                          fillColor: Color(0xFFEDEFF1),
                          prefixIcon: Container(
                            child: Icon(
                              ZYIcon.search,
                              size: 18,
                              color: const Color(
                                0xFF979797,
                              ),
                            ),
                          ),
                          suffixIcon: InkWell(
                            child: Icon(
                              ZYIcon.clear,
                              color: const Color(0xFF979797),
                              size: 14,
                            ),
                            onTap: () {
                              inputController?.text = ' ';
                            },
                          ),
                          contentPadding: EdgeInsets.all(10),
                          hintText: HINT_TEXT_MAP[type]),
                    ),
                  ),
                )),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                      child: Text('取消')),
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(60)),
      body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: UIKit.width(15), vertical: UIKit.height(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('历史搜索'),
                  InkWell(
                      child: Icon(
                        ZYIcon.del,
                      ),
                      onTap: () {
                        showDelDialog();
                      })
                ],
              ),
              Wrap(
                children: List.generate(history?.length ?? 0, (int i) {
                  return InkWell(
                    onTap: () {
                      jumpTo(history[i] ?? '');
                    },
                    child: Container(
                      color: const Color(0xFFEDEFF1),
                      padding: EdgeInsets.symmetric(
                          horizontal: UIKit.width(30),
                          vertical: UIKit.height(10)),
                      margin: EdgeInsets.symmetric(
                          horizontal: UIKit.width(15),
                          vertical: UIKit.height(15)),
                      child: Text(history[i] ?? ''),
                    ),
                  );
                }),
              )
            ],
          )),
    );
  }
}
