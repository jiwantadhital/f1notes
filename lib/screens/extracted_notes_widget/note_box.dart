import 'package:f1notes/resources/extracted_widgets/custom_text.dart';
import 'package:flutter/material.dart';

class NoteBoxWidget extends StatelessWidget {
  String title;
  String desc;
  String addedDate;
  String dueDate;
  NoteBoxWidget({
    Key? key,
    required this.title,
    required this.desc,
    required this.addedDate,
    required this.dueDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: title,weight: FontWeight.w600,fontSize: 15,),
        SizedBox(height: 5,),
        CustomText(text: desc,weight: FontWeight.w300,fontSize: 14,),
        SizedBox(height: 15,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        Row(
          children: [
            CustomText(text: "Added At: ",fontSize: 11,),
            CustomText(text: addedDate,fontSize: 11,weight: FontWeight.w600,),
          ],
        ),
        Row(
          children: [
            CustomText(text: "Due At: ",fontSize: 11,),
            CustomText(text: dueDate,fontSize: 11,weight: FontWeight.w600,),
          ],
        ),
          ],
        )
      ],
    );
  }
}