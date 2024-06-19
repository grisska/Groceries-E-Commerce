import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  final List<Map<String, dynamic>> orders;

  const OrdersPage({Key? key, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: orders.isEmpty
          ? Center(
              child: Text('You have not placed any orders yet.'),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  title: Text('Order #${index + 1}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${order['date']}'),
                      Text('Total: \$${order['total'].toStringAsFixed(2)}'),
                      Text('Items:'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (order['items'] as List<Map<String, dynamic>>)
                            .map<Widget>((item) => Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    '- ${item['title']} (\$${item['price'].toStringAsFixed(2)})',
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
