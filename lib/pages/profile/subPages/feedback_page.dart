import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class FeedbackPage extends StatefulWidget {
  FeedbackPage({Key key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController questionInput;
  TextEditingController telInput;
  

  @override
  void initState() {
    super.initState();
    questionInput =TextEditingController();
    telInput = TextEditingController();

  }
 
  @override
  void dispose() {
    super.dispose();
    questionInput?.dispose();
    telInput?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme =themeData.textTheme;
   return Scaffold(
     appBar: AppBar(
       title: Text('问题反馈'),
       centerTitle: true,
     ),
     body: Container(
       color: themeData.primaryColor,
       width: double.infinity,
       margin: EdgeInsets.only(top: UIKit.height(20)),
       padding: EdgeInsets.symmetric(horizontal: UIKit.width(20),vertical: UIKit.height(20)),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           Text('问题反馈',style: textTheme.title,),
           Container(
             height: UIKit.height(320),
             margin: EdgeInsets.symmetric(
               vertical: UIKit.height(20)
             ),
             padding: EdgeInsets.symmetric(
               horizontal: UIKit.width(20)
             ),
             decoration: BoxDecoration(
               border: Border.all(
                 color: themeData.dividerColor
               )
             ),
             child: TextField(
               controller: questionInput,
               maxLines: 99,
               decoration: InputDecoration(
                 hintText: '请描述您的问题和意见，感谢支持',
                 border: InputBorder.none,
                 
               ),
             ),
           ),
            Text('联系方式',style: textTheme.title,),
            Container(
              // alignment: Alignment.center,
             height: UIKit.height(80),
             margin: EdgeInsets.symmetric(
               vertical: UIKit.height(20)
             ),
             padding: EdgeInsets.symmetric(
               horizontal: UIKit.width(20)
             ),
             decoration: BoxDecoration(
               border: Border.all(
                 color: themeData.dividerColor
               )
             ),
             child: TextField(
               controller: questionInput,
               maxLines: 99,
               decoration: InputDecoration(
                 hintText: '请留下您的手机号、微信或者邮箱，以便我们联系您',
                 border: InputBorder.none,
                 
               ),
             ),
           ),
         ],
     ),
     
     ),
     bottomNavigationBar: Container(
       margin: EdgeInsets.symmetric(
         horizontal: UIKit.width(50),
         vertical: UIKit.height(50)
       ),
       padding:EdgeInsets.symmetric(
         vertical: UIKit.height(20)
       ),
       child: RaisedButton(onPressed: (){

       },child: Text('提交反馈',style: themeData.accentTextTheme.button,),),
     ),
   );
  }
}