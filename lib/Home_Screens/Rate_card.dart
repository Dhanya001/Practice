class EditAddressPage extends StatefulWidget {
  final Address? address;
  final Function(Address) onSave;

  EditAddressPage({this.address, required this.onSave});

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  late TextEditingController addressLine1Controller;
  late TextEditingController addressLine2Controller;
  late TextEditingController pinCodeController;
  String? selectedCity;
  String? selectedTitle = 'Home'; // Default title
  List<String> cities = []; // Initialize an empty list for cities

  // Fetch cities from the API
  Future<void> getLocation() async {
    try {
      var response = await http.get(Uri.parse(
        '${constant.apiLocalName}/getLocation',
      ));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var locationData = responseData['cities'];
        setState(() {
          cities = List<String>.from(locationData); // Update cities list
        });
      } else {
        throw Exception('Failed to Fetch Location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during Location: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    addressLine1Controller = TextEditingController(text: widget.address?.addressLine1);
    addressLine2Controller = TextEditingController(text: widget.address?.addressLine2);
    pinCodeController = TextEditingController(text: widget.address?.pinCode);
    selectedCity = widget.address?.city;
    getLocation(); // Fetch cities when the page initializes
  }

  void saveAddress() {
    final newAddress = Address(
      title: selectedTitle ?? 'Unknown',
      addressLine1: addressLine1Controller.text,
      addressLine2: addressLine2Controller.text,
      city: selectedCity ?? 'Unknown',
      pinCode: pinCodeController.text,
    );
    widget.onSave(newAddress);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio<String>(
                  value: 'Home',
                  groupValue: selectedTitle,
                  onChanged: (value) {
                    setState(() {
                      selectedTitle = value;
                    });
                  },
                ),
                Text('Home'),
                Radio<String>(
                  value: 'Work',
                  groupValue: selectedTitle,
                  onChanged: (value) {
                    setState(() {
                      selectedTitle = value;
                    });
                  },
                ),
                Text('Work'),
              ],
            ),
            Gap(10),
            TextField(
              controller: addressLine1Controller,
              decoration: InputDecoration(
                labelText: 'Address Line 1',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(),
              ),
            ),
            Gap(10),
            TextField(
              controller: addressLine2Controller,
              decoration: InputDecoration(
                labelText: 'Address Line 2',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(),
              ),
            ),
            Gap(10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(),
              ),
              value: selectedCity,
              hint: Text('Select City'),
              items: cities.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCity = newValue;
                  pinCodeController.clear(); // Clear pin code when city changes
                  // Fetch pin code based on selected city
                  // You can implement the API call here to get the pin code
                });
              },
            ),
            Gap(10),
            TextField(
              controller: pinCodeController,
              decoration: InputDecoration(
                labelText: 'Pin Code',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              enabled: selectedCity != null, // Disable if no city is selected
            ),
            SizedBox(height: 30),
            MyTextButton(
              title: widget.address == null ? '  Add Address  ' : '  Update Address  ',
              onPressed: () async {
                saveAddress();
              },
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:scrapapp/Utility/global_helper.dart';
import 'dart:convert'; // Import for jsonDecode
import 'package:http/http.dart' as http; // Import for http requests

class Address {
  String title;
  String addressLine1;
  String addressLine2;
  String city;
  String pinCode;

  Address({
    required this.title,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.pinCode,
  });
}

class AddressBookPage extends StatefulWidget {
  @override
  _AddressBookPageState createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  final List<Address> addresses = [];
  final TextEditingController searchController = TextEditingController();
  List<Address> searchResults = [];

  @override
  void initState() {
    super.initState();
    searchResults = addresses;
  }

  void runFilter(String keyword) {
    if (keyword.isEmpty) {
      setState(() {
        searchResults = addresses;
      });
    } else {
      setState(() {
        searchResults = addresses
            .where((address) =>
                address.title.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      });
    }
  }

  void _navigateToEditAddressPage({Address? address}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAddressPage(
          address: address,
          onSave: (newAddress) {
            setState(() {
              if (address != null) {
                int index = addresses.indexOf(address);
                addresses[index] = newAddress;
              } else {
                addresses.add(newAddress);
              }
              searchResults = addresses;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myappbar(context, 'Address Book', true),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16)),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: InputBorder.none,
                  labelText: 'Search Address',
                ),
                onChanged: runFilter,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final address = searchResults[index];
                return ListTile(
                  title: Text(address.title),
                  subtitle: Text(
                    '${address.addressLine1}, ${address.addressLine2}, ${address.city}, ${address.pinCode}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _navigateToEditAddressPage(address: address),
                  ),
                );
              },
            ),
          ),
          MyBottomButton(title: 'Add address', onPressed: () {
            _navigateToEditAddressPage();
          })
        ],
      ),
    );
  }
}

class EditAddressPage extends StatefulWidget {
  final Address? address;
  final Function(Address) onSave;

  EditAddressPage({this.address, required this.onSave});

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  late TextEditingController addressLine1Controller;
  late TextEditingController addressLine2Controller;
  late TextEditingController pinCodeController;
  String? selectedCity;
  String? selectedTitle = 'Home'; // Default title
  List<String> cities = [' Kalyan', 'Mumbai', 'Dombivli'];

  getLocation() async {
    try {
      var response = await http.get(Uri.parse(
        '${constant.apiLocalName}/getLocation',
      ));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var locationData = responseData['cities'];
        return locationData;
      } else {
        throw Exception('Failed to Fetch Location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during Location: $e');
      rethrow;
    }
  }

  List? city;
  initial() async {
    city = await GlobalHelper().getLocation();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    addressLine1Controller = TextEditingController(text: widget.address?.addressLine1);
    addressLine2Controller = TextEditingController(text: widget.address?.addressLine2);
    pinCodeController = TextEditingController(text: widget.address?.pinCode);
    selectedCity = widget.address?.city;
    initial();
  }

  void saveAddress() {
    final newAddress = Address(
      title: selectedTitle ?? 'Unknown',
      addressLine1: addressLine1Controller.text,
      addressLine2: addressLine2Controller.text,
      city: selectedCity ?? 'Unknown',
      pinCode: pinCodeController.text,
    );
    widget.onSave(newAddress);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio<String>(
                  value: 'Home',
                  groupValue: selectedTitle,
                  onChanged: (value) {
                    setState(() {
                      selectedTitle = value;
                    });
                  },
                ),
                Text('Home'),
                Radio<String>(
                  value: 'Work',
                  groupValue: selectedTitle,
                  onChanged: (value) {
                    setState(() {
                      selectedTitle = value;
                    });
                  },
                ),
                Text('Work'),
              ],
            ),
            Gap(10),
            TextField(
              controller: addressLine1Controller,
              decoration: InputDecoration(
                labelText: 'Address Line 1',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(),
              ),
            ),
            Gap(10),
            TextField(
              controller: addressLine2Controller,
              decoration: InputDecoration(
                labelText: 'Address Line 2',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(),
              ),
            ),
            Gap(10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(),
              ),
              value: selectedCity,
              hint: Text('Select City'),
              items: cities.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCity = newValue;
                  pinCodeController.clear(); // Clear pin code when city changes
                  // Fetch pin code based on selected city
                  // You can implement the API call here to get the pin code
                });
              },
            ),
            Gap(10),
            TextField(
              controller: pinCodeController,
              decoration: InputDecoration(
                labelText: 'Pin Code',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              enabled: selectedCity != null, // Disable if no city is selected
            ),
            SizedBox(height: 30),
            MyTextButton(
              title: widget.address == null ? '  Add Address  ' : '  Update Address  ',
              onPressed: () async {
                saveAddress();
              },
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
``` ```dart
// In the above code, the following changes were made:
// 1. Replaced the TextField for the title with radio buttons for "Home" and "Work".
// 2. The pin code field is now disabled when no city is selected, and

