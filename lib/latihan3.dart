import 'dart:convert'; // Import library dart:convert untuk mengonversi data JSON.
import 'package:flutter/material.dart'; // Import library Flutter Material untuk membangun antarmuka pengguna.
import 'package:http/http.dart'
    as http; // Import library http dari package http untuk melakukan permintaan HTTP.

void main() {
  runApp(MyApp()); // Fungsi main, menjalankan aplikasi Flutter.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Universitas Indonesia', // Judul aplikasi.

      home:
          UniversityList(), // Beranda aplikasi menampilkan daftar universitas.
    );
  }
}

class UniversityList extends StatefulWidget {
  @override
  _UniversityListState createState() =>
      _UniversityListState(); // Membuat stateful widget UniversityList.
}

class _UniversityListState extends State<UniversityList> {
  List _universities = []; // List untuk menyimpan data universitas.
  bool _isLoading = false; // Variabel untuk menunjukkan status loading.
  String _errorMessage =
      ''; // Variabel untuk menyimpan pesan kesalahan jika terjadi.

  @override
  void initState() {
    super.initState();
    _fetchUniversities(); // Memanggil fungsi untuk mengambil data universitas saat widget pertama kali dibuat.
  }

  Future<void> _fetchUniversities() async {
    setState(() {
      _isLoading =
          true; // Set isLoading menjadi true saat melakukan permintaan HTTP.
      _errorMessage =
          ''; // Mengosongkan pesan kesalahan sebelum permintaan HTTP.
    });

    try {
      final response = await http.get(
        Uri.parse(
            'http://universities.hipolabs.com/search?country=Indonesia'), // Mengirim permintaan GET ke URL API yang menyediakan data universitas Indonesia.
      );

      if (response.statusCode == 200) {
        // Memeriksa apakah permintaan berhasil.
        setState(() {
          _universities = json.decode(response
              .body); // Mendekode data JSON dari respons dan menyimpannya ke dalam list _universities.
          _isLoading =
              false; // Set isLoading menjadi false setelah mendapatkan data.
        });
      } else {
        throw Exception(
            'Failed to load universities: ${response.reasonPhrase}'); // Menampilkan pesan kesalahan jika permintaan tidak berhasil.
      }
    } catch (error) {
      setState(() {
        _errorMessage =
            'Error: $error'; // Menyimpan pesan kesalahan jika terjadi kesalahan selama pemrosesan data.
        _isLoading =
            false; // Set isLoading menjadi false setelah terjadi kesalahan.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Universitas Indonesia'), // Judul AppBar.
        centerTitle: true, // Mengatur judul AppBar menjadi berada di tengah.
      ),
      body: _isLoading // Menampilkan indikator loading jika isLoading true.
          ? Center(
              child:
                  CircularProgressIndicator(), // Menampilkan CircularProgressIndicator di tengah layar.
            )
          : _errorMessage.isNotEmpty // Menampilkan pesan kesalahan jika ada.
              ? Center(
                  child: Text(
                    _errorMessage, // Menampilkan pesan kesalahan.
                    style: TextStyle(
                        color:
                            Colors.red), // Mengatur warna teks menjadi merah.
                  ),
                )
              : ListView.builder(
                  itemCount:
                      _universities.length, // Jumlah item dalam ListView.
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4, // Membuat bayangan kartu.
                      margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16), // Memberi jarak antara setiap item.
                      child: ListTile(
                        title: Text(_universities[index]['name'],
                            style: TextStyle(
                                fontSize:
                                    18)), // Menampilkan nama universitas dengan ukuran font 18.
                        subtitle: Text(_universities[index]['web_pages']
                            [0]), // Menampilkan URL halaman web universitas.
                        leading: CircleAvatar(
                          // Menampilkan ikon universitas sebagai avatar.
                          child: Icon(Icons.school), // Icon sekolah.
                          backgroundColor: Color(
                              0xFFFFE0B5), // Mengatur warna latar belakang avatar.
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
