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
            Icon(Icons.arrow_drop_down),
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


import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePickUpPage extends StatefulWidget {
  @override
  _SchedulePickUpPageState createState() => _SchedulePickUpPageState();
}

class _SchedulePickUpPageState extends State<SchedulePickUpPage> {
  DateTime _selectedDay = DateTime.now();
  int? _selectedSlotIndex;

  final List<String> _timeSlots = [
    "09:00 AM - 12:00 PM",
    "01:00 PM - 04:00 PM",
    "05:00 PM - 08:00 PM",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Schedule Pick Up"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pick Up Date & Time-slots",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            // Calendar
            TableCalendar(
              firstDay: DateTime.utc(2022, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _selectedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.green.shade200,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Pick a slot",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Time slots
            Column(
              children: List.generate(_timeSlots.length, (index) {
                return RadioListTile<int>(
                  value: index,
                  groupValue: _selectedSlotIndex,
                  onChanged: (value) {
                    setState(() {
                      _selectedSlotIndex = value;
                    });
                  },
                  title: Text(_timeSlots[index]),
                  activeColor: Colors.green,
                );
              }),
            ),
            const Spacer(),
            // Next button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () {
                  // Handle Next button press
                },
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PickUpSummaryPage extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedSlot;
  final List<String> selectedItems = [
    "Office Papers",
    "Cardboard Boxes",
    "Magazines",
    "Office Papers",
    "Cardboard Boxes",
    "Magazines",
    "Office Papers",
    "Cardboard Boxes",
  ];

  PickUpSummaryPage({required this.selectedDate, required this.selectedSlot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Schedule Pick Up"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pick Up Summary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            // Selected Date and Slot
            Text(
              "${selectedDate.day} ${_monthName(selectedDate.month)} ${selectedDate.year}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              selectedSlot,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            // Selected Items Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedItems.map((item) {
                return Chip(
                  label: Text(item),
                  backgroundColor: Colors.green.shade100,
                  avatar: Icon(Icons.insert_drive_file, size: 18),
                  deleteIcon: Icon(Icons.close, size: 18),
                  onDeleted: () {
                    // Handle delete action for each chip
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Estimated Weight
            const Text(
              "Estimated Weight",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter weight",
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Notes
            const Text(
              "Notes:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter notes (optional)",
                ),
              ),
            ),
            const Spacer(),
            // Schedule Pick Up Now Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () {
                  // Handle Schedule Pick Up Now action
                },
                child: const Text(
                  "Schedule Pick Up Now",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const monthNames = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return monthNames[month - 1];
  }
}



Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PickUpSummaryPage(
      selectedDate: _selectedDay,
      selectedSlot: _timeSlots[_selectedSlotIndex],
    ),
  ),
);
