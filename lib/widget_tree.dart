import 'package:aplikasinotes/auth.dart';
import 'package:aplikasinotes/pages/home_page.dart';
import 'package:aplikasinotes/pages/loginRegister.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget{
  const WidgetTree({Key? key}) : super(key: key);


  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges, 
      builder: (context, snapShot) {
        if (snapShot.hasData) {
          return HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}