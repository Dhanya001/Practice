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

Widget _buildRateCardPickUp({
  required int index,
  required String title,
  required String price,
  required String image,
  required bool isChecked,
}) {
  return GestureDetector(
    onTap: () {
      setState(() {
        // Toggle the checkbox state
        _searchitems[index]['isChecked'] = !isChecked;
      });
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
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.green,
                    value: isChecked,
                    tristate: false,
                    shape: CircleBorder(),
                    onChanged: (bool? newvalue) {
                      setState(() {
                        _searchitems[index]['isChecked'] = newvalue ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    ),
  );
}

class CapturePickup extends StatefulWidget {
  final Function(String) onWeightChanged; // Callback function

  const CapturePickup({super.key, required this.onWeightChanged}); // Accept the callback

  @override
  State<CapturePickup> createState() => _CapturePickupState();
}

class _CapturePickupState extends State<CapturePickup> {
  final TextEditingController _weightcontroller = TextEditingController();
  final picker = ImagePicker();
  File? _image;

  Future getImageGallery() async {
    final pickedfile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedfile != null) {
        _image = File(pickedfile.path);
      } else {
        print("Empty");
      }
    });
  }

  void _onWeightChanged(String value) {
    widget.onWeightChanged(value); // Call the callback function
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
                    onTap: () {
                      getImageGallery();
                    },
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey)),
                      child: _image != null
                          ? Image.file(
                              _image!.absolute,
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 30,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            MySmallText(
              title: "Capture a clear image of the selected products.",
              isBold: true,
              color: Colors.black,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: MyMediumText(
                        title: "Estimate Weight",
                        isBold: true,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 2, color: Colors.grey)),
              child: TextFormField(
                controller: _weightcontroller,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: InputBorder.none,
                  hintText: "Enter Product Estimate Weight",
                ),
                onChanged: _onWeightChanged, // Update weight on change
              ),
            ),
            Gap(120),
            MyBottomButton(
              title: "Next",
              destination: Calenderpickup(
                TotWeight: _weightcontroller.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _weightcontroller.dispose();
    super.dispose();
  }
}


// Somewhere in your navigation code
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CapturePickup(
      onWeightChanged: ( String weight) {
        // Update the state in Calenderpickup or handle the weight change
        // You can use a state management solution or a simple variable to hold the weight
      },
    ),
  ),
);

class _RateCardPickupState extends State<RateCardPickup> {
  final TextEditingController _searchcontroller = TextEditingController();
  List<Map<String, dynamic>> _searchitems = [];
  List<Map<String, dynamic>> selectedItems = []; // List to store selected items

  final List<Map<String, dynamic>> rateItems = [
    {'title': 'News paper', 'price': '₹1200/kg', 'image': 'assets/Newspaper3.png', 'isChecked': false},
    {'title': 'Plastic Bottles', 'price': '₹10/kg', 'image': 'assets/Bottle.png', 'isChecked': false},
    // Add other items as needed
  ];

  @override
  void initState() {
    super.initState();
    _searchitems = rateItems;
  }

  void _runFilter(String keyword) {
    List<Map<String, dynamic>> results = [];
    if (keyword.isEmpty) {
      results = rateItems;
    } else {
      results = rateItems.where((user) => user["title"]!.toLowerCase().contains(keyword.toLowerCase())).toList();
    }
    setState(() {
      _searchitems = results;
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      _searchitems[index]['isChecked'] = !_searchitems[index]['isChecked'];
      if (_searchitems[index]['isChecked']) {
        selectedItems.add(_searchitems[index]);
      } else {
        selectedItems.remove(_searchitems[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: appbar(context, "Schedule Pick Up", "Select Products for pick up"),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.circular(16)
              ),
              child: TextFormField(
                controller: _searchcontroller,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: InputBorder.none,
                  hintText: "Enter Product",
                ),
                onChanged: (value) => _runFilter(value),
              ),
            ),
            Expanded(
              child: _searchitems.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 2 / 3,
                      ),
                      itemCount: _searchitems.length,
                      itemBuilder: (context, index) {
                        final item = _searchitems[index];
                        return _buildRateCardPickUp(
                          index: index,
                          title: item['title']!,
                          price: item['price']!,
                          image: item['image']!,
                          isChecked: item['isChecked']!,
                        );
                      },
                    )
                  : const MyBigText(title: "No result Found", isBold: true, color: Colors.black),
            ),
            MyBottomButton(
              title: "Next",
              destination: CapturePickup(
                selectedItems: selectedItems, // Pass selected items to CapturePickup
              ),
            ),
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
    required bool isChecked
  }) {
    return GestureDetector(
      onTap: () {
        _toggleSelection(index); // Toggle selection on tap
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
                margin ```dart
                : EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.green,
                      value: isChecked,
                      tristate: true,
                      shape: CircleBorder(),
                      onChanged: (bool? newvalue) {
                        _toggleSelection(index);
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
class CapturePickup extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems; // Accept selected items

  const CapturePickup({super.key, required this.selectedItems});

  @override
  State<CapturePickup> createState() => _CapturePickupState();
}

class _CapturePickupState extends State<CapturePickup> {
  final TextEditingController _weightcontroller = TextEditingController();
  final picker = ImagePicker();
  File? _image;

  Future getImageGallery() async {
    final pickedfile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedfile != null) {
        _image = File(pickedfile.path);
      } else {
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
                    onTap: () {
                      getImageGallery();
                    },
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: _image != null
                          ? Image.file(_image!.absolute, fit: BoxFit.cover)
                          : Center(
                              child: Icon(Icons.add_photo_alternate_outlined, size: 30),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            MySmallText(
              title: "Capture a clear image of the selected products.",
              isBold: true,
              color: Colors.black,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: MyMediumText(title: "Estimate Weight", isBold: true, color: Colors.black),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2, color: Colors.grey),
              ),
              child: TextFormField(
                controller: _weightcontroller,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: InputBorder.none,
                  hintText: "Enter Product Estimate Weight",
                ),
              ),
            ),
            Gap(120),
            MyBottomButton(
              title: "Next",
              destination: Calenderpickup(
                TotWeight: _weightcontroller.text,
                selectedItems: widget.selectedItems, // Pass selected items to Calenderpickup
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
 void dispose() {
    _weightcontroller.dispose();
    super.dispose();
  }
}
class Calenderpickup extends StatefulWidget {
  final String TotWeight;
  final List<Map<String, dynamic>> selectedItems; // Accept selected items

  const Calenderpickup({super.key, required this.TotWeight, required this.selectedItems});

  @override
  State<Calenderpickup> createState() => _CalenderpickupState();
}

class _CalenderpickupState extends State<Calenderpickup> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  int? _selectedslot = 0;

  final List<String> _timeslot = [
    "09:00 AM - 12:00 PM",
    "01:00 PM - 04:00 PM",
    "05:00 PM - 08:00 PM",
  ];

  void _onDaySelected(DateTime SelectedDate, DateTime focusedDay) {
    setState(() {
      _focusedDay = SelectedDate;
    });
  }

  @override
  void initState() {
    _selectedDate = _focusedDay;
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
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blueAccent,
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
                    titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: MyMediumText(title: "Pick a slot", isBold: true, color: Colors.black),
              ),
              SizedBox(height: 10),
              Column(
                children: List.generate(_timeslot.length, (index) {
                  return Container(
                    color: Colors.white,
                    child: RadioListTile<int?>(
                      dense: true,
                      value: index,
                      groupValue: _selectedslot,
                      onChanged: (value) {
                        setState(() {
                          _selectedslot = value;
                        });
                      },
                      title: Text(
                        _timeslot[index],
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                      ),
                      activeColor: Colors.green,
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: MyMediumText(title: "Estimate Weight", isBold: true, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 40,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 2, color: Colors.grey),
                ),
                child: Center(
                  child: MySmallText(title: "${widget.TotWeight}", isBold: false, color: Colors.black),
                ),
              ),
              MyBottomButton(
                title: "Next",
                destination: Schedulersummary(
                  selectedDate: _focusedDay,
                  TotWeight: "${widget.TotWeight}",
                  selectedSlot: _timeslot[_selectedslot!],
                  selecteditems: widget.selectedItems, // Pass selected items to Schedulers summary
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Schedulersummary extends StatefulWidget {
  final DateTime selectedDate;
  final String selectedSlot;
  final String TotWeight;
  final List<Map<String, dynamic>> selecteditems; // Accept selected items

  Schedulersummary({
    super.key,
    required this.selectedDate,
    required this.TotWeight,
    required this.selectedSlot,
    required this.selecteditems,
  });

  @override
  State<Schedulersummary> createState() => _SchedulersummaryState();
}

class _SchedulersummaryState extends State<Schedulersummary> {
  final TextEditingController _notescontroller = TextEditingController();

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
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
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
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: ListView.builder(
                itemCount: widget.selecteditems.length,
                itemBuilder: (context, index) {
                  final item = widget.selecteditems[index];
                  return ListTile(
                    title: Text(item['title']),
                    subtitle: Text(item['price']),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: [
                  MyMediumText(title: "Estimate Weight :", isBold: true, color: Colors.black),
                  Gap(20),
                  MyMediumText(title: "${widget.TotWeight}", isBold: false, color: Colors.black),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: MyMediumText(title: "Notes", isBold: true, color: Colors.black),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2, color: Colors.grey),
              ),
              child: TextFormField(
                controller: _notescontroller,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: InputBorder.none,
                  hintText: "Enter Product Notes",
                ),
                maxLines: 4,
              ),
            ),
            MyBottomButton(title: "Schedule Pick Up Now", destination: HomePage()),
          ],
        ),
      ),
    );
  }
}

only title
  
void _toggleSelection(int index) {
  setState(() {
    _searchitems[index]['isChecked'] = !_searchitems[index]['isChecked'];
    if (_searchitems[index]['isChecked']) {
      // Add only the title to the selectedItems list
      selectedItems.add({'title': _searchitems[index]['title']});
    } else {
      // Remove the title from selectedItems list
      selectedItems.removeWhere((item) => item['title'] == _searchitems[index]['title']);
    }
  });
}
class Schedulersummary extends StatefulWidget {
  final DateTime selectedDate;
  final String selectedSlot;
  final String TotWeight;
  final List<Map<String, dynamic>> selecteditems; // Accept selected items

  Schedulersummary({
    super.key,
    required this.selectedDate,
    required this.TotWeight,
    required this.selectedSlot,
    required this.selecteditems,
  });

  @override
  State<Schedulersummary> createState() => _SchedulersummaryState();
}

class _SchedulersummaryState extends State<Schedulersummary> {
  final TextEditingController _notescontroller = TextEditingController();

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
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
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
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: ListView.builder(
                itemCount: widget.selecteditems.length,
                itemBuilder: (context, index) {
                  final item = widget.selecteditems[index];
                  return ListTile(
                    title: Text(item['title']), // Display only the title
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: [
                  MyMediumText(title: "Estimate Weight :", isBold: true, color: Colors.black),
                  Gap(20),
                  MyMediumText(title: "${widget.TotWeight}", isBold: false, color: Colors.black),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
