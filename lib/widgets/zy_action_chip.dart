// import 'package:flutter/material.dart';
// import 'package:taojuwu/widgets/triangle_clipper.dart';

// class ZYActionChip extends StatefulWidget {
//   final ActionBean bean;
//   final Function callback;

//   ZYActionChip({
//     Key key,
//     this.bean,
//     this.callback,
//   }) : super(key: key);

//   @override
//   _ZYActionChipState createState() => _ZYActionChipState();
// }

// class _ZYActionChipState extends State<ZYActionChip> {
//   ActionBean get bean => widget.bean;
//   Function get callback => widget.callback;
//   bool get isChecked => bean.isChecked;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(2)),
//           border: Border.all(
//             width: .5,
//           )),
//       child: Stack(
//         children: <Widget>[
//           Positioned(
//               bottom: 0,
//               right: 0,
//               child: CustomPaint(
//                 size: Size(20, 20),
//                 painter: T=
//               ))
//         ],
//       ),
//     );
//     // return InkWell(
//     //   onTap: widget.callback,
//     //   child: Container(
//     //     alignment: Alignment.center,
//     //     decoration: BoxDecoration(
//     //         color: Colors.black,
//     //         // borderRadius: BorderRadius.all(Radius.circular(2)),
//     //         border: Border.all(
//     //             width: .5,
//     //             color: isChecked == true ? Colors.black : Color(0xFFCBCBCB))),
//     //     child: Container(
//     //       alignment: Alignment.center,
//     //       decoration: BoxDecoration(
//     //           color: Colors.white,
//     //           borderRadius: BorderRadius.only(
//     //               bottomRight: Radius.circular(isChecked ? 7.2 : 0))),
//     //       child: Text(
//     //         bean?.text ?? '',
//     //         textAlign: TextAlign.center,
//     //         overflow: TextOverflow.ellipsis,
//     //         style: TextStyle(
//     //             fontSize: 12,
//     //             color: isChecked == true ? Colors.black : Color(0xFF333333)),
//     //       ),
//     //     ),
//     //   ),
//     // );
//   }
// }

// class ActionBean {
//   String text;
//   bool isChecked;
//   ActionBean({this.isChecked, this.text});
//   ActionBean.fromJson(Map<String, dynamic> json) {
//     this.text = json['text'];
//     this.isChecked = json['is_checked'];
//   }
// }
