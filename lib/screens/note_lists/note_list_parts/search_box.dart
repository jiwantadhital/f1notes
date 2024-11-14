import 'package:f1notes/resources/extracted_widgets/custom_text.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          const Icon(
            Icons.search,
            color: Colors.grey,
          ),
          const SizedBox(
            width: 10,
          ),
          CustomText(
              color: Colors.grey,
              text: "Search",
              )
        ],
      ),
    );
  }
}