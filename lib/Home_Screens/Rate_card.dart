class MyBottomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed; // Change this line

  const MyBottomButton({
    super.key,
    required this.title,
    required this.onPressed, // Use the onPressed parameter instead of destination
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextButton(
            onPressed: onPressed, // Call the onPressed function
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
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
        _toggleSelection(index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            Container(
              margin: const EdgeInsets.all(5),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Title with Fixed Height
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                // height: 40, // Fixed height for the title container
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Price and Checkbox
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      price,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.green,
                    value: isChecked,
                    tristate: false,
                    shape: const CircleBorder(),
                    onChanged: (bool? newvalue) {
                      _toggleSelection(index);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


 MyBottomButton(title: "Next", onPressed: () {
          if (SelectedItems.isEmpty) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please select at least one item."),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }
                  },


class UpcomingPickUps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            child: Container(
              color: index == 0 ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Upcoming',
                          style: TextStyle(color: index == 0 ? Colors.white : Colors.black),
                        ),
                        Text(
                          'Pick Up Id',
                          style: TextStyle(color: index == 0 ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                  ),
                  // Day Text
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Day',
                        style: TextStyle(fontSize: 20, color: index == 0 ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                  Divider(
                    color: index == 0 ? Colors.white : Colors.black,
                    thickness: 2,
                  ),
                  // Buttons
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffF4A261),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PickUpDetails()));
                            },
                            child: MySmallText(title: 'Reschedule', color: Colors.white,),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PickUpDetails()));
                          },
                          child: MySmallText(title: 'View Details', color: Colors.white,),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

                import 'package:flutter/material.dart';
import 'package:scrapapp/screens/HomePage.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final TextEditingController _searchController = TextEditingController();

  // Predefined list of locations
  List<String> predefinedLocations = [
    "Mumbai",
    "Delhi",
    "Bangalore",
    "Chennai",
    "Kolkata",
    "Pune",
    "Hyderabad",
    "Ahmedabad",
    "Jaipur",
    "Lucknow",
  ];

  List<String> filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    filteredLocations = predefinedLocations; // Show all locations by default
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      if (_searchController.text.isEmpty) {
        filteredLocations = predefinedLocations;
      } else {
        filteredLocations = predefinedLocations
            .where((location) => location
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

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
        title: Text(
          "Enter your location",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              border: Border.all(width: 2, color: Color(0xff2D6A4F)),
            ),
            child: TextFormField(
              controller: _searchController,
              decoration: const InputDecoration(
                icon: Icon(Icons.search),
                border: InputBorder.none,
                hintText: "Enter Location",
              ),
            ),
          ),

          // List of filtered locations
          Expanded(
            child: ListView.builder(
              itemCount: filteredLocations.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Selected Location: ${filteredLocations[index]}",
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      filteredLocations[index],
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ),

          // Use current location button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Using current location")),
                  );
                },
                child: Text(
                  "Use my current location",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
