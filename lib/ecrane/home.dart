import 'package:bloodochallenge/blood_icons.dart';
import 'package:bloodochallenge/widget_space.dart';
import 'package:flutter/material.dart';
import 'package:bloodochallenge/constants/text_theme.dart';
import 'package:bloodochallenge/constants/colors.dart';
import 'package:bloodochallenge/widgets/containerBox.dart';
import 'package:bloodochallenge/widgets/round.dart';
import 'package:intl/intl.dart';
import 'package:bloodochallenge/model/model.dart';
import 'package:bloodochallenge/model/model_istoric.dart';
import 'package:bloodochallenge/db/users.dart';
import 'package:bloodochallenge/ecrane/clasament.dart';
import 'package:bloodochallenge/ecrane/istoric_donari.dart';
import 'package:jiffy/jiffy.dart';
import 'package:bloodochallenge/comm/comHelper.dart';
// import 'donat.dart';

var points = 50;
var name = "Madalina";
// var clasament = 2005;
final date2 = DateTime.now();
final DateFormat formatter = DateFormat('yyyy-MM-dd');
var donations = [
  formatter.format(DateTime(2021, 10, 19)),
  formatter.format(DateTime(2022, 01, 12)),
  formatter.format(DateTime(2022, 04, 18))
];

// final difference = daysBetween(birthday, date2);

// ignore: must_be_immutable
class Home extends StatefulWidget {
  // String? username;
  List<dynamic>? objs;
  // final DbHelperIstoric? dbist= DbHelperIstoric();
  // UserModel? userdata = objs[0];
  // DbHelper? dbhelp;
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState(objs);
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  // String? name = "Madalina";
  // UserModel? userdata;
  List<dynamic>? objs;

  _HomeState(this.objs);
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int daysBetween(DateTime from, DateTime to) {
    if (from.compareTo(to) >= 0) {
      return 0;
    } else {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      return (to.difference(from).inHours / 24).round();
    }
  }

  // Future<int> clss(var objs) async {
  //   int sol;
  //   sol = await objs[1].Position(objs[0].punctaj);

  //   return sol;
  // }

  @override
  Widget build(BuildContext context) {
    final List<dynamic>? objs =
        ModalRoute.of(context)!.settings.arguments as List?;
    // objs![1].populate_db();
    // objs![1].populate_istoric();
    final username = objs![0]!.user_name;
    final pctj = objs[0]!.punctaj;
    int difference_s = 0, difference_t = 0;
    var future_blood = DateTime.now();
    var future_trombocite = DateTime.now();
    var cls;
    var istoric;
    // final last_donation_sange = objs[1].get_last_sange(objs[0]!.user_id);
    // print("Last donation sange asta este o prostie cred, $last_donation_sange");

    // if (last_donation_sange == DateTime(2030, 03, 03)) {
    //   difference_s = 0;
    // } else {
    //   DateTime aux = Jiffy(last_donation_sange).add(days: 30).dateTime;
    //   difference_s = daysBetween(aux, date2);
    // }
    // final last_donation_trombo = objs![1].get_last_sange(objs![0]!.user_id);
    // if (last_donation_trombo == DateTime(2030, 03, 03)) {
    //   difference_t = 0;
    // } else {
    //   var aux = Jiffy(last_donation_trombo).add(days: 20).dateTime;
    //   difference_t = daysBetween(aux, date2);
    // }
    // Future.delayed(Duration(milliseconds: 100));

    return FutureBuilder(
        // future: objs[1].Position(pctj),
        future: Future.wait(List<Future<dynamic>>.from([
          objs[1].Position(pctj),
          objs[1].get_last_sange(objs[0]!.user_id),
          objs[1].get_last_trombocite(objs[0]!.user_id),
          objs[1].clasament(),
          objs[1].getIstoricUser(objs[0]!.user_id)
        ])),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          print(snapshot);
          int? clasament;
          String? last_donation_blood;
          String? last_donation_trombocite;
          if (snapshot.hasData) {
            clasament = snapshot.data![0];
            last_donation_blood = snapshot.data![1];
            last_donation_trombocite = snapshot.data![2];
            cls = (snapshot.data![3] as List<Map<String, Object?>>);
            istoric = (snapshot.data![4] as List<IstoricModel>);
            if (last_donation_blood == "2030-03-03") {
              difference_s = 0;
            } else {
              // future_blood = DateTime.parse(last_donation_blood!)
              //     .add(const Duration(days: 30));
              // difference_s = daysBetween(future_blood, date2);
              if (future_blood.compareTo(date2) <= 0) {
                difference_s = 0;
                future_blood = date2;
              } else {
                difference_s = daysBetween(future_blood, date2);
              }
            }
            if (last_donation_trombocite == "2030-03-03") {
              print("Nu dormi vtm");
              difference_t = 0;
            } else {
              print("intri si aici ?");

              future_trombocite = DateTime.parse(last_donation_trombocite!)
                  .add(const Duration(days: 30));
              if (future_trombocite.compareTo(date2) <= 0) {
                difference_t = 0;
                future_trombocite = date2;
              } else {
                difference_t = daysBetween(future_trombocite, date2);
              }
            }
          } else {
            clasament = 200;
          }

          // final List<dynamic>? objs =
          //     ModalRoute.of(context)!.settings.arguments as List?;
          // final username = objs![0]!.user_name;
          //int clasament = await objs[1].Position(objs[0].punctaj);

          const TextStyle optionStyle =
              TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
          final Size size = MediaQuery.of(context).size;
          final ThemeData themeData = Theme.of(context);
          var newDate_s =
              new DateTime(date2.year, date2.month, date2.day + difference_s);
          final DateFormat formatter = DateFormat('yyyy-MM-dd');
          final String formatted_s = formatter.format(newDate_s);
          var newDate_t =
              new DateTime(date2.year, date2.month, date2.day + difference_t);
          final String formatted_t = formatter.format(newDate_t);
          // for (int ind = 0; ind < donations.length; ind++)
          //   print(donations[ind] + " ");

          List<Widget> _widgetOptions = <Widget>[
            Scaffold(
                body: Container(
              width: size.width,
              height: size.height,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8),
                      child: Text("Bine ai venit,\n$username",
                          style: themeData.textTheme.headline1),
                    ),
                    addVerticalSpace(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ContainerBox(
                          width: 120,
                          height: 70,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, top: 3, bottom: 2),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Clasament",
                                    style: themeData.textTheme.bodyText1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 70, top: 2),
                                child: Divider(
                                  height: 3,
                                  color: COLOR_CARMINE,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "$clasament",
                                    style: themeData.textTheme.headline1,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        addHorizontalSpace(15),
                        ContainerBox(
                          width: 120,
                          height: 70,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, top: 3, bottom: 2),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Puncte",
                                    style: themeData.textTheme.bodyText1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 70, top: 2),
                                child: Divider(
                                  height: 3,
                                  color: COLOR_CARMINE,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "$pctj",
                                    style: themeData.textTheme.headline1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    addVerticalSpace(20),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ContainerBox(
                        height: 200,
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Numaratoare inversa",
                                  style: themeData.textTheme.bodyText2),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, bottom: 10),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    "Numarul de zile pana cand poti dona din nou.",
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 120, 122, 124)))),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  round(
                                    width: 60,
                                    height: 60,
                                    child: Text(
                                      "$difference_s",
                                      style: themeData.textTheme.headline3,
                                    ),
                                  ),
                                  addVerticalSpace(5),
                                  Row(
                                    children: [
                                      Text(
                                          "              Sânge    \n" +
                                              "           ${formatter.format(future_blood)}        ",
                                          style: themeData.textTheme.headline5),
                                      // Text(
                                      //   "$formatted",
                                      //   style: themeData.textTheme.bodyText1,
                                      // )
                                    ],
                                  ),
                                ],
                              ),

                              //  addVerticalSpace(20),
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                      height: 120,
                                      child: VerticalDivider(
                                        color: COLOR_NAVY,
                                        thickness: 3,
                                        indent: 20,
                                        endIndent: 0,
                                        width: 10,
                                      ))),
                              Column(
                                children: [
                                  round(
                                    width: 60,
                                    height: 60,
                                    child: Text(
                                      "$difference_t",
                                      style: themeData.textTheme.headline3,
                                    ),
                                  ),
                                  addVerticalSpace(5),

                                  Text(
                                      "    Trombocite\n" +
                                          "     ${formatter.format(future_trombocite)}",
                                      style: themeData.textTheme.headline5),
                                  // Text(
                                  //   "$formatted",
                                  //   style: themeData.textTheme.bodyText1,
                                  // )
                                ],
                              ),
                            ],
                          ),
                        ]),
                      ),
                    )
                  ]),
            )),
            Scaffold(
                body: Container(
              width: size.width,
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: Text("Utilizeaza-ti\npunctele",
                        style: themeData.textTheme.headline1),
                  ),
                  addVerticalSpace(20),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: ContainerBox(
                      width: 50,
                      height: 80,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0, bottom: 3),
                            child: Text(
                              "Puncte disponibile",
                              style: themeData.textTheme.bodyText1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 40, right: 40, bottom: 5),
                            child: Divider(
                              height: 2,
                              color: COLOR_CARMINE,
                            ),
                          ),
                          Text(
                            "$pctj",
                            style: themeData.textTheme.headline1,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Inregistreaza donarea '),
                        FlatButton(
                          textColor: COLOR_CARMINE,
                          child: Text('Donare'),
                          onPressed: () {
                            // Navigator.push(
                            //     context, MaterialPageRoute(builder: (_) => Donat()));
                          },
                        )
                      ],
                    ),
                  ),
                  addVerticalSpace(60),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      'Viața e în sângele tău, dă mai departe!',
                      style: themeData.textTheme.headline6,
                    ),
                  ]),
                  addVerticalSpace(15),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      'Câștigă puncte și înaintează în clasament \nprin înregistrarea donării. Poți folosi \npunctele acumulate pentru a accesa\n ofertele partenerilor noștri',
                      style: themeData.textTheme.subtitle1,
                    ),
                  ])
                ],
              ),
            )),
            Scaffold(
              body: Container(
                width: size.width,
                height: size.height,
                child: Column(children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 40),
                        child: Image(
                          image: AssetImage('assets/images/profile.png'),
                          height: 200,
                          width: 200,
                        ),
                      ),
                      Text(
                        "$username",
                        style: themeData.textTheme.headline2,
                      )
                    ],
                  ),
                  addVerticalSpace(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Clasament",
                            style: themeData.textTheme.bodyText1,
                          ),
                          addVerticalSpace(10),
                          round(
                            height: 60,
                            width: 60,
                            child: Text(
                              "$clasament",
                              style: themeData.textTheme.headline3,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Column(
                            children: [
                              Text(
                                "Puncte",
                                style: themeData.textTheme.bodyText1,
                              ),
                              addVerticalSpace(10)
                            ],
                          ),
                          round(
                            height: 60,
                            width: 60,
                            child: Text(
                              "$pctj",
                              style: themeData.textTheme.headline3,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  addVerticalSpace(30),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 20, right: 20, bottom: 8),
                    child: Divider(
                      color: COLOR_BLUE,
                    ),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Clasament(),
                                settings: RouteSettings(arguments: cls)),
                          );
                        },
                        child: Text("Vezi clasamentul",
                            style: themeData.textTheme.headline4),
                      )),
                  addVerticalSpace(10),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 20, right: 20, bottom: 8),
                    child: Divider(
                      color: COLOR_BLUE,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8.0, left: 70, right: 8),
                        child: Icon(
                          Icons.restore,
                        ),
                      ),
                      // addHorizontalSpace(5),
                      TextButton(
                          onPressed: () {
                            if (istoric != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Istoric_donari(),
                                    settings:
                                        RouteSettings(arguments: istoric)),
                              );
                            } else {
                              alertDialog(context, "No donations found");
                            }
                            //   print("mergem la istoric");
                          },
                          child: Text(
                            "Istoricul donarilor",
                            style: themeData.textTheme.headline4,
                          ))
                    ],
                  ),
                ]), //TODO: clasament + ISTORIC DONARI?
              ),
            )
          ];

          return SafeArea(
            child: Scaffold(
              body: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  border: Border.all(color: COLOR_GREY, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: BottomNavigationBar(
                    currentIndex: _selectedIndex,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Acasa',
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Blood.droplet), label: 'Puncte'),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.list),
                        label: 'Mai mult',
                      ),
                    ],
                    selectedItemColor: COLOR_CARMINE,
                    onTap: (index) => setState(() => _selectedIndex = index),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
