import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_code/global/variable.dart';
import 'package:test_code/home.dart';
import 'package:test_code/login.dart';

class splash extends StatefulWidget {
  const splash({super.key});
  @override
  State<splash> createState() => _splash();
}

class _splash extends State<splash> {
  bool isLoading = true;
  bool connect = false;
  bool check_conn = false;

  loginpage() async {
    await Future.delayed(Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userData.clear();
      try {
        if (prefs.getString("token") != null) {
          setState(() {
            Get.to(() => home());
          });
        } else {
          setState(() {
            Get.to(() => login());
          });
        }
      } catch (e) {
        setState(() {
          Get.to(() => login());
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loginpage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 300,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20.0),
              SpinKitCircle(
                color: Color.fromARGB(255, 42, 123, 45),
                size: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
