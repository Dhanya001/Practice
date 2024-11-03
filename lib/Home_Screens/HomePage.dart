import 'package:demo/Home_Screens/Rate_card.dart';
import 'package:demo/Utlity/widget_helper.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            MyMediumText(title: "Munich Center", isBold: true),
            Icon(Icons.arrow_drop_down),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Section
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyMediumText(
                      title: "Turn your scrap into cash!",
                      isBold: true,
                    ),
                    SizedBox(height: 8.0),
                    MySmallText(title: "Schedule a pickup today and make recycling effortless."),
                    SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RateCardPage()));
                      },
                      child: MySmallText(title: "Schedule Pickup Now", isBold: true),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),

              // Statistics Section
              MyMediumText(title: "Statistics", isBold: true),
              SizedBox(height: 8.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStatisticCard("Scrap Collected", "145 kg", Icons.recycling, HomePage()),
                    _buildStatisticCard("Wallet Balance", "₹1200", Icons.account_balance_wallet, RateCardPage()),
                    _buildStatisticCard("Completed", "10", Icons.check_circle, HomePage()),
                  ],
                ),
              ),
              SizedBox(height: 16.0),

              // Categories Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyMediumText(title: "Products By Category", isBold: true),
                  TextButton(
                    onPressed: () {
                      // Navigate to see all categories
                    },
                    child: MySmallText(title: "See All", color: Colors.blue),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryCard("Category 1", HomePage()),
                    _buildCategoryCard("Category 2", RateCardPage()),
                    _buildCategoryCard("Category 3", HomePage()),
                    _buildCategoryCard("Category 4", RateCardPage()),
                    _buildCategoryCard("Category 5", HomePage()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }

  Widget _buildStatisticCard(String title, String value, IconData icon, Widget destination) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.only(right: 16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 8.0),
            MyBigText(title: value, isBold: true),
            MySmallText(title: title),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String category, Widget destination) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
      },
      child: Container(
        width: 100,
        margin: EdgeInsets.only(right: 16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(height: 8.0),
            MySmallText(title: category),
          ],
        ),
      ),
    );
  }
}



