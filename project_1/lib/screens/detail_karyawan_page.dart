import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailKaryawanPage extends StatefulWidget {
  final String namaKaryawan;

  const DetailKaryawanPage({super.key, required this.namaKaryawan});

  @override
  State<DetailKaryawanPage> createState() => _DetailKaryawanPageState();
}

class _DetailKaryawanPageState extends State<DetailKaryawanPage> {
  final TextEditingController _hargaJualController = TextEditingController();
  final TextEditingController _modalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEditing = false;

  final _formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  String _unformatRupiah(String text) {
    return text.replaceAll(RegExp(r'[^0-9]'), '');
  }

  Future<void> _simpanData(double hargaJual, double modal) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://192.168.1.5:8000/api/karyawans');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': widget.namaKaryawan,
        'harga_jual': hargaJual,
        'modal': modal,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: ${response.body}')),
      );
    }
  }

  void _formatCurrency(TextEditingController controller) {
    final text = controller.text;
    final unformatted = _unformatRupiah(text);
    if (unformatted.isEmpty) {
      controller.text = '';
      return;
    }
    final number = int.parse(unformatted);
    controller.value = TextEditingValue(
      text: _formatter.format(number),
      selection: TextSelection.collapsed(
        offset: _formatter.format(number).length,
      ),
    );
  }

  Future<void> _konfirmasiSimpanData() async {
    if (!_formKey.currentState!.validate()) return;

    final hargaJual = double.parse(_unformatRupiah(_hargaJualController.text));
    final modal = double.parse(_unformatRupiah(_modalController.text));

    final formattedHargaJual = _formatter.format(hargaJual);
    final formattedModal = _formatter.format(modal);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Konfirmasi',
      pageBuilder: (context, animation, secondaryAnimation) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
            Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_outline,
                          size: 48, color: Colors.green),
                      const SizedBox(height: 12),
                      const Text(
                        'Konfirmasi Data',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.namaKaryawan,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Harga Jual:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(formattedHargaJual),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Modal:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(formattedModal),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Kembali'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 120,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      Navigator.pop(context);
                                      await _simpanData(hargaJual, modal);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: const Text('Benar'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeInOut.transform(animation.value);
        return Transform.translate(
          offset: Offset(0, (1 - curvedValue) * 200),
          child: Opacity(opacity: animation.value, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _hargaJualController.dispose();
    _modalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          widget.namaKaryawan,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _isEditing ? _buildForm() : _buildButtons(),
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Tambah Harga Jual & Modal',
                style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _hargaJualController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Harga Jual',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _formatCurrency(_hargaJualController),
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  _unformatRupiah(value).isEmpty) {
                return 'Harga Jual harus diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _modalController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Modal',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _formatCurrency(_modalController),
            validator: (value) {
              if (value == null || value.isEmpty || _unformatRupiah(value).isEmpty) {
                return 'Modal harus diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 120,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _konfirmasiSimpanData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Simpan'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}