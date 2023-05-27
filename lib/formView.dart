import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_code/global/functions.dart';
import 'package:test_code/global/variable.dart';
import 'package:test_code/home.dart';
import 'package:test_code/login.dart';

class formview extends StatefulWidget {
  const formview({super.key});

  @override
  State<formview> createState() => _formState();
}

class _formState extends State<formview> {
  var _pertanyaan = TextEditingController();
  var _jawaban = TextEditingController();

  bool? stat;
  bool able = true;
  bool isLoading = false;

  List<DropdownMenuItem<bool>> get dropdownItems {
    List<DropdownMenuItem<bool>> menuItems = [
      DropdownMenuItem(child: Text("Publish"), value: true),
      DropdownMenuItem(child: Text("Not Publish"), value: false),
    ];
    return menuItems;
  }

  @override
  void initState() {
    super.initState();
    if (id_faq != null) {
      details(id_faq!);
    }
  }

  void _onDropDownItemSelected(newSelected) {
    setState(
      () {
        stat = newSelected;
      },
    );
  }

  void details(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    detailfaq.clear();
    try {
      var response = await detail_faq(token!, id);
      if (response!.statusCode == 200) {
        var body = response.data['data'];
        setState(() {
          detailfaq.add(body);
          _pertanyaan.text = detailfaq[0]['pertanyaan'].toString();
          _jawaban.text = detailfaq[0]['jawaban'].toString();
          stat = detailfaq[0]['status_publish'] == 0 ? false : true;
          able = isEdited ? true : false;
        });
      }
    } catch (e) {
      setState(() {
        Get.to(() => login());
      });
    }
  }

  Future<void> toDo(String note) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    userData.clear();
    try {
      if (note == 'Send') {
        var response =
            await post_faq(token!, _pertanyaan.text, _jawaban.text, stat!);
      } else {
        var response = await edit_faq(
            token!, id_faq!, _pertanyaan.text, _jawaban.text, stat!);
      }
      if (response!.statusCode == 200) {
        setState(() {
          _pertanyaan.text = '';
          _jawaban.text = '';
          stat = null;
          isLoading = false;
          success(note);
        });
      } else {
        setState(() {
          isLoading = false;
          failed(note);
        });
      }
    } catch (e) {
      setState(() {
        Get.to(() => login());
      });
    }
  }

  success(String note) async {
    var alertStyle = AlertStyle(
      isCloseButton: false,
      titleStyle: TextStyle(
        fontFamily: 'Bahnschrift',
      ),
      animationType: AnimationType.shrink,
    );
    Alert(
      context: context,
      type: AlertType.success,
      title: "$note Faq Success",
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
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            setState(() {
              menus = 1;
              Get.to(() => home());
            });
          },
        ),
      ],
    ).show();
  }

  failed(String note) async {
    var alertStyle = AlertStyle(
      isCloseButton: false,
      titleStyle: TextStyle(
        fontFamily: 'Bahnschrift',
      ),
      animationType: AnimationType.shrink,
    );
    Alert(
      context: context,
      type: AlertType.success,
      title: "$note Faq Failed!",
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
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 42, 123, 45),
        title: const Text(
          "Create Faq",
          style: TextStyle(
            fontFamily: "Bahnschrift",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(
                25.0,
              ),
              child: FormBuilder(
                child: Column(
                  children: [
                    TextField(
                      enabled: able,
                      controller: _pertanyaan,
                      style: TextStyle(
                        fontFamily: "Bahnschrift",
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5.0),
                        labelText: 'Pertanyaan',
                        labelStyle:
                            TextStyle(fontFamily: "Bahnschrift", fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      enabled: able,
                      controller: _jawaban,
                      style: TextStyle(
                        fontFamily: "Bahnschrift",
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5.0),
                        labelText: 'Jawaban',
                        labelStyle:
                            TextStyle(fontFamily: "Bahnschrift", fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FormField<String>(builder: (FormFieldState<String> state) {
                      return DropdownButton(
                        isExpanded: true,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Bahnschrift",
                        ),
                        hint: Text(
                          "Status Publish",
                          style: TextStyle(
                            fontFamily: "Bahnschrift",
                          ),
                        ),
                        items: dropdownItems,
                        onChanged: able
                            ? (value) {
                                _onDropDownItemSelected(value!);
                              }
                            : null,
                        value: stat,
                      );
                    }),
                    SizedBox(
                      height: 20.0,
                    ),
                    !isEdited && id_faq == null
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                isLoading = true;
                                if (_pertanyaan.text.isEmpty ||
                                    _jawaban.text.isEmpty ||
                                    stat == null) {
                                  Fluttertoast.showToast(
                                    msg: "Please Complete the Data!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                } else {
                                  toDo('Send');
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 42, 123, 45),
                              ),
                              child: Text(
                                "Kirim Faq",
                                style: TextStyle(
                                  fontFamily: "Bahnschrift",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        : isEdited && id_faq != null
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isLoading = true;
                                    if (_pertanyaan.text.isEmpty ||
                                        _jawaban.text.isEmpty ||
                                        stat == null) {
                                      Fluttertoast.showToast(
                                        msg: "Please Complete the Data!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 3,
                                        backgroundColor: Colors.grey,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    } else {
                                      toDo('Update');
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromARGB(255, 42, 123, 45),
                                  ),
                                  child: Text(
                                    "Edit Faq",
                                    style: TextStyle(
                                      fontFamily: "Bahnschrift",
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 0,
                              ),
                    SizedBox(
                      height: 20.0,
                    ),
                    isLoading
                        ? SpinKitCircle(
                            color: Color.fromARGB(255, 42, 123, 45),
                            size: 30.0,
                          )
                        : SizedBox(
                            height: 0,
                          ),
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
