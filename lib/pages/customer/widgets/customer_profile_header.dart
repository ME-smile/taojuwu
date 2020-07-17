import 'package:flutter/material.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class CustomerProfileHeader extends StatelessWidget {
  final String name;
  final int type;
  final int gender;
  final int age;
  final String address;
  const CustomerProfileHeader(
      {Key key,
      this.name: '',
      this.type,
      this.age,
      this.gender,
      this.address: ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      // padding: EdgeInsets.symmetric( horizontal: UIKit.width(20), vertical: UIKit.height(10)),
      child: Row(
        children: <Widget>[
          // CircleAvatar(
          //   radius: UIKit.sp(80),
          //   backgroundImage:
          //       AssetImage(UIKit.getAssetsImagePath('customer_avatar@2x.png')),
          // ),

          // SizedBox(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
            child: Image.asset(
              UIKit.getAssetsImagePath('customer_avatar@2x.png'),
              width: UIKit.width(120),
              height: UIKit.height(120),
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      right: 10,
                    ),
                    child: Text(
                      '${name ?? ""}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    Constants.CUSTOMER_TYPE_MAP[type],
                    style: textTheme.caption,
                  )
                ],
              ),
              Text(
                '${Constants.GENDER_MAP[gender]}  $age岁',
                style: textTheme.subtitle,
              ),
              address != null && address.isNotEmpty
                  ? Row(
                      children: <Widget>[
                        Icon(
                          Icons.add_location,
                          size: 16,
                        ),
                        Expanded(
                            child: Text('${address ?? ''}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    textTheme.caption.copyWith(fontSize: 13)))
                      ],
                    )
                  : SizedBox(),
            ],
          ))
        ],
      ),
    );
  }
}
