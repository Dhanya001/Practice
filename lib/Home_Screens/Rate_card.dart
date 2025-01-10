import 'package:flutter/material.dart';

class OrderDieselPage extends StatefulWidget {
  @override
  _OrderDieselPageState createState() => _OrderDieselPageState();
}

class _OrderDieselPageState extends State<OrderDieselPage> {
  // Dropdown options
  final List<String> purposes = ["Generator", "Vehicle", "Agriculture", "Other"];
  final List<String> quantities = ["10L", "20L", "50L", "100L", "Custom"];

  // Selected values
  String? selectedPurpose;
  String? selectedQuantity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Diesel'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Purpose dropdown
            Text(
              "Purpose of Diesel",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedPurpose,
              hint: Text("Select Purpose"),
              items: purposes.map((purpose) {
                return DropdownMenuItem(
                  value: purpose,
                  child: Text(purpose),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPurpose = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Quantity dropdown
            Text(
              "Select Quantity",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedQuantity,
              hint: Text("Select Quantity"),
              items: quantities.map((qty) {
                return DropdownMenuItem(
                  value: qty,
                  child: Text(qty),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedQuantity = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            Spacer(),

            // Next button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedPurpose != null && selectedQuantity != null
                    ? () {
                        // Navigate to the next page or perform an action
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Order placed successfully!"),
                          ),
                        );
                      }
                    : null, // Disable button if no selection
                child: Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
