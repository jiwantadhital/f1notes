// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:f1notes/resources/extracted_widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:f1notes/resources/extracted_widgets/custom_text.dart';

class EmptyData extends StatelessWidget {
  bool hasRetry;
  void Function()? onTap;
  String text;
   EmptyData({
    Key? key,
    required this.text,
    this.hasRetry = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/no_data.png",scale: 2,),
          SizedBox(height: 10,),
          CustomText(text: text,fontSize: 18,weight: FontWeight.w400,),
          SizedBox(height: 15,),
          if(hasRetry == true)...[
            CustomButton(text: "Retry",onPress: onTap,)
          ]
        ],
      ),
    );
  }
}
