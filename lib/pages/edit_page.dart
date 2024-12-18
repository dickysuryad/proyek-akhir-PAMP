import 'package:aplikasinotes/pages/home_page.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final Catatan catatan;
  final VoidCallback onDelete;

  EditPage({required this.catatan, required this.onDelete});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.catatan.judul;
    subtitleController.text = widget.catatan.isi;

    titleController.addListener(() {
      setState(() {
        hasChanges = true;
      });
    });
    subtitleController.addListener(() {
      setState(() {
        hasChanges = true;
      });
    });
  }

  void deleteNote() {
    widget.onDelete();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              print('Share diklik');
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Hapus') {
                deleteNote();
              } else if (value == 'Sematkan') {
                // Aksi ketika opsi "sematkan" dipilih
              }
            },
            itemBuilder: (BuildContext context) {
              return ['Sematkan', 'Hapus'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (hasChanges) {
            final shouldSave = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Simpan perubahan?'),
                  content: Text(
                      'Apakah Anda ingin menyimpan perubahan pada catatan ini?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('Tidak'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Ya'),
                    ),
                  ],
                );
              },
            );

            if (shouldSave == true) {
              final judul = titleController.text;
              final isi = subtitleController.text;
              widget.onDelete();

              final catatan = Catatan(judul: judul, isi: isi);
              daftarCatatan.add(catatan);
            }
          }

          return true;
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
                SizedBox(height: 25.0),
                TextField(
                  controller: subtitleController,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
