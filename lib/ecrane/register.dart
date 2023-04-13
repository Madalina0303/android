import 'package:bloodochallenge/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:bloodochallenge/comm/comHelper.dart';
import 'package:bloodochallenge/comm/genLoginSignupHeader.dart';
import 'package:bloodochallenge/comm/genTextFormField.dart';
import 'package:bloodochallenge/db/users.dart';
import 'package:bloodochallenge/model/model.dart';
import 'package:bloodochallenge/ecrane/login2.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = new GlobalKey<FormState>();
  final _conUserName = TextEditingController();
  final _conPassword = TextEditingController();
  final _conCPassword = TextEditingController();
  var punctaj = 0;
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  signUp() async {
    print("Intra aici pe signup , toutl bine, sperr");
    String uname = _conUserName.text;
    String passwd = _conPassword.text;
    String cpasswd = _conCPassword.text;
    print("Username este $uname");
    print("Parola este $passwd");
    print("Confirmare parola este $cpasswd");
    UserModel x = await dbHelper.getall();
    print("Toti din bd acuma sunt $x.toMap()");
    int uid = await dbHelper.last_id();
    print("Uid last dupa este $uid");
    if (_formKey.currentState!.validate()) {
      if (passwd != cpasswd) {
        alertDialog(context, 'Password Mismatch');
      } else {
        _formKey.currentState!.save();

        UserModel uModel = UserModel(uid, uname, passwd, punctaj);
        await dbHelper.saveData(uModel).then((userData) {
          alertDialog(context, "Successfully Saved");

          Navigator.push(
              context, MaterialPageRoute(builder: (_) => LoginForm()));
        }).catchError((error) {
          print(error);
          alertDialog(context, "Error: Data Save Fail");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BlooDoChallenge'),
        backgroundColor: COLOR_CARMINE,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  genLoginSignupHeader('Signup'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                      controller: _conUserName,
                      icon: Icons.person_outline,
                      inputType: TextInputType.name,
                      hintName: 'User Name'),
                  SizedBox(height: 10.0),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: _conPassword,
                    icon: Icons.lock,
                    hintName: 'Password',
                    isObscureText: true,
                  ),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: _conCPassword,
                    icon: Icons.lock,
                    hintName: 'Confirm Password',
                    isObscureText: true,
                  ),
                  Container(
                    margin: EdgeInsets.all(30.0),
                    width: double.infinity,
                    child: FlatButton(
                      child: Text(
                        'Signup',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: signUp,
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
                        Text('Does you have account? '),
                        FlatButton(
                          textColor: COLOR_CARMINE,
                          child: Text('Sign In'),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => LoginForm()),
                                (Route<dynamic> route) => false);
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
      ),
    );
  }
}
