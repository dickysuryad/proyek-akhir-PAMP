import 'package:flutter/material.dart';
import 'package:aplikasinotes/pages/home_page.dart';

class TambahCatatanPage extends StatelessWidget {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController isiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final judul = judulController.text;
        final isi = isiController.text;

        if (judul.isNotEmpty || isi.isNotEmpty) {
          final catatan = Catatan(judul: judul, isi: isi);
          daftarCatatan.add(catatan);
        }

        Navigator.pop(
          context,
          true, // Mengirimkan sinyal berhasil tambah catatan
        );

        return true; // Izinkan kembali saat tombol kembali ditekan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tambah Catatan'),
        ),
        body: Column(
          children: [
            TextField(
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              controller: judulController,
              decoration: InputDecoration(
                hintText: 'Judul',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
            SizedBox(height: 25.0),
            TextField(
              style: TextStyle(fontSize: 20),
              controller: isiController,
              decoration: InputDecoration(
                hintText: 'Isi Catatan',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
