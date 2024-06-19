import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:groceries_commerce/cart_provider.dart';
import 'package:groceries_commerce/checkout_page.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.white, // Memberikan warna putih pada tulisan "Your Cart"
          ),
        ),
        centerTitle: true, // Menempatkan tulisan "Your Cart" di tengah AppBar
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Mengubah warna ikon kembali (back) menjadi putih
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, i) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 5,
                child: ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        cartItems[i].imageUrl, // Ensure this matches the product's imageUrl
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    cartItems[i].title,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    'Price: \$${cartItems[i].price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black54,
                    ),
                  ),
                  trailing: Container(
                    width: 130,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                          onPressed: () {
                            cart.removeItem(cartItems[i].id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("${cartItems[i].title} removed")),
                            );
                          },
                        ),
                        Text(
                          '${cartItems[i].quantity}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline, color: Colors.greenAccent),
                          onPressed: () {
                            cart.addItem(
                              cartItems[i].id,
                              cartItems[i].title,
                              cartItems[i].price,
                              cartItems[i].imageUrl, // Ensure this matches the product's imageUrl
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("${cartItems[i].title} added")),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    List<Map<String, dynamic>> cartItemList = cartItems.map((item) => {
                      'id': item.id,
                      'title': item.title,
                      'price': item.price,
                    }).toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(cartItems: cartItemList, totalAmount: cart.totalAmount),
                      ),
                    );
                  },
                  icon: Icon(Icons.payment, color: Colors.white), // Pembenaran untuk membuat ikon berwarna putih
                  label: Text('Checkout', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    textStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
