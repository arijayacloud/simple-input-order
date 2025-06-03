class Karyawan {
  final int id;
  final String nama;
  final double hargaJual;
  final double modal;

  Karyawan({
    required this.id,
    required this.nama,
    required this.hargaJual,
    required this.modal,
  });

  factory Karyawan.fromJson(Map<String, dynamic> json) {
    return Karyawan(
      id: json['id'],
      nama: json['nama'],
      hargaJual: double.parse(json['harga_jual'].toString()),
      modal: double.parse(json['modal'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'harga_jual': hargaJual,
    'modal': modal,
  };
}