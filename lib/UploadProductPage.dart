import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadProductPage extends StatefulWidget {
  @override
  _UploadProductPageState createState() => _UploadProductPageState();
}

class _UploadProductPageState extends State<UploadProductPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  String? _imageUrl;

  Future<void> _uploadProduct() async {
    if (_namaController.text.isEmpty || _hargaController.text.isEmpty || _deskripsiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Harap isi semua data")),
      );
      return;
    }

    try {
      final response = await supabase.from('barang').insert({
        'nama_barang': _namaController.text,
        'harga': int.tryParse(_hargaController.text) ?? 0,
        'deskripsi': _deskripsiController.text,
        'gambar_url': _imageUrl,
      });

      if (response.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Produk berhasil diunggah")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan produk: ${response.error!.message}")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Produk")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _namaController, decoration: InputDecoration(labelText: "Nama Barang")),
            TextField(controller: _hargaController, decoration: InputDecoration(labelText: "Harga"), keyboardType: TextInputType.number),
            TextField(controller: _deskripsiController, decoration: InputDecoration(labelText: "Deskripsi")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadProduct,
              child: Text("Unggah Produk"),
            ),
          ],
        ),
      ),
    );
  }
}
