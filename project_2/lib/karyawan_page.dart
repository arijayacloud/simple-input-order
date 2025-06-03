import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Format uang
final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

// Model
class Karyawan {
  final String nama;
  final double hargaJual;
  final double modal;
  final double totalProfit;

  Karyawan({
    required this.nama,
    required this.hargaJual,
    required this.modal,
    required this.totalProfit,
  });
}

// DataSource untuk Syncfusion DataGrid
class KaryawanDataSource extends DataGridSource {
  final List<DataGridRow> _karyawanRows;

  KaryawanDataSource({required List<Karyawan> karyawans})
      : _karyawanRows = karyawans.map<DataGridRow>((k) {
          return DataGridRow(cells: [
            DataGridCell<String>(columnName: 'nama', value: k.nama),
            DataGridCell<String>(columnName: 'harga_jual', value: currencyFormat.format(k.hargaJual)),
            DataGridCell<String>(columnName: 'modal', value: currencyFormat.format(k.modal)),
            DataGridCell<String>(columnName: 'total_profit', value: currencyFormat.format(k.totalProfit)),
          ]);
        }).toList();

  @override
  List<DataGridRow> get rows => _karyawanRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: Colors.white, // Warna latar belakang baris
      cells: row.getCells().map((dataCell) {
        return Container(
          padding: const EdgeInsets.all(12.0), // Padding yang lebih besar
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1), // Border bawah
            ),
          ),
          child: Text(
            dataCell.value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black), // Gaya teks
          ),
        );
      }).toList(),
    );
  }
}

// Halaman Utama
class KaryawanPage extends StatefulWidget {
  final String token;

  const KaryawanPage({super.key, required this.token});

  @override
  State<KaryawanPage> createState() => _KaryawanPageState();
}

class _KaryawanPageState extends State<KaryawanPage> {
  late KaryawanDataSource _karyawanDataSource;
  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchKaryawan();
  }

  Future<void> fetchKaryawan() async {
    final url = Uri.parse('http://192.168.1.5:8000/api/admin/karyawans');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final List<Karyawan> karyawans = data.map((item) {
          return Karyawan(
            nama: item['nama'] ?? '',
            hargaJual: double.tryParse(item['harga_jual'].toString()) ?? 0,
            modal: double.tryParse(item['modal'].toString()) ?? 0,
            totalProfit: double.tryParse(item['total_profit'].toString()) ?? 0,
          );
        }).toList();

        setState(() {
          _karyawanDataSource = KaryawanDataSource(karyawans: karyawans);
          loading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Gagal mengambil data (${response.statusCode})';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Karyawan')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : SfDataGrid(
                  source: _karyawanDataSource,
                  columnWidthMode: ColumnWidthMode.fill,
                  columns: [
                    GridColumn(
                      columnName: 'nama',
                      label: Container(
                        padding: const EdgeInsets.all(12.0), // Padding yang lebih besar
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100, // Warna latar belakang header
                          border: Border(
                            bottom: BorderSide(color: Colors.blue, width: 2), // Border bawah header
                          ),
                        ),
                        child: const Text('Nama', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'harga_jual',
                      label: Container(
                        padding: const EdgeInsets.all(12.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          border: Border(
                            bottom: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        child: const Text('Harga Jual', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'modal',
                      label: Container(
                        padding: const EdgeInsets.all(12.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          border: Border(
                            bottom: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        child: const Text('Modal', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'total_profit',
                      label: Container(
                        padding: const EdgeInsets.all(12.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          border: Border(
                            bottom: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        child: const Text('Untung', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
    );
  }
}