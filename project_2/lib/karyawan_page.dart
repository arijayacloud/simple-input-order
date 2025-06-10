import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:universal_html/html.dart' as html;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

final List<String> namaBulan = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
];

class Karyawan {
  final String nama;
  final double totalProfit;
  final DateTime? createdAt;

  Karyawan({
    required this.nama,
    required this.totalProfit,
    required this.createdAt,
  });
}

class KaryawanDataSource extends DataGridSource {
  final List<DataGridRow> _rows;

  KaryawanDataSource({required List<Karyawan> karyawans})
      : _rows = karyawans.map<DataGridRow>((k) {
          return DataGridRow(cells: [
            DataGridCell<String>(columnName: 'nama', value: k.nama),
            DataGridCell<String>(columnName: 'total_profit', value: currencyFormat.format(k.totalProfit)),
          ]);
        }).toList();

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final index = _rows.indexOf(row);
    return DataGridRowAdapter(
      color: index % 2 == 0 ? Colors.grey[50] : Colors.white,
      cells: row.getCells().map((cell) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Text(
            cell.value.toString(),
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );
  }
}

class KaryawanPage extends StatefulWidget {
  final String token;

  const KaryawanPage({super.key, required this.token});

  @override
  State<KaryawanPage> createState() => _KaryawanPageState();
}

class _KaryawanPageState extends State<KaryawanPage> {
  late KaryawanDataSource _dataSource;
  List<dynamic> allRawData = [];
  List<Karyawan> groupedKaryawan = [];
  String? selectedBulan;
  String? selectedTahun;
  List<String> tahunList = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchKaryawan();
  }

  Future<void> fetchKaryawan() async {
    try {
      final response = await http.get(
        Uri.parse('http://apppenjualan791.my.id/api/admin/karyawans'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        final Set<String> tahunSet = {};

        allRawData = data;

        for (var item in data) {
          final createdAt = DateTime.tryParse(item['created_at'] ?? '');
          if (createdAt != null) {
            tahunSet.add(createdAt.year.toString());
          }
        }

        tahunList = tahunSet.toList()..sort();
        updateDataSource();
      } else {
        setState(() {
          error = 'Gagal mengambil data (${response.statusCode})';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Terjadi error: $e';
        loading = false;
      });
    }
  }

  void updateDataSource() {
    // Filter dan group by nama
    Map<String, double> groupedProfit = {};
    Map<String, DateTime?> createdAtMap = {};

    for (var item in allRawData) {
      final nama = item['nama'] ?? '';
      final profit = double.tryParse(item['total_profit'].toString()) ?? 0;
      final createdAt = DateTime.tryParse(item['created_at'] ?? '');

      final matchBulan = selectedBulan == null ||
          (createdAt != null && DateFormat('MMMM', 'id_ID').format(createdAt) == selectedBulan);
      final matchTahun = selectedTahun == null ||
          (createdAt != null && createdAt.year.toString() == selectedTahun);

      if (matchBulan && matchTahun) {
        groupedProfit[nama] = (groupedProfit[nama] ?? 0) + profit;
        createdAtMap[nama] = createdAt; // untuk informasi tambahan (jika perlu)
      }
    }

    groupedKaryawan = groupedProfit.entries.map((entry) {
      return Karyawan(
        nama: entry.key,
        totalProfit: entry.value,
        createdAt: createdAtMap[entry.key],
      );
    }).toList();

    _dataSource = KaryawanDataSource(karyawans: groupedKaryawan);

    setState(() {
      loading = false;
    });
  }

  Future<void> exportToExcel() async {
    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];

    // Header style
    final headerStyle = workbook.styles.add('headerStyle');
    headerStyle.bold = true;
    headerStyle.backColor = '#DCE6F1';
    headerStyle.hAlign = xlsio.HAlignType.center;
    headerStyle.borders.all.lineStyle = xlsio.LineStyle.thin;

    // Header
    final headers = ['Nama', 'Total Profit'];
    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(1, i + 1);
      cell.setText(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // Currency style
    final currencyStyle = workbook.styles.add('CurrencyStyle');
    currencyStyle.numberFormat = r'_([$Rp-421]* #,##0_)';

    // Isi data
    double totalProfit = 0;
    for (int i = 0; i < groupedKaryawan.length; i++) {
      final row = i + 2;
      final item = groupedKaryawan[i];

      sheet.getRangeByIndex(row, 1).setText(item.nama);
      sheet.getRangeByIndex(row, 2).setNumber(item.totalProfit);
      sheet.getRangeByIndex(row, 2).cellStyle = currencyStyle;

      totalProfit += item.totalProfit;
    }

    // Total row
    final totalRow = groupedKaryawan.length + 3;
    sheet.getRangeByIndex(totalRow, 1).setText('Jumlah Total Profit');
    sheet.getRangeByIndex(totalRow, 2).setNumber(totalProfit);
    sheet.getRangeByIndex(totalRow, 1).cellStyle.bold = true;
    sheet.getRangeByIndex(totalRow, 2).cellStyle = currencyStyle;
    sheet.getRangeByIndex(totalRow, 2).cellStyle.bold = true;

    // Border semua
    final lastRow = groupedKaryawan.length + 2;
    final tableRange = sheet.getRangeByName('A1:B$lastRow');
    tableRange.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;

    final bytes = workbook.saveAsStream();
    workbook.dispose();

    final namaFile = 'data_total_profit_${selectedBulan ?? 'semua'}_${selectedTahun ?? 'semua'}.xlsx';

    if (kIsWeb) {
      final blob = html.Blob([Uint8List.fromList(bytes)]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", namaFile)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      bool permissionGranted = false;

      if (Platform.isAndroid) {
        var status = await Permission.manageExternalStorage.status;
        if (!status.isGranted) {
          status = await Permission.manageExternalStorage.request();
        }
        permissionGranted = status.isGranted;
      } else {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
        permissionGranted = status.isGranted;
      }

      if (!permissionGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Izin penyimpanan tidak diberikan')),
        );
        return;
      }

      try {
        final dir = await getExternalStorageDirectory();
        String newPath = "";
        List<String> folders = dir!.path.split("/");
        for (int i = 1; i < folders.length; i++) {
          String folder = folders[i];
          if (folder == "Android") break;
          newPath += "/$folder";
        }
        newPath += "/Download";
        final path = '$newPath/$namaFile';

        final file = File(path);
        await file.writeAsBytes(bytes, flush: true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil diekspor ke: $path')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan file: $e')),
        );
      }
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  Widget headerLabel(String text) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.indigo.shade600,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text('Data Karyawan'),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: logout,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
              : Center(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 8,
                        shadowColor: Colors.black12,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Filter Data',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),

                              /// BULAN
                              Row(
                                children: [
                                  const Icon(Icons.date_range_outlined, color: Colors.indigo),
                                  const SizedBox(width: 8),
                                  const Text('Filter Bulan', style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                hint: const Text('Pilih Bulan'),
                                value: selectedBulan,
                                isExpanded: true,
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    child: Text('Semua Bulan'),
                                  ),
                                  ...namaBulan.map((bulan) {
                                    return DropdownMenuItem<String>(
                                      value: bulan,
                                      child: Text(bulan),
                                    );
                                  }).toList(),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedBulan = value;
                                    updateDataSource();
                                  });
                                },
                              ),

                              const SizedBox(height: 16),

                              /// TAHUN
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, color: Colors.indigo),
                                  const SizedBox(width: 8),
                                  const Text('Filter Tahun', style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                hint: const Text('Pilih Tahun'),
                                value: selectedTahun,
                                isExpanded: true,
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    child: Text('Semua Tahun'),
                                  ),
                                  ...tahunList.map((tahun) {
                                    return DropdownMenuItem<String>(
                                      value: tahun,
                                      child: Text(tahun),
                                    );
                                  }).toList(),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedTahun = value;
                                    updateDataSource();
                                  });
                                },
                              ),

                              const SizedBox(height: 24),

                              /// EXPORT BUTTON
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  onPressed: exportToExcel,
                                  icon: const Icon(Icons.file_download),
                                  label: const Text('Export ke Excel'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),
                              // /// TABEL
                              // const Text(
                              //   'Rekapitulasi Total Profit per Karyawan',
                              //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              // ),
                              const SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      spreadRadius: 2,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                height: 400,
                                child: SfDataGrid(
                                  allowSorting: true,
                                  source: _dataSource,
                                  columnWidthMode: ColumnWidthMode.fill,
                                  columns: [
                                    GridColumn(columnName: 'nama', label: headerLabel('Nama')),
                                    GridColumn(columnName: 'total_profit', label: headerLabel('Total Profit')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
