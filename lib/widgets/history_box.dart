import 'package:bloodochallenge/widget_space.dart';
import 'package:flutter/material.dart';

class HistoryBox extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? padding;
  final double? width, height;
  final String? centru;
  final String? tip;
  final String? data;
  final String? brat;

  const HistoryBox(
      {Key? key,
      this.padding,
      this.width,
      this.height,
      this.child,
      this.centru,
      this.tip,
      this.data,
      this.brat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
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
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Image(
                  image: AssetImage('assets/images/bloody.png'),
                  height: 70,
                  width: 70,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 15, bottom: 5),
                child: Column(
                  children: [
                    addVerticalSpace(10),
                    Text(
                      "$centru",
                      style: themeData.textTheme.subtitle2,
                    ),
                    addVerticalSpace(10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Data:               ",
                            style: themeData.textTheme.headline5,
                          ),
                          Text(
                            "$data",
                            style: themeData.textTheme.subtitle2,
                          )
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tipul donarii:         ",
                            style: themeData.textTheme.headline5,
                          ),
                          Text(
                            "$tip",
                            style: themeData.textTheme.subtitle2,
                          )
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Brat:                         ",
                            style: themeData.textTheme.headline5,
                          ),
                          Text(
                            "$brat",
                            style: themeData.textTheme.subtitle2,
                          )
                        ])
                  ],
                ),
              )
            ],
          )),
    );
  }
}
