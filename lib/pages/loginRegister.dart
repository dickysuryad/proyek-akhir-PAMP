import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aplikasinotes/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInwithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );

    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserwithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _entryField(
    String title, 
    TextEditingController controller
  ) {
    return TextField(
      controller: controller,
      obscureText: title == 'password', 
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _errorMessage() {
    return errorMessage == null || errorMessage!.isEmpty
        ? const SizedBox.shrink()
        : Text(
            'Error: $errorMessage',
            style: const TextStyle(color: Colors.red),
          );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Register instead' : 'Login instead'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _entryField('email', _controllerEmail),
              const SizedBox(height: 20),
              _entryField('password', _controllerPassword),
              const SizedBox(height: 20),
              _errorMessage(),
              const SizedBox(height: 20),
              _submitButton(),
              const SizedBox(height: 10),
              _loginOrRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }
}
