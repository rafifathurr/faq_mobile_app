import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_code/formView.dart';
import 'package:test_code/global/variable.dart';
import '../global/variable.dart';
import '../global/functions.dart';

class faq extends StatefulWidget {
  const faq({super.key});

  @override
  State<faq> createState() => _faqState();
}

class _faqState extends State<faq> {
  bool isLoading = true;
  File? image;

  // Variable for paginate
  ScrollController? _controller;
  int _page = 0;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  bool connect = true;
  bool isNotEmpty = false;
  bool showbtn = false;

  String? token;

  Future allreport() async {
    _page = 1;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    listfaq.clear();

    try {
      var response = await dio.get(
        baseUrl + "superadmin/faq?page=$_page&rows=10",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      var body = response.data['data'];
      setState(
        () {
          isLoading = false;
          listfaq.addAll(body);
        },
      );
    } catch (e) {
      logger.e(e);
      Fluttertoast.showToast(
        msg: "Check Your Connection!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        isLoading = false;
        connect = false;
        isNotEmpty = true;
      });
    }
  }

  void _loadMore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller!.position.extentAfter < 300) {
      setState(
        () {
          _isLoadMoreRunning = true;
        },
      );

      _page += 1;

      try {
        var response = await dio.get(
          baseUrl + "superadmin/faq?page=$_page&rows=10",
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
            },
          ),
        );

        var body = response.data['data'];

        List<dynamic> fetchData = [];
        fetchData.addAll(body);

        if (fetchData.isNotEmpty) {
          setState(
            () {
              listfaq.addAll(fetchData);
            },
          );
        } else {
          setState(
            () {
              _hasNextPage = false;
              _isLoadMoreRunning = false;
            },
          );
        }
      } catch (err) {
        if (kDebugMode) {
          logger.e(err);
        }
      }

      setState(
        () {
          _isLoadMoreRunning = false;
        },
      );
    }
  }

  void toTop() {
    setState(() {
      _controller?.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
      showbtn = false;
    });
  }

  void checkScroll() {
    double showoffset = 10.0;

    if (_controller!.offset > showoffset) {
      setState(() {
        showbtn = true;
      });
    } else {
      setState(() {
        showbtn = false;
      });
    }

    _loadMore();
  }

  Future<void> doDelete(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    userData.clear();
    try {
      var response = await delete_faq(token!, id);
      if (response!.statusCode == 200) {
        setState(() {
          isLoading = false;
          success('Delete');
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        failed('Delete');
      });
    }
  }

  void confirmation(int id) {
    var alertStyle = AlertStyle(
      isCloseButton: false,
      titleStyle: TextStyle(
        color: Colors.black,
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
      type: AlertType.warning,
      title: "Apakah Anda Yakin Untuk Hapus Faq Ini?",
      style: alertStyle,
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(
              fontFamily: 'Bahnschrift',
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          color: Colors.blue,
        ),
        DialogButton(
          child: Text(
            "Delete",
            style: TextStyle(
              fontFamily: 'Bahnschrift',
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            await Future.delayed(
              Duration(seconds: 1),
              () {
                doDelete(id);
              },
            );
          },
          color: Colors.red,
        ),
      ],
    ).show();
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
      title: "$note Success",
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
              isLoading = true;
              allreport();
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
      title: "Send Faq Failed!",
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
              isLoading = true;
              allreport();
            });
          },
        ),
      ],
    ).show();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allreport();
    _controller = ScrollController()..addListener(checkScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 42, 123, 45),
          title: const Text(
            "All Faqs",
            style: TextStyle(
              fontFamily: "Bahnschrift",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        floatingActionButton: AnimatedOpacity(
          duration: Duration(milliseconds: 200), //show/hide animation
          opacity: showbtn ? 0.5 : 0.0, //set obacity to 1 on visible, or hide
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                toTop();
              });
            },
            child: Icon(
              Icons.arrow_upward,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
          ),
        ),
        body: isLoading
            ? SpinKitCircle(
                color: Colors.black,
                size: 50.0,
              )
            : Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: RefreshIndicator(
                          onRefresh: allreport,
                          child: ListView(
                            controller: _controller,
                            children: List.generate(
                              listfaq.length,
                              (index) => new GestureDetector(
                                onTap: () {
                                  setState(() {
                                    id_faq = listfaq[index]['id'];
                                    isEdited = false;
                                    Get.to(() => formview());
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 10.0,
                                      left: 15.0,
                                      right: 15.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(20.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Pertanyaan ",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Bahnschrift",
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12.0,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5.0,
                                                            ),
                                                            Text(
                                                              ":",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Bahnschrift",
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12.0,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10.0,
                                                            ),
                                                            Container(
                                                              width: 200,
                                                              child: Text(
                                                                listfaq[index][
                                                                        'pertanyaan']
                                                                    .toString(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "Bahnschrift",
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      12.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Jawaban",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Bahnschrift",
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12.0,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 21.0,
                                                            ),
                                                            Text(
                                                              ":",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Bahnschrift",
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12.0,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10.0,
                                                            ),
                                                            Container(
                                                              width: 200,
                                                              child: Text(
                                                                listfaq[index][
                                                                        'jawaban']
                                                                    .toString(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "Bahnschrift",
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      12.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Status",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Bahnschrift",
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12.0,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 34.0,
                                                            ),
                                                            Text(
                                                              ":",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Bahnschrift",
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12.0,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10.0,
                                                            ),
                                                            Container(
                                                              width: 200,
                                                              child: Text(
                                                                listfaq[index][
                                                                            'status_publish'] ==
                                                                        0
                                                                    ? 'Not Publish'
                                                                    : 'Publish',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "Bahnschrift",
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      12.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Tanggal",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Bahnschrift",
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12.0,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 27.0,
                                                            ),
                                                            Text(
                                                              ":",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Bahnschrift",
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12.0,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10.0,
                                                            ),
                                                            Text(
                                                              DateFormat(
                                                                      'EEEE, dd MMM yyyy h:mm a')
                                                                  .format(
                                                                    DateTime
                                                                        .parse(
                                                                      listfaq[index]
                                                                              [
                                                                              'created_at']
                                                                          .toString(),
                                                                    ),
                                                                  )
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Bahnschrift",
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              id_faq =
                                                                  listfaq[index]
                                                                      ['id'];
                                                              isEdited = true;
                                                              Get.to(() =>
                                                                  formview());
                                                            });
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color:
                                                                  Colors.blue,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      2,
                                                                  blurRadius: 7,
                                                                  offset:
                                                                      const Offset(
                                                                          0, 3),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 11,
                                                                ),
                                                                SizedBox(
                                                                    width: 5.0),
                                                                Text(
                                                                  "Update",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        "Bahnschrift",
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              confirmation(
                                                                  listfaq[index]
                                                                      ['id']);
                                                            });
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Colors.red,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      2,
                                                                  blurRadius: 7,
                                                                  offset:
                                                                      const Offset(
                                                                          0, 3),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 11,
                                                                ),
                                                                SizedBox(
                                                                    width: 5.0),
                                                                Text(
                                                                  "Delete",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        "Bahnschrift",
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
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
                          ),
                        ),
                      ),
                    ),
                    if (_isLoadMoreRunning == true)
                      SpinKitCircle(
                        color: Colors.black,
                        size: 30.0,
                      ),
                  ],
                ),
              ));
  }
}
