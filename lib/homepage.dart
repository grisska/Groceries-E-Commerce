import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:groceries_commerce/cart_page.dart';
import 'package:groceries_commerce/menu_page.dart';
import 'login_page.dart'; // Import halaman login

// Definisikan kelas Product
class Product {
  final String name;
  final double price;
  final String imageUrl;
  final String description; // Tambahkan deskripsi produk

  Product(this.name, this.price, this.imageUrl, this.description);
}

// Definisikan kelas CartItem
class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required List cartItems}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<CartItem> cartItems = [];

  final List<String> imgList = [
    'assets/Sayur.jpg',
    'assets/promo sayur.png',
    'assets/Groceries.png'
  ];

  final Map<String, List<Map<String, dynamic>>> categoryProducts = {
    "Daging": [
      {
        "name": "Daging Sapi",
        "image": "assets/daging_sapi.jpg",
        "price": 120000.0,
        "description":
            "Produk ini umumnya digunakan dalam berbagai masakan, seperti steak, rendang, bakso, dan sup. Daging sapi memiliki nilai gizi tinggi, kaya akan protein, zat besi, dan vitamin B12, yang penting untuk kesehatan tubuh."
      },
      {
        "name": "Daging Ayam",
        "image": "assets/daging_ayam.jpg",
        "price": 35000.0,
        "description":
            "Daging ayam adalah salah satu sumber protein hewani yang paling umum dikonsumsi. Daging ayam kaya akan protein, rendah lemak, dan mengandung sejumlah nutrisi penting seperti vitamin B, selenium, fosfor, dan zat besi."
      },
    ],
    "Sayur": [
      {
        "name": "Brokoli",
        "image": "assets/brokoli.jpg",
        "price": 25000.0,
        "description":
            "Brokoli adalah sayuran hijau yang terdiri dari kembang kol kecil yang dikenal sebagai kepala brokoli. Kaya akan serat, vitamin C, vitamin K, dan antioksidan, brokoli merupakan makanan yang sehat dan serbaguna dalam berbagai resep masakan."
      },
      {
        "name": "Bayam",
        "image": "assets/bayam.jpg",
        "price": 15000.0,
        "description":
            "Bayam dapat dimakan mentah sebagai salad, dimasak sebagai lauk, atau digunakan dalam berbagai masakan seperti sup, tumis, dan smoothie. Bayam dikenal karena manfaat kesehatannya, termasuk mendukung kesehatan mata, tulang, dan sistem kekebalan tubuh."
      },
      {
        "name": "Sarden",
        "image": "assets/sarden.jpg",
        "price": 18000.0,
        "description":
            "Sarden adalah ikan yang biasanya disajikan dalam kaleng dengan tambahan minyak atau saus tomat. Produk sarden merupakan sumber protein yang mudah disiapkan dan sering digunakan dalam hidangan pasta, salad, atau dimakan langsung."
      },
      {
        "name": "Jus Jeruk",
        "image": "assets/jus_jeruk.jpg",
        "price": 10000.0,
        "description":
            "Jus jeruk adalah minuman yang terbuat dari perasan buah jeruk segar. Kaya akan vitamin C dan antioksidan, jus jeruk adalah minuman yang menyegarkan dan menyehatkan. Biasanya dikonsumsi sebagai minuman sarapan atau sebagai penyegar di siang hari."
      },
    ],
    // Sisipkan data untuk kategori lainnya dengan format yang sama
  };

  late TextEditingController searchController;
  late List<Product> filteredProducts;
  
  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    filteredProducts = _getAllProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Fungsi untuk mendapatkan semua produk
  List<Product> _getAllProducts() {
    List<Product> allProducts = [];
    categoryProducts.values.forEach((categoryList) {
      categoryList.forEach((productMap) {
        String name = productMap['name']!;
        String image = productMap['image']!;
        double price = productMap ['price']!;
        String description = productMap['description']!;
        allProducts.add(Product(name, price, image, description));
      });
    });
    return allProducts;
  }

  // Fungsi untuk melakukan pencarian produk
  void _performSearch(String query) {
    setState(() {
      filteredProducts = _getAllProducts().where((product) => product.name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  // Fungsi untuk menangani navigasi bottom navigation bar
  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MenuPage()),
      );
    } else if (index == 2) {
      Navigator.pushNamed(context, '/profile');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Fungsi untuk menampilkan detail produk dalam dialog
  void _showProductDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product.name),
          content: SingleChildScrollView(
            child:              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Description:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    product.description,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add logout logic here
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Groceries E-Commerce',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 0,
        leading: IconButton(
          icon: ImageIcon(
            AssetImage('assets/logout.png'),
            size: 30, // Ukuran ikon diperbesar
            color: Colors.white, // Ubah warna ikon menjadi putih
          ),
          onPressed: () {
            _showLogoutDialog(context);
          },
        ),
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: OvalClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              color: Colors.green[100],
            ),
          ),
          Column(
            children: [
              SizedBox(height: 30),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: _performSearch,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
                items: imgList.map((item) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.asset(item, fit: BoxFit.cover, width: 1000),
                  ),
                )).toList(),
              ),
              SizedBox(height: 20),
              Text(
                'Product Recommendations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  padding: EdgeInsets.all(10.0),
                  children: filteredProducts.map((product) {
                    return GestureDetector(
                      onTap: () {
                        _showProductDetails(context, product);
                      },
                      child: ProductItem(product),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category), // Ubah ikon menu menjadi categories
            label: 'Categories', // Ganti tulisan menu menjadi categories
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
           label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[700],
        onTap: _onItemTapped,
      ),
    );
  }
}

class OvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(size.width / 2, size.height * 0.5, size.width, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(product.imageUrl, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 10),
          Text(
            product.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            'Rp${product.price.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


