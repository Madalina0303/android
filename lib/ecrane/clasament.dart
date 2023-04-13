import 'package:flutter/material.dart';
import 'package:bloodochallenge/constants/colors.dart';
import 'package:bloodochallenge/constants/text_theme.dart';

class Clasament extends StatelessWidget {
  // const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    // var hard_map = {"Nume_1": 5, "Nume_2": 10, "Nume3": 15};
    // var list1 = ["nume1", "nume2", "nume3"];
    // var list2 = [1, 2, 3];
    var index = 0;
    final List<Map<String, Object?>>? objs = ModalRoute.of(context)!
        .settings
        .arguments as List<Map<String, Object?>>;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: COLOR_CARMINE,
          title: Text(
            "Clasament",
            style: themeData.textTheme.headline3,
          ),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 10, left: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "# Nume",
                    style: themeData.textTheme.headline5,
                  ),
                  Text("Punctaj", style: themeData.textTheme.headline5)
                ]),
          ),
          // ignore: prefer_const_constructors
          Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Divider(color: COLOR_NAVY)),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: objs?.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: (index % 2 == 0) ? COLOR_WHITE : COLOR_GREY,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${index + 1}   ${objs?[index]['user_name'] as String}",
                          style: themeData.textTheme.subtitle2,
                        ),
                        Text(
                          "${objs?[index]['punctaj'] as int}",
                          style: themeData.textTheme.subtitle2,
                        )
                      ],
                    ),
                  );
                }),
          ),
        ]));
  }
}
