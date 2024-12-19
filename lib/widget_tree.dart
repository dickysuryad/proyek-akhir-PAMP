import 'package:real12/auth.dart';
import 'package:real12/home_page.dart';
import 'package:real12/loginRegister.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget{
  const WidgetTree({super.key});


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
          return Home();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}