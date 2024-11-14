import 'package:flutter/material.dart';

class InkWellWithDelay extends StatelessWidget {
  final onTap;
  Widget child;
  double radius;
  int delay = 300;
  InkWellWithDelay(
      {required this.onTap,
      required this.child,
      this.radius = 16,
      this.delay = 300});
  void onTapWithDelay(Function onTapFunction) {
    Future.delayed(Duration(milliseconds: delay), () {
      onTapFunction(); // Call the onTap function after the delay
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(.5),
        highlightColor: Colors.grey.withOpacity(.5),
        borderRadius: BorderRadius.circular(radius),
        autofocus: true,
        onTap: () {
          onTapWithDelay(onTap);
        },
        child: child,
      ),
    );
  }
}