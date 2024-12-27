import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:real12/auth.dart';
import 'package:real12/loginRegister.dart';
import 'addnote.dart';

class Home extends StatefulWidget {
  Home({super.key});

    final User? user = Auth().currentUser;

  Future<void> signOut(BuildContext context) async {
    await Auth().signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginRegisterPage()),
      (Route<dynamic> route) => false,
    );
  }

  Widget _title() {
    return const Text('Settings');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => signOut(context),
      child: const Text('Sign Out'),
    );
  }


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final fb = FirebaseDatabase.instance;
  TextEditingController second = TextEditingController();
  TextEditingController third = TextEditingController();
  var l;
  var g;
  var k;
  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('notes');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(106, 62, 161, 1),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => addnote(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: 
          Color.fromRGBO(255, 255, 255, 1),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Your Notes',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        backgroundColor: Color.fromRGBO(106, 62, 161, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Color.fromRGBO(255, 255, 255, 1)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: widget._title(),
                    ),
                    body: Container(
                      height: double.infinity,
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          widget._userUid(),
                          widget._signOutButton(context), // Tambahkan context
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FirebaseAnimatedList(
        query: ref,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {
          var v =
              snapshot.value.toString(); // {subtitle: webfun, title: subscribe}

          g = v.replaceAll(
              RegExp("{|}|subtitle: |title: "), ""); // webfun, subscribe
          g.trim();

          l = g.split(','); // [webfun,  subscribe}]

          return GestureDetector(
            onTap: () {
              setState(() {
                k = snapshot.key;
              });

              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: TextField(
                      controller: second,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'title',
                      ),
                    ),
                  ),
                  content: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: TextField(
                      controller: third,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'sub title',
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      color: Color.fromRGBO(106, 62, 161, 1),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        await upd();
                        Navigator.of(ctx).pop();
                      },
                      color: Color.fromRGBO(106, 62, 161, 1),
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Colors.indigo[100],
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 255, 0, 0),
                    ),
                    onPressed: () {
                      ref.child(snapshot.key!).remove();
                    },
                  ),
                  title: Text(
                    l[1],
                    // 'dd',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    l[0],
                    // 'dd',

                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  upd() async {
    DatabaseReference ref1 = FirebaseDatabase.instance.ref("notes/$k");

    await ref1.update({
      "title": second.text,
      "subtitle": third.text,
    });
    second.clear();
    third.clear();
  }
} 