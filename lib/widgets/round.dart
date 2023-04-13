import 'package:flutter/material.dart';
import 'package:bloodochallenge/constants/colors.dart';

class round extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? padding;
  final double? width, height;

  const round({Key? key, this.padding, this.width, this.height, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: COLOR_CARMINE,
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
      ),
      child: Center(child: child),
    );
  }
}
