import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aplikasinotes/auth.dart';
import 'package:aplikasinotes/pages/edit_page.dart';
import 'package:aplikasinotes/pages/tambah_page.dart';
import 'package:aplikasinotes/pages/loginRegister.dart'; // Pastikan halaman login diimpor

class Catatan {
  final String judul;
  final String isi;

  Catatan({required this.judul, required this.isi});
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut(BuildContext context) async {
    await Auth().signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  Widget _title() {
    return const Text('Firebase Auth');
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
  _HomePageState createState() => _HomePageState();
}

List<Catatan> daftarCatatan = [];

class _HomePageState extends State<HomePage> {
  void deleteNote(Catatan catatan) {
    daftarCatatan.remove(catatan);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
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
      body: ListView.builder(
        itemCount: daftarCatatan.length,
        itemBuilder: (context, index) {
          return MyListItem(
            catatan: daftarCatatan[index],
            onDelete: () => deleteNote(daftarCatatan[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TambahCatatanPage(),
            ),
          ).then((value) {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyListItem extends StatefulWidget {
  final Catatan catatan;
  final VoidCallback onDelete;

  MyListItem({required this.catatan, required this.onDelete});

  @override
  _MyListItemState createState() => _MyListItemState();
}

class _MyListItemState extends State<MyListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: ListTile(
        title: Text(
          widget.catatan.judul,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(widget.catatan.isi),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditPage(
                catatan: widget.catatan,
                onDelete: widget.onDelete,
              ),
            ),
          );
        },
      ),
    );
  }
}
