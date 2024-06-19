import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;

  const CheckoutPage({
    Key? key,
    required this.cartItems,
    required this.totalAmount,
  }) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _credentialController = TextEditingController();
  String? selectedShippingService;
  String? selectedPaymentMethod;
  String? selectedBankOrWallet;
  String transactionCode = '';
  String? selectedProvinceId;
  String? selectedCityId;
  String? selectedDistrictId;
  List<Map<String, String>> provinces = [];
  List<Map<String, String>> cities = [];
  List<Map<String, String>> districts = [];
  double shippingCost = 0.0;

  Future<void> _getProvinces() async {
    final response = await http.get(
      Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json'),
    );
    final List<dynamic> decodedResponse = json.decode(response.body);
    setState(() {
      provinces = decodedResponse
          .map<Map<String, String>>((province) => {
                'id': province['id'].toString(),
                'name': province['name'].toString(),
              })
          .toList();
    });
  }

  Future<void> _getCities(String provinceId) async {
    final response = await http.get(
      Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/regencies/$provinceId.json'),
    );
    final List<dynamic> decodedResponse = json.decode(response.body);
    setState(() {
      cities = decodedResponse
          .map<Map<String, String>>((city) => {
                'id': city['id'].toString(),
                'name': city['name'].toString(),
              })
          .toList();
    });
  }

  Future<void> _getDistricts(String cityId) async {
    final response = await http.get(
      Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/districts/$cityId.json'),
    );
    final List<dynamic> decodedResponse = json.decode(response.body);
    setState(() {
      districts = decodedResponse
          .map<Map<String, String>>((district) => {
                'id': district['id'].toString(),
                'name': district['name'].toString(),
              })
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    double totalOrderAmount = widget.totalAmount + shippingCost; // Total keseluruhan termasuk biaya pengiriman

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: TextStyle(color: Colors.white)), // Tulisan "Checkout" berwarna putih
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Ikon kembali berwarna putih
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Shipping Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: provinces.map((province) {
                return DropdownMenuItem<String>(
                  value: province['id'],
                  child: Text(province['name']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProvinceId = value;
                  selectedCityId = null;
                  selectedDistrictId = null;
                  cities = [];
                  districts = [];
                  shippingCost = 0.0; // Reset biaya pengiriman ketika provinsi berubah
                  _getCities(selectedProvinceId!);
                });
              },
              value: selectedProvinceId,
              hint: Text('Select province'),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: cities.map((city) {
                return DropdownMenuItem<String>(
                  value: city['id'],
                  child: Text(city['name']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCityId = value;
                  selectedDistrictId = null;
                  districts = [];
                  _getDistricts(selectedCityId!);
                });
              },
              value: selectedCityId,
              hint: Text('Select city'),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: districts.map((district) {
                return DropdownMenuItem<String>(
                  value: district['id'],
                  child: Text(district['name']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrictId = value;
                });
              },
              value: selectedDistrictId,
              hint: Text('Select district'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your address',
              ),
            ),
            SizedBox(height: 20),
            Text('Shipping Service', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: ['JNE', 'TIKI', 'POS Indonesia'].map((service) {
                return DropdownMenuItem<String>(
                  value: service,
                  child: Text(service),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedShippingService = value!;
                  // Ganti biaya pengiriman berdasarkan layanan pengiriman yang dipilih
                  if (selectedShippingService == 'JNE') {
                    shippingCost = 10.0;
                  } else if (selectedShippingService == 'TIKI') {
                    shippingCost = 12.0;
                  } else if (selectedShippingService == 'POS Indonesia') {
                    shippingCost = 8.0;
                  }
                });
              },
              value: selectedShippingService,
              hint: Text('Select shipping service'),
            ),
            SizedBox(height: 20),
            Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: ['Bank Transfer', 'E-Wallet'].map((method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                  selectedBankOrWallet = null;
                  _credentialController.clear();
                });
              },
              value: selectedPaymentMethod,
              hint: Text('Select payment method'),
            ),
            if (selectedPaymentMethod != null) SizedBox(height: 20),
            if (selectedPaymentMethod != null)
              Text(
                '${selectedPaymentMethod == 'Bank Transfer' ? 'Bank' : 'E-Wallet'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            if (selectedPaymentMethod != null) SizedBox(height: 10),
            if (selectedPaymentMethod != null)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(border: OutlineInputBorder()),
                items: selectedPaymentMethod == 'Bank Transfer'
                    ? ['BCA', 'BNI', 'Mandiri'].map((bank) {
                        return DropdownMenuItem<String>(
                          value: bank,
                          child: Text(bank),
                        );
                      }).toList()
                    : ['OVO', 'GoPay', 'Dana'].map((wallet) {
                        return DropdownMenuItem<String>(
                          value: wallet,
                          child: Text(wallet),
                        );
                      }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBankOrWallet = value!;
                  });
                },
                value: selectedBankOrWallet,
                hint: Text('Select ${selectedPaymentMethod == 'Bank Transfer' ? 'bank' : 'e-wallet'}'),
              ),
            if (selectedBankOrWallet != null) SizedBox(height: 20),
            if (selectedBankOrWallet != null)
              TextField(
                controller: _credentialController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: selectedPaymentMethod == 'Bank Transfer' ? 'Enter your bank account number' : 'Enter your phone number',
                ),
              ),
            SizedBox(height: 20),
            Text('Total Amount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Rp ${totalOrderAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_addressController.text.isEmpty ||
                    selectedShippingService == null ||
                    selectedPaymentMethod == null ||
                    selectedBankOrWallet == null ||
                    _credentialController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please fill all the fields.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }
                setState(() {
                  transactionCode = 'TRX${DateTime.now().millisecondsSinceEpoch}';
                });
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Order Placed', style: TextStyle(color: Colors.white)), // Tulisan "Order Placed" berwarna putih
                      content: Text('Your order has been placed successfully!\nTransaction Code: $transactionCode', style: TextStyle(color: Colors.white)), // Tulisan transaction code berwarna putih
                      backgroundColor: Colors.green, // Latar belakang dialog berwarna hijau
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('OK', style: TextStyle(color: Colors.white)), // Tulisan tombol "OK" berwarna putih
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Place Order', style: TextStyle(color: Colors.white)), // Tulisan "Place Order" berwarna putih
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
