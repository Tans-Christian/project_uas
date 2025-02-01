import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'product_page.dart';
import 'UploadProductPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final List<dynamic> response = await supabase.from('barang').select();
      setState(() {
        _products = response.map((item) => Map<String, dynamic>.from(item)).toList();
        _isLoading = false;
      });
    } catch (error) {
      print("Error fetching products: $error");
    }
  }

  void _navigateToProductDetail(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductPage(barang: product)),
    );
  }

  void _navigateToUploadProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UploadProductPage()),
    ).then((_) => _fetchProducts()); // Refresh data setelah upload
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Produk")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? Center(child: Text("Belum ada produk."))
              : ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: product['gambar_url'] != null
                            ? Image.network(
                                product['gambar_url'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image_not_supported, size: 60),
                        title: Text(product['nama_barang']),
                        subtitle: Text("Rp ${product['harga']}"),
                        onTap: () => _navigateToProductDetail(product),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToUploadProduct,
        child: Icon(Icons.add),
      ),
    );
  }
}
