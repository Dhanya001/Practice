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
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:scrapapp/screens/Capture_PickUp.dart';

class RateCardPickup extends StatefulWidget {
  const RateCardPickup({super.key});

  @override
  State<RateCardPickup> createState() => _RateCardPickupState();
}

class _RateCardPickupState extends State<RateCardPickup> {
  final TextEditingController _searchcontroller=TextEditingController();
  List<Map<String, dynamic>> _searchitems=[];
  // List<String> selectedItem=[];
  // final List<String> selectedItemTitles = _searchitems.map((item) => item.title).toList();

  final List<Map<String, dynamic>> rateItems = [
    {'title': 'News paper', 'price': '₹1200/kg', 'image': 'assets/Newspaper3.png', 'isChecked': false},
    {'title': 'News paper', 'price': '₹1200/kg', 'image': 'assets/Newspaper3.png','isChecked' :false},
    {'title': 'Plastic Bottles', 'price': '₹10/kg', 'image': 'assets/Bottle.png','isChecked':false},
    {'title': 'Aluminum Cans', 'price': '₹28/kg', 'image': 'assets/Newspaper3.png','isChecked':false},
    {'title': 'E-Waste', 'price': '₹50/kg', 'image': 'assets/Bottle.png','isChecked':false},
    {'title': 'Newspapeskslr', 'price': '₹12/kg', 'image': 'assets/Newspaper3.png','isChecked':false},
    {'title': 'Plastic Bottlesfdn;fjdn', 'price': '₹10/kg', 'image': 'assets/Bottle.png','isChecked':false},
    {'title': 'Aluminum Cans', 'price': '₹28/kg', 'image': 'assets/Newspaper3.png','isChecked':false},
    {'title': 'E-Waste', 'price': '₹50/kg', 'image': 'assets/Bottle.png','isChecked':false},
    {'title': 'Newspapeskslr', 'price': '₹12/kg', 'image': 'assets/Newspaper3.png','isChecked':false},
    {'title': 'Plastic Bottlesfdn;fjdn', 'price': '₹10/kg', 'image': 'assets/Bottle.png','isChecked':false},
    {'title': 'Aluminum Cans', 'price': '₹28/kg', 'image': 'assets/Newspaper3.png','isChecked':false},
    {'title': 'E-Waste', 'price': '₹50/kg', 'image': 'assets/Bottle.png','isChecked':false},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchitems=rateItems;
  }

  void _runFilter(String keyword){
    List<Map<String, dynamic>> results=[];
    if(keyword.isEmpty){
      results=rateItems;
    }else{
      // results=rateItems.where((user=>user["title"])).toList()
      results=rateItems.where((user)=>user["title"]!.toLowerCase().contains(keyword.toLowerCase())).toList();
    }
    setState(() {
      _searchitems=results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: appbar(context, "Schedule Pick Up", "Select  Products for pick up"),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical:5,horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(width: 2,color: Colors.grey),
                borderRadius: BorderRadius.circular(16)
              ),
              child: TextFormField(
                controller: _searchcontroller,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  //border: OutlineInputBorder(),
                  border: InputBorder.none,
                  hintText: "Enter Product",
                  //labelText: "Location",
                ),
                onChanged: (value)=>_runFilter(value),
              ),
            ),

            Expanded(
              child: _searchitems.isNotEmpty?GridView.builder(gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 2/3,
              ),
                  itemCount: _searchitems.length,
                  itemBuilder: (context,index){
                    final item = _searchitems[index];
                    return _buildRateCardPickUp(
                      index: index,
                      title: item['title']!,
                      price: item['price']!,
                      image: item['image']!,
                      isChecked: item['isChecked']!,
                    );
                  }):const MyBigText(title: "No result Found",isBold: true,color: Colors.black,),
            ),
            MyBottomButton(title: "Next",destination: CapturePickup(
              // selectedItems: _searchitems.map((item)=>item.title).toList(),
              // selectedItems: selectedItem.toList(),
            ),),
          ],
        ),
      ),
    );
  }

  Widget _buildRateCardPickUp({
    required int index,
    required String title,
    required String price,
    required String image,
    required bool isChecked}) {
    return GestureDetector(
      onTap: () {
        
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            Expanded(
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(image: AssetImage(image,),fit: BoxFit.cover,)
                    ),
                    )),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(title,
                  style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(price,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                      ),),
                    Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.green,
                        value: isChecked,
                        tristate: true,
                        shape: CircleBorder(),
                        onChanged: (bool? newvalue){
                      setState(() {
                        _searchitems[index]['isChecked'] = newvalue??false;
                      });
                    })
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),

      ),
    );
  }
}



import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrapapp/screens/CalenderPickUp.dart';

class CapturePickup extends StatefulWidget {
  // final List<String> selectedItems;
  const CapturePickup({super.key});

  @override
  State<CapturePickup> createState() => _CapturePickupState();
}

class _CapturePickupState extends State<CapturePickup> {
  // dynamic SelectedImage;
  final TextEditingController _weightcontroller=TextEditingController();
  final picker=ImagePicker();
  File? _image;


  Future getImageGallery() async{
    final pickedfile=await picker.pickImage(
        source: ImageSource.gallery,);
    setState(() {
      if(pickedfile!=null){
          _image=File(pickedfile.path);
        }else{
          print("Empty");
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: appbar(context, "Schedule Pick Up", "Upload a Photo"),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      getImageGallery();
                    },
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey)
                      ),
                      child: _image!=null?
                      Image.file(_image!.absolute,fit: BoxFit.cover,)
                          : Center(
                        child: Icon(Icons.add_photo_alternate_outlined,size: 30,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            MySmallText(
              title: "Capture a clear image of the selected products.",
              isBold: true,
              color: Colors.black,),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                      child: MyMediumText(title: "Estimate Weight",isBold: true,color: Colors.black,)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical:10,horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                  border: Border.all(width: 2,color: Colors.grey),
                  // borderRadius: BorderRadius.circular(16)
              ),
              child: TextFormField(
                controller: _weightcontroller,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  border: InputBorder.none,
                  hintText: "Enter Product Estimate Weight",
                ),
              ),
            ),
            Gap(120),
            MyBottomButton(title: "Next",destination: Calenderpickup(
              TotWeight: _weightcontroller.text,),),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _weightcontroller.dispose();
    super.dispose();
  }
}


import 'package:flutter/material.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:scrapapp/screens/SchedulerSummary.dart';
import 'package:table_calendar/table_calendar.dart';

class Calenderpickup extends StatefulWidget {
  final String TotWeight;
  // final List<String> selectedItems;

  const Calenderpickup({super.key, required this.TotWeight});
  @override
  State<Calenderpickup> createState() => _CalenderpickupState();
}

class _CalenderpickupState extends State<Calenderpickup> {

  // CalenderFormat _calenderFormat=CalenderFormat.month;
  DateTime _focusedDay=DateTime.now();
  DateTime? _selectedDate;
  int? _selectedslot=0;

  final List<String> _timeslot=[
    "09:00 AM - 12:00 PM",
    "01:00 PM - 04:00 PM",
    "05:00 PM - 08:00 PM",
  ];

  void _onDaySelected(DateTime SelectedDate,DateTime focusedDay){
    setState(() {
      _focusedDay=SelectedDate;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _selectedDate=_focusedDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, "Schedule Pick Up", "Pick Up Date & Time-slots"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime(1999),
                    lastDay: DateTime(2030),
                  selectedDayPredicate: (day) {
                    return isSameDay(_focusedDay, day);
                  },
                  onDaySelected: _onDaySelected,
                  // onDaySelected: (SelectedDay,_focusedDay){
                  //     setState(() {
                  //       _selectedDate=SelectedDay;
                  //       _focusedDay=SelectedDay;
                  //     });
                  // },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      // color: Color(0xffFFF0F0),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),
                    ),
                ),
              ),

                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    child: MyMediumText(title: "Pick a slot",isBold: true,color: Colors.black,)),

              SizedBox(height: 10,),
              Column(
                children: List.generate(_timeslot.length, (index){
                  return Container(
                    color: Colors.white,
                    child: RadioListTile<int?>(
                      dense: true,
                        value: index,
                        groupValue: _selectedslot,
                        onChanged: ( value){
                          setState(() {
                              _selectedslot= value;
                          });
                        },
                        title: Text(_timeslot[index],style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),),
                      activeColor: Colors.green,
                      controlAffinity: ListTileControlAffinity.trailing,
                        ),
                  );
                }),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: MyMediumText(title: "Estimate Weight",isBold: true,color: Colors.black,)),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 40,
                margin: const EdgeInsets.symmetric(vertical:10,horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 2,color: Colors.grey),
                  // borderRadius: BorderRadius.circular(16)
                ),
                child: Center(child: MySmallText(title: "${widget.TotWeight}",isBold: false,color: Colors.black,)),
                // child: Text("${widget.TotWeight}")
              ),
              MyBottomButton(title: "Next", destination: Schedulersummary(
                  selectedDate: _focusedDay,
                  TotWeight: "${widget.TotWeight}",
                  selectedSlot: _timeslot[_selectedslot!],
                  selecteditems: [],
                  // selectedSlot: _timeslot[_selectedslot]
              )),
                ],
              ),
        ),
      ),

    );
  }
}
















import 'package:flutter/material.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:scrapapp/screens/HomePage.dart';
import 'package:gap/gap.dart';

class Schedulersummary extends StatefulWidget {
  final DateTime selectedDate;
  final String selectedSlot;
  final String TotWeight;
  List<Map<String, dynamic>> selecteditems=[];
  // const Schedulersummary({super.key, required this.selectedDate, required this.selectedSlot});
  Schedulersummary({super.key, required this.selectedDate, required this.TotWeight, required this.selectedSlot,required this.selecteditems});
  @override
  State<Schedulersummary> createState() => _SchedulersummaryState();
}

class _SchedulersummaryState extends State<Schedulersummary> {
  final TextEditingController _notescontroller=TextEditingController();

  String _monthName(int month) {
    const monthNames = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, "Schedule Pick Up", "Pick Up Summary"),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "${widget.selectedDate.day} ${_monthName(widget.selectedDate.month)} ${widget.selectedDate.year}",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "${widget.selectedSlot}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey,width: 2)
              ),
              child: Text("${widget.selecteditems}"),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
              child: Row(
                children: [
                  MyMediumText(title: "Estimate Weight :",isBold: true,color: Colors.black,),
                  Gap(20),
                  MyMediumText(title: "${widget.TotWeight}",isBold: false,color: Colors.black,)
                ],
              ),
            ),
        
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: MyMediumText(title: "Notes",isBold: true,color: Colors.black,)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical:10,horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2,color: Colors.grey),
                // borderRadius: BorderRadius.circular(16)
              ),
              child: TextFormField(
                controller: _notescontroller,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  border: InputBorder.none,
                  hintText: "Enter Product Notes",
                ),maxLines: 4,
              ),
            ),
            MyBottomButton(title: "Schedule Pick Up Now", destination: HomePage())
          ],
        ),
      ),
      
    );
  }
}


//
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => CalendarPickupPage(
// selectedItems: selectedItems,
// ),
// ),
// );
//
//
// class CalendarPickupPage extends StatelessWidget {
// final List<String> selectedItems;
//
// CalendarPickupPage({required this.selectedItems});
//
// @override
// Widget build(BuildContext context) {
// // Your existing code for CalendarPickupPage
// }
// }
//
//
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => SummaryPickup(
// selectedDate: selectedDate, // Assuming you have this in CalendarPickupPage
// selectedSlot: selectedSlot, // Assuming you have this in CalendarPickupPage
// selectedItems: selectedItems,
// ),
// ),
// );
//
//
// for title
//
// // In RateCardPickupPage, create a list of titles
// final List<String> selectedItemTitles = selectedItems.map((item) => item.title).toList();
//
//
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => CalendarPickupPage(
// selectedItemTitles: selectedItemTitles,
// ),
// ),
// );
//
//
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => SummaryPickup(
// selectedDate: selectedDate,
// selectedSlot: selectedSlot,
// selectedItemTitles: selectedItemTitles,
// ),
// ),
// );
import 'package:flutter/material.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:scrapapp/screens/OTP_Screen.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gap/gap.dart';


class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _phonecontroller=TextEditingController();

  //we have create global key for our form
  final formkey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              icon: Icon(Icons.chevron_left, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: Text("Sign In",style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold),),centerTitle: true,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Title
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.topLeft,
              child: MyBigText(
                title: "Welcome To Scrap App",
                isBold: true,),
            ),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.topLeft,
              child: MySmallText(
                title: "Hey you’re back, fill in your details to get back in",
                color: Colors.black87,
                isBold: false,),
            ),

            //Phone Field
            SizedBox(height: 10,),
            Form(
              key: formkey,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: TextFormField(
                  controller: _phonecontroller,
                  keyboardType: TextInputType.phone,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Phone Number is required.";
                    }else if(!RegExp(r"^[0-9]{10,15}$").hasMatch(value)){
                      return "Please enter valid phone number";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    border: InputBorder.none,
                    hintText: "Enter Your Phone Number.",
                    labelText: "Phone Number",
                  ),
                ),
              ),
            ),

            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SignInButton(
                  Buttons.apple,
                  mini: true,
                  onPressed: () {},
                ),
                SignInButton(
                  Buttons.facebook,
                  mini: true,
                  onPressed: () {},
                ),

                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                  ),
                  child: IconButton(onPressed: () {

                  }, icon: Image.asset('assets/icons/google.png',width: 32,)),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                ),
              child: TextButton(onPressed: () async{
                if (formkey.currentState!.validate()) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('phone', _phonecontroller.text);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreen()));
                }
              },
                  child: Text("Send OTP",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),)),
            ),
          ],
        ),
      ),
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Stack(
//       children: [
//         SingleChildScrollView(
//           child: Column(
//             children: [
//               // Title
//               SizedBox(height: 20,),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 10),
//                 alignment: Alignment.topLeft,
//                 child: MyBigText(
//                   title: "Welcome To Scrap App",
//                   isBold: true,
//                 ),
//               ),
//               SizedBox(height: 10,),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 10),
//                 alignment: Alignment.topLeft,
//                 child: MySmallText(
//                   title: "Hey you’re back, fill in your details to get back in",
//                   color: Colors.black87,
//                   isBold: false,
//                 ),
//               ),
//
//               // Phone Field
//               SizedBox(height: 10,),
//               Form(
//                 key: formkey,
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     color: Colors.white,
//                   ),
//                   child: TextFormField(
//                     controller: _phonecontroller,
//                     keyboardType: TextInputType.phone,
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "Phone Number is required.";
//                       } else if (!RegExp(r"^[0-9]{10,15}$").hasMatch(value)) {
//                         return "Please enter valid phone number";
//                       }
//                       return null;
//                     },
//                     decoration: const InputDecoration(
//                       icon: Icon(Icons.person),
//                       border: InputBorder.none,
//                       hintText: "Enter Your Phone Number.",
//                       labelText: "Phone Number",
//                     ),
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 20,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SignInButton(
//                     Buttons.apple,
//                     mini: true,
//                     onPressed: () {},
//                   ),
//                   SignInButton(
//                     Buttons.facebook,
//                     mini: true,
//                     onPressed: () {},
//                   ),
//                   Container(
//                     width: 38,
//                     height: 38,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.rectangle,
//                       color: Colors.white,
//                     ),
//                     child: IconButton(
//                       onPressed: () {},
//                       icon: Image.asset('assets/icons/google.png', width: 32,),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         // Send OTP Button at the bottom
//         Positioned(
//           left: 10,
//           right: 10,
//           bottom: 20, // Adjust this value to change the vertical position of the button
//           child: Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: TextButton(
//               onPressed: () async {
//                 if (formkey.currentState!.validate()) {
//                   final prefs = await SharedPreferences.getInstance();
//                   await prefs.setString('phone', _phonecontroller.text);
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen()));
//                 }
//               },
//               child: Text(
//                 "Send OTP",
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }


