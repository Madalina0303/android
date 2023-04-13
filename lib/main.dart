import 'dart:ui';
import 'package:bloodochallenge/constants/colors.dart';
import 'package:bloodochallenge/constants/text_theme.dart';
import 'package:bloodochallenge/ecrane/home.dart';
import 'package:flutter/material.dart';
import 'package:bloodochallenge/ecrane/login2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    double width = window.physicalSize.width;

    return MaterialApp(
      title: 'BlooDoChallenge',
      theme: ThemeData(primaryColor: COLOR_CARMINE, textTheme: Text_Theme),
      home: LoginForm(),
      // home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
