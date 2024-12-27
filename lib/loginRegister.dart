import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:real12/auth.dart';
import 'package:real12/home_page.dart';

class AuthProvider with ChangeNotifier {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      await Auth().signInwithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $errorMessage'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> createUserWithEmailAndPassword(BuildContext context) async {
    try {
      await Auth().createUserwithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account successfully created!'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: $errorMessage'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void toggleLoginRegister() {
    isLogin = !isLogin;
    notifyListeners();
  }
}

class LoginRegisterPage extends StatelessWidget {
  const LoginRegisterPage({super.key});

  Widget _title() {
    return const Text('Notes');
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: title == 'password',
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _errorMessage(String? errorMessage) {
    return errorMessage == null || errorMessage.isEmpty
        ? const SizedBox.shrink()
        : Text(
            'Error: $errorMessage',
            style: const TextStyle(color: Colors.red),
          );
  }

  Widget _submitButton(AuthProvider provider, BuildContext context) {
    return ElevatedButton(
      onPressed: () => provider.isLogin
          ? provider.signInWithEmailAndPassword(context)
          : provider.createUserWithEmailAndPassword(context),
      child: Text(provider.isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton(AuthProvider provider) {
    return TextButton(
      onPressed: provider.toggleLoginRegister,
      child: Text(provider.isLogin ? 'Register instead' : 'Login instead'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

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
              _entryField('email', authProvider.emailController),
              const SizedBox(height: 20),
              _entryField('password', authProvider.passwordController),
              const SizedBox(height: 20),
              _errorMessage(authProvider.errorMessage),
              const SizedBox(height: 20),
              _submitButton(authProvider, context),
              const SizedBox(height: 10),
              _loginOrRegisterButton(authProvider),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginRegisterPage(),
    );
  }
}
