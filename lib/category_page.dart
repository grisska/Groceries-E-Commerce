import 'package:flutter/material.dart';
import 'package:groceries_commerce/cart_page.dart';
import 'package:provider/provider.dart';
import 'package:groceries_commerce/cart_provider.dart';

class CategoryPage extends StatelessWidget {
  final String categoryName;
  final List<Map<String, String>> products;

  const CategoryPage({required this.categoryName, required this.products, Key? key}) : super(key: key);

  void addToCart(BuildContext context, String id, String name, double price, String imageUrl) {
    Provider.of<CartProvider>(context, listen: false).addItem(id, name, price, imageUrl);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name has been added to the cart!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
        ),
        backgroundColor: Colors.green[700],
        centerTitle: true, // Teks berada di tengah AppBar
        iconTheme: IconThemeData(color: Colors.white), // Ubah warna ikon menjadi putih
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns
          crossAxisSpacing: 10, // Spacing between columns
          mainAxisSpacing: 10, // Spacing between rows
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final price = double.tryParse(product['price']!.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;

          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Rounded corners
            ),
            child: InkWell(
              onTap: () {
                // Add onTap functionality if needed
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            product['image']!,
                            fit: BoxFit.cover, // Fill the width of the card
                            width: double.infinity, // Ensure full width
                            height: 150, // Fixed height
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black.withOpacity(0.3), // Overlay color
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            color: Colors.black.withOpacity(0.5), // Background color for text
                            child: Text(
                              product['name']!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14, // Adjust text size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      product['price']!,
                      style: TextStyle(
                        fontSize: 14, // Adjust text size
                        color: Colors.green[700], // Price text color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        addToCart(context, product['image']!, product['name']!, price, product['image']!);
                      },
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green[700],
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
