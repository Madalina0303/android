import 'package:flutter/material.dart';
import 'package:bloodochallenge/constants/colors.dart';
import 'package:bloodochallenge/constants/text_theme.dart';
import 'package:bloodochallenge/model/model_istoric.dart';
import 'package:bloodochallenge/widgets/history_box.dart';

class Istoric_donari extends StatelessWidget {
  // const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    // var hard_map = {"Nume_1": 5, "Nume_2": 10, "Nume3": 15};
    var index = 0;
    final List<IstoricModel>? isto =
        ModalRoute.of(context)!.settings.arguments as List<IstoricModel>;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: COLOR_CARMINE,
          title: Text(
            "Istoricul donarilor",
            style: themeData.textTheme.headline3,
          ),
        ),
        body: ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: isto?.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10, left: 10, right: 10),
                child: HistoryBox(
                    height: 150,
                    centru: "${isto?[index].centru}",
                    data: "${isto?[index].data}",
                    tip: "${isto?[index].tip}",
                    brat: "${isto?[index].brat}"),
              );
            }));
  }
}
