import 'package:flutter/material.dart';

class ContainerBox extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? padding;
  final double? width, height;

  const ContainerBox(
      {Key? key, this.padding, this.width, this.height, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            topLeft: Radius.circular(15),
            bottomRight: Radius.circular(15)),
        // border: Border.all(color: COLOR_GREY, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(
              3.0,
              3.0,
            ),
          ),
          BoxShadow(
            color: Colors.white,
            offset: const Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          )
        ],
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: child,
          )),
    );
  }
}
