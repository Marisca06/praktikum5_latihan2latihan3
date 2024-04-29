import 'package:flutter/material.dart'; // Mengimpor pustaka dasar Flutter.
import 'package:http/http.dart'
    as http; // Mengimpor pustaka http untuk melakukan panggilan HTTP ke API.
import 'dart:convert'; // Mengimpor pustaka dart:convert untuk mengonversi JSON.

void main() {
  runApp(const MyApp()); // Menjalankan aplikasi Flutter.
}

// Kelas yang merepresentasikan aktivitas yang diperoleh dari API.
class Activity {
  String aktivitas; // Atribut untuk menyimpan deskripsi aktivitas.
  String jenis; // Atribut untuk menyimpan jenis aktivitas.

  // Konstruktor untuk kelas Activity.
  Activity({required this.aktivitas, required this.jenis});

  // Factory method untuk mengonversi data JSON menjadi objek Activity.
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'], // Mengambil deskripsi aktivitas dari JSON.
      jenis: json['type'], // Mengambil jenis aktivitas dari JSON.
    );
  }
}

// Kelas utama aplikasi Flutter.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Membuat dan mengembalikan state baru.
  }
}

// State untuk MyApp.
class MyAppState extends State<MyApp> {
  late Future<Activity> futureActivity; // Menampung hasil aktivitas dari API.
  String url = "https://www.boredapi.com/api/activity"; // URL API.

  // Metode untuk menginisialisasi futureActivity.
  Future<Activity> init() async {
    return Activity(
        aktivitas: "", jenis: ""); // Mengembalikan objek Activity kosong.
  }

  // Metode untuk melakukan panggilan HTTP ke API.
  Future<Activity> fetchData() async {
    final response =
        await http.get(Uri.parse(url)); // Panggilan HTTP GET ke URL.
    if (response.statusCode == 200) {
      // Jika respons berhasil (kode status 200),
      // parse JSON dan kembalikan objek Activity.
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // Jika respons tidak berhasil, lempar Exception.
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity = init(); // Inisialisasi futureActivity.
  }

  @override
  Widget build(Object context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity =
                      fetchData(); // Panggil metode fetchData saat tombol ditekan.
                });
              },
              child: Text("Saya bosan ..."), // Teks tombol.
            ),
          ),
          FutureBuilder<Activity>(
            future: futureActivity,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika data tersedia dari future, tampilkan deskripsi dan jenis aktivitas.
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas),
                      Text("Jenis: ${snapshot.data!.jenis}")
                    ]));
              } else if (snapshot.hasError) {
                // Jika terjadi error, tampilkan pesan error.
                return Text('${snapshot.error}');
              }
              // Default: tampilkan indikator loading.
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  }
}
