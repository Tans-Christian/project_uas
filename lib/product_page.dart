import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductPage extends StatefulWidget {
  final Map<String, dynamic> barang;

  ProductPage({required this.barang});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late List<String> imageList;

  @override
  void initState() {
    super.initState();
    // Ambil daftar gambar, maksimal 10
    imageList = List<String>.from(widget.barang['gambar_list']?['images'] ?? []);
    if (widget.barang['gambar_url'] != null) {
      imageList.insert(0, widget.barang['gambar_url']); // Masukkan gambar utama pertama
    }
    imageList = imageList.take(10).toList(); // Batasi hingga 10 gambar
  }

  void _showFullImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.barang['nama_barang'])),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Utama yang Bisa Diklik
            Center(
              child: GestureDetector(
                onTap: () => _showFullImage(imageList[0]),
                child: Image.network(
                  imageList[0],
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.barang['nama_barang'],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Rp ${widget.barang['harga']}",
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            SizedBox(height: 16),
            Text(
              "Deskripsi:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              widget.barang['deskripsi'] ?? "Tidak ada deskripsi",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Galeri Gambar Lain
            if (imageList.length > 1) ...[
              Text(
                "Gambar Lain:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageList.length - 1,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _showFullImage(imageList[index + 1]),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        child: Image.network(
                          imageList[index + 1],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.image_not_supported, size: 50),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
            ],

            // File Produk (Jika Ada)
            if (widget.barang['file_url'] != null &&
                widget.barang['file_url'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "File Produk:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final Uri url = Uri.parse(widget.barang['file_url']);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Gagal membuka file")),
                        );
                      }
                    },
                    icon: Icon(Icons.download),
                    label: Text("Download File"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// Halaman Fullscreen untuk Melihat Gambar
class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 3.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.image_not_supported, size: 100, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
