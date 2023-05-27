import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_code/global/functions.dart';
import 'package:test_code/global/variable.dart';
import 'package:test_code/home.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _obscureText = true;
  bool _validate = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> toDo() async {
    userData.clear();
    try {
      var response = await post_login(_email.text, _password.text);
      if (response!.statusCode == 200) {
        setState(() {
          isLoading = false;
          userData.add(response.data);
          StoreUser();
          Get.to(() => home());
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        failedlogin();
      });
    }
  }

  Future<void> StoreUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('token', userData[0]['data']['access_token'].toString());
      prefs.setString('name', userData[0]['data']['name'].toString());
      prefs.setString('photo', userData[0]['data']['path_foto'].toString());
    });
  }

  failedlogin() {
    var alertStyle = AlertStyle(
      isCloseButton: false,
      titleStyle: TextStyle(
        color: Colors.red,
        fontFamily: 'Bahnschrift',
      ),
      descStyle: TextStyle(
        fontFamily: 'Bahnschrift',
        fontSize: 12,
      ),
      animationType: AnimationType.shrink,
    );
    Alert(
      context: context,
      type: AlertType.error,
      title: "Login Failed",
      desc: "Invalid Credentials!",
      style: alertStyle,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(
              fontFamily: 'Bahnschrift',
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.blue,
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 50.0),
              alignment: Alignment.center,
              width: 150.0,
              child: Image(
                image: AssetImage(
                  'assets/images/logo.png',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "LOGIN FORM",
                style: TextStyle(
                  fontFamily: "Bahnschrift",
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(30.0),
              child: FormBuilder(
                child: Column(
                  children: [
                    TextField(
                      controller: _email,
                      onChanged: (value) => setState(() {
                        _validate = EmailValidator.validate(value);
                      }),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5.0),
                        fillColor: Colors.white,
                        suffixIcon: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.mail,
                              color: Colors.black,
                            )),
                        labelText: 'E-mail',
                        labelStyle:
                            TextStyle(fontFamily: "Bahnschrift", fontSize: 14),
                        hintStyle:
                            TextStyle(fontFamily: "Bahnschrift", fontSize: 14),
                        errorText: _validate ? null : "Email Tidak Sesuai!",
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: _password,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5.0),
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(fontFamily: "Bahnschrift", fontSize: 14),
                        hintStyle:
                            TextStyle(fontFamily: "Bahnschrift", fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLoading = true;
                          if (_email.text.isEmpty || _password.text.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Please Complete the Data!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            setState(
                              () {
                                isLoading = false;
                              },
                            );
                          } else {
                            toDo();
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 10.0, right: 25.0, bottom: 10.0, left: 25.0),
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            fontFamily: "Bahnschrift",
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 42, 123, 45),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    isLoading
                        ? SpinKitFadingCircle(
                            color: Color.fromARGB(255, 42, 123, 45),
                            size: 30.0,
                          )
                        : SizedBox(
                            height: 0,
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
