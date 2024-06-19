import 'package:flutter/material.dart';
import 'category_page.dart';

class MenuPage extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {"name": "Daging", "image": "assets/daging.jpg"},
    {"name": "Sayur", "image": "assets/sayur.jpg"},
    {"name": "Buah", "image": "assets/buah.jpg"},
    {"name": "Susu", "image": "assets/susu.jpg"},
    {"name": "Makanan Beku", "image": "assets/makananbeku.jpg"},
    {"name": "Minuman", "image": "assets/minuman.jpg"},
    {"name": "Bumbu Dapur", "image": "assets/bumbudapur.jpg"},
    {"name": "Roti & Kue", "image": "assets/roti.jpg"},
    {"name": "Makanan Ringan", "image": "assets/makananringan.jpg"},
    {"name": "Makanan Kaleng", "image": "assets/makanankaleng.jpg"},
  ];

  final Map<String, List<Map<String, String>>> categoryProducts = {
    "Daging": [
      {"name": "Daging Sapi", "image": "assets/daging_sapi.jpg", "price": "Rp 120.000/kg"},
      {"name": "Daging Ayam", "image": "assets/daging_ayam.jpg", "price": "Rp 35.000/kg"},
    ],
    "Sayur": [
      {"name": "Bayam", "image": "assets/bayam.jpg", "price": "Rp 10.000/kg"},
      {"name": "Brokoli", "image": "assets/brokoli.jpg", "price": "Rp 8.000/kg"},
    ],
    "Buah": [
      {"name": "Apel", "image": "assets/apel.jpg", "price": "Rp 25.000/kg"},
      {"name": "Pisang", "image": "assets/pisang.jpg", "price": "Rp 15.000/kg"},
    ],
    "Susu": [
      {"name": "Susu Kental Manis", "image": "assets/susu_kental_manis.jpg", "price": "Rp 15.000/liter"},
      {"name": "Susu UHT", "image": "assets/susu_uht.jpg", "price": "Rp 20.000/liter"},
    ],
    "Makanan Beku": [
      {"name": "Nugget Ayam", "image": "assets/nugget_ayam.jpg", "price": "Rp 25.000/kg"},
      {"name": "Kentang", "image": "assets/kentang_beku.jpeg", "price": "Rp 30.000/kg"},
    ],
    "Minuman": [
      {"name": "Jus Jeruk", "image": "assets/jus_jeruk.jpg", "price": "Rp 5.000/botol"},
      {"name": "Air Mineral", "image": "assets/air_mineral.jpg", "price": "Rp 10.000/cup"},
    ],
    "Bumbu Dapur": [
      {"name": "Lada", "image": "assets/lada.jpg", "price": "Rp 2.000/pack"},
      {"name": "Garam", "image": "assets/garam.jpg", "price": "Rp 3.000/pack"},
    ],
    "Roti & Kue": [
      {"name": "Roti Tawar", "image": "assets/roti_tawar.jpg", "price": "Rp 10.000/loaf"},
      {"name": "Kue Brownies", "image": "assets/brownies.jpg", "price": "Rp 15.000/box"},
    ],
    "Makanan Ringan": [
      {"name": "Keripik Kentang", "image": "assets/keripik_kentang.jpg", "price": "Rp 5.000/pack"},
      {"name": "Cokelat", "image": "assets/cokelat.jpg", "price": "Rp 50.000/kg"},
    ],
    "Makanan Kaleng": [
      {"name": "Sarden", "image": "assets/sarden.jpg", "price": "Rp 10.000/can"},
      {"name": "Kornet", "image": "assets/kornet.jpg", "price": "Rp 8.000/can"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Categories',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryPage(
                        categoryName: categories[index]['name']!,
                        products: categoryProducts[categories[index]['name']]!,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: AssetImage(categories[index]['image']!),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4),
                        BlendMode.dstATop,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(categories[index]['image']!),
                      radius: 30,
                    ),
                    title: Text(
                      categories[index]['name']!,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
