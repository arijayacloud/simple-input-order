import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:math';
import 'detail_karyawan_page.dart';

class PilihanKaryawanPage extends StatefulWidget {
  const PilihanKaryawanPage({super.key});

  @override
  State<PilihanKaryawanPage> createState() => _PilihanKaryawanPageState();
}

class _PilihanKaryawanPageState extends State<PilihanKaryawanPage> {
  late String _currentTime;

  final List<String> karyawan = [
    'Karyawan A',
    'Karyawan B',
    'Karyawan C',
    'Karyawan D',
    'Karyawan E',
    'Karyawan F',
    'Karyawan G',
    'Karyawan H',
  ];

  final List<Color> warnaPilihan = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.teal,
    Colors.blueAccent,
    Colors.amber,
    Colors.deepPurpleAccent,
    Colors.pinkAccent,
  ];

  late List<Color> warnaKartu;

  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });

    // Acak warna untuk setiap karyawan
    final random = Random();
    warnaKartu = List.generate(karyawan.length, (index) {
      return warnaPilihan[random.nextInt(warnaPilihan.length)];
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final formattedTime = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
    setState(() {
      _currentTime = formattedTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Menu Karyawan',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentTime,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                itemCount: karyawan.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 kotak per baris
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (context, index) {
                  final isLight = warnaKartu[index] == Colors.white || warnaKartu[index] == Colors.grey;

                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailKaryawanPage(
                            namaKaryawan: karyawan[index],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: warnaKartu[index],
                      foregroundColor: isLight ? Colors.black : Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      karyawan[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
