import 'package:bloodochallenge/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:bloodochallenge/comm/comHelper.dart';
import 'package:bloodochallenge/comm/genLoginSignupHeader.dart';
import 'package:bloodochallenge/comm/genTextFormField.dart';
import 'package:bloodochallenge/db/users.dart';
import 'package:bloodochallenge/model/model.dart';
import 'package:bloodochallenge/ecrane/register.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _formKey = new GlobalKey<FormState>();

  final _conUserName = TextEditingController();
  final _conPassword = TextEditingController();
  var dbHelper;

  @override
  void initState() {
    print("Hai te rog sa vad si eu un mesaj");
    super.initState();
    dbHelper = DbHelper();
  }

  login() async {
    String username = _conUserName.text;
    String passwd = _conPassword.text;

    if (username.isEmpty) {
      alertDialog(context, "Please Enter Username");
    } else if (passwd.isEmpty) {
      alertDialog(context, "Please Enter Password");
    } else {
      print("Usernameul este $username");
      print("Parola este $passwd");
      await dbHelper.getLoginUser(username, passwd).then((userData) {
        List<dynamic> objs = [userData, dbHelper];
        if (userData.punctaj != -1) {
          print("HAI SA NU EXAGERMWA $userData.punctaj");
          setSP(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => Home(),
                    settings: RouteSettings(arguments: objs)),
                (Route<dynamic> route) => false);
          });
        } else {
          print("Hai sa vad alerta");
          alertDialog(context, "Error: User Not Found");
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error: Login Fail");
      });
    }
  }

  Future setSP(UserModel user) async {
    final SharedPreferences sp = await _pref;
    sp.setString("user_name", user.user_name);
    sp.setString("password", user.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BlooDoChallenge'),
        backgroundColor: COLOR_CARMINE,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                genLoginSignupHeader('Login'),
                getTextFormField(
                    controller: _conUserName,
                    icon: Icons.person,
                    hintName: 'User'),
                SizedBox(height: 10.0),
                getTextFormField(
                  controller: _conPassword,
                  icon: Icons.lock,
                  hintName: 'Password',
                  isObscureText: true,
                ),
                Container(
                  margin: EdgeInsets.all(30.0),
                  width: double.infinity,
                  child: FlatButton(
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: login,
                  ),
                  decoration: BoxDecoration(
                    color: COLOR_CARMINE,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Does not have account? '),
                      FlatButton(
                        textColor: COLOR_CARMINE,
                        child: Text('Signup'),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => SignupForm()));
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
