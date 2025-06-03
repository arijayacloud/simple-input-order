import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

import 'karyawan_page.dart';

final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

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
      cells: row.getCells().map((dataCell) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: Text(
            dataCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
