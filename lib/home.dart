import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";
import 'package:test_code/account.dart';
import 'package:test_code/allfaqView.dart';
import 'package:test_code/formView.dart';
import 'package:test_code/global/variable.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: menus);

  Future<bool> _willPopCallback() async {
    bool goBack = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            'Apakah Anda Ingin Keluar Dari Aplikasi?',
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
                SystemNavigator.pop();
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: PersistentTabView(
          backgroundColor: Color.fromARGB(255, 42, 123, 45),
          context,
          controller: _controller,
          screens: const [
            formview(),
            faq(),
            accountview(),
          ],
          items: _navBarsItems(),
          navBarStyle: NavBarStyle.style3,
        ),
      ),
      onWillPop: _willPopCallback,
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.add,
          color: Colors.white,
          size: 36.0,
        ),
        activeColorPrimary: Colors.white,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.format_list_bulleted,
          color: Colors.white,
          size: 36.0,
        ),
        activeColorPrimary: Colors.white,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.account_circle_outlined,
          color: Colors.white,
          size: 36.0,
        ),
        activeColorPrimary: Colors.white,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.white,
      ),
    ];
  }
}
