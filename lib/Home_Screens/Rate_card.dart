import 'package:flutter/material.dart';

class RateCardPage extends StatelessWidget {
  final List<Map<String, String>> rateItems = [
    {'title': 'Newspapers', 'price': '₹12/kg', 'image': 'assets/newspapers.png'},
    {'title': 'Plastic Bottles', 'price': '₹10/kg', 'image': 'assets/plastic_bottles.png'},
    {'title': 'Aluminum Cans', 'price': '₹28/kg', 'image': 'assets/aluminum_cans.png'},
    {'title': 'E-Waste', 'price': '₹50/kg', 'image': 'assets/e_waste.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rate Card"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.0,
          ),
          itemCount: rateItems.length,
          itemBuilder: (context, index) {
            final item = rateItems[index];
            return _buildRateCard(
              title: item['title']!,
              price: item['price']!,
              image: item['image']!,
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.refresh), label: "Recycle"),
        ],
        onTap: (index) {
          // Handle navigation actions
        },
      ),
    );
  }

  Widget _buildRateCard({required String title, required String price, required String image}) {
    return GestureDetector(
      onTap: () {
        // Handle individual rate card click
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(12.0),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                price,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
