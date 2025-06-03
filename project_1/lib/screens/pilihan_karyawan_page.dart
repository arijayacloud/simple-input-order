import 'package:flutter/material.dart';
import 'detail_karyawan_page.dart';
import 'package:intl/intl.dart';
import 'dart:async'; // Tambahkan ini!

class PilihanKaryawanPage extends StatefulWidget {
  const PilihanKaryawanPage({super.key});

  @override
  State<PilihanKaryawanPage> createState() => _PilihanKaryawanPageState();
}

class _PilihanKaryawanPageState extends State<PilihanKaryawanPage> {
  late String _currentTime;

  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
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
    final List<String> karyawan = ['Karyawan A', 'Karyawan B', 'Karyawan C', 'Karyawan D', 'Karyawan E', 'Karyawan F'];

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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentTime,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: karyawan.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailKaryawanPage(namaKaryawan: karyawan[index]),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        karyawan[index],
                        style: const TextStyle(fontSize: 18),
                      ),
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
