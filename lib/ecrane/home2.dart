import 'package:flutter/material.dart';
import 'package:bloodochallenge/comm/comHelper.dart';
import 'package:bloodochallenge/comm/genLoginSignupHeader.dart';
import 'package:bloodochallenge/comm/genTextFormField.dart';
import 'package:bloodochallenge/db/users.dart';
import 'package:bloodochallenge/model/model.dart';
import 'package:bloodochallenge/ecrane/register.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloodochallenge/ecrane/login2.dart';

class HomeForm extends StatefulWidget {
  @override
  _HomeFormState createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  final _formKey = new GlobalKey<FormState>();
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  DbHelper? dbHelper;
  final _conUserId = TextEditingController();
  final _conDelUserId = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();

    dbHelper = DbHelper();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      // _conUserId.text = sp.getString("user_id");
      // _conDelUserId.text = sp.getString("user_id");
      _conUserName.text = sp.getString("user_name");
      // _conEmail.text = sp.getString("email");
      _conPassword.text = sp.getString("password");
    });
  }

  update() async {
    int uid = 0;
    String uname = _conUserName.text;
    String passwd = _conPassword.text;
    int punctaj = 0;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      UserModel user = UserModel(uid, uname, passwd, punctaj);
      await dbHelper!.updateUser(user).then((value) {
        if (value == 1) {
          alertDialog(context, "Successfully Updated");

          updateSP(user, true).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginForm()),
                (Route<dynamic> route) => false);
          });
        } else {
          alertDialog(context, "Error Update");
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error");
      });
    }
  }

  // delete() async {
  //   String delUserID = _conDelUserId.text;

  //   await dbHelper!.deleteUser(delUserID).then((value) {
  //     if (value == 1) {
  //       alertDialog(context, "Successfully Deleted");

  //       updateSP(null, false).whenComplete(() {
  //         Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(builder: (_) => LoginForm()),
  //             (Route<dynamic> route) => false);
  //       });
  //     }
  //   });
  // }

  Future updateSP(UserModel user, bool add) async {
    final SharedPreferences sp = await _pref;

    if (add) {
      sp.setString("user_name", user.user_name);
      sp.setString("password", user.password);
    } else {
      sp.remove('user_id');
      sp.remove('user_name');
      sp.remove('password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Update
                  getTextFormField(
                      controller: _conUserId,
                      isEnable: false,
                      icon: Icons.person,
                      hintName: 'User ID'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                      controller: _conUserName,
                      icon: Icons.person_outline,
                      inputType: TextInputType.name,
                      hintName: 'User Name'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                      controller: _conEmail,
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                      hintName: 'Email'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: _conPassword,
                    icon: Icons.lock,
                    hintName: 'Password',
                    isObscureText: true,
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    margin: EdgeInsets.all(30.0),
                    width: double.infinity,
                    child: FlatButton(
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: update,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),

                  // //Delete

                  // getTextFormField(
                  //     controller: _conDelUserId,
                  //     isEnable: false,
                  //     icon: Icons.person,
                  //     hintName: 'User ID'),
                  // SizedBox(height: 10.0),
                  // SizedBox(height: 10.0),
                  // Container(
                  //   margin: EdgeInsets.all(30.0),
                  //   width: double.infinity,
                  //   child: FlatButton(
                  //     child: Text(
                  //       'Delete',
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //     onPressed: delete,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Colors.blue,
                  //     borderRadius: BorderRadius.circular(30.0),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
