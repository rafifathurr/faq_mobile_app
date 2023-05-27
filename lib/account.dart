import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_code/formView.dart';
import 'package:test_code/global/functions.dart';
import 'package:test_code/global/variable.dart';
import 'package:test_code/login.dart';

class accountview extends StatefulWidget {
  const accountview({super.key});

  @override
  State<accountview> createState() => _accountState();
}

class _accountState extends State<accountview> {
  bool isLoading = true;
  bool connect = true;
  String? name;
  String? path;

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
      name = prefs.getString('name');
      path = prefs.getString('photo');
    });
  }

  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await post_logout(token!);
      if (response!.statusCode == 200) {
        setState(() {
          prefs.clear();
          SystemNavigator.pop();
          Get.to(() => login());
        });
      } else {
        Navigator.of(context).pop(false);
        Fluttertoast.showToast(
          msg: "Logout Failed!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Navigator.of(context).pop(false);
      Fluttertoast.showToast(
        msg: "Check Your Connection!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<bool> _willPopCallback() async {
    bool goBack = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            'Apakah Anda Ingin Log Out Dari Aplikasi?',
            style: TextStyle(
              fontFamily: "Bahnschrift",
            ),
          ),
          actions: [
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Tidak",
                  style: TextStyle(
                    fontFamily: "Bahnschrift",
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop(false);
              },
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 15.0),
                child: Text(
                  "Ya",
                  style: TextStyle(
                    fontFamily: "Bahnschrift",
                  ),
                ),
              ),
              onTap: () async {
                setState(() {
                  clear();
                });
              },
            )
          ],
        );
      },
    );
    return goBack;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? SpinKitCircle(
                color: Colors.black,
                size: 30.0,
              )
            : Container(
                constraints: BoxConstraints.expand(),
                child: RefreshIndicator(
                  onRefresh: getData,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, top: 80),
                          padding: EdgeInsets.all(10),
                          child: ClipOval(
                            child: path == null
                                ? Image.asset(
                                    'assets/images/avatar.png',
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    path!,
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Image.asset(
                                        'assets/images/avatar.png',
                                        width: 130,
                                        height: 130,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Image.asset(
                                        'assets/images/avatar.png',
                                        width: 130,
                                        height: 130,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            name!,
                            style: TextStyle(
                              fontFamily: "Bahnschrift",
                              fontSize: 27,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 25.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(
                                    () {
                                      _willPopCallback();
                                    },
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 30, right: 20, left: 20, bottom: 10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 20, bottom: 5),
                                        width: 35,
                                        height: 35,
                                        child: Icon(
                                          Icons.logout,
                                          color: Colors.black,
                                          size: 36.0,
                                        ),
                                      ),
                                      Text(
                                        "Log Out",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Bahnschrift',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
