import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lilac_machine_test/Helper/buttonWidget.dart';

class DrawerWidget extends StatefulWidget {
  final data;
  const DrawerWidget({Key? key, this.data}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Drawer(
          child: Column(
            children: [
              _createDrawerHeader(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createDrawerHeader() {
    return DrawerHeader(
        padding: EdgeInsets.zero,
        child: Stack(children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Center(
              child: Image.asset(
                'assets/logo.png',
                width: 130,
                height: 130,
              ),
            ),
          ),
          Positioned(
            child: ChangeThemeButtonWidget(),
            right: 0,
            top: 0,
          )
        ]));
  }
}
