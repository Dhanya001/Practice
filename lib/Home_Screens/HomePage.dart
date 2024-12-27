import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:scrapapp/Utility/global_helper.dart';
import 'package:scrapapp/Utility/constants.dart' as constant;

import 'Dashboard.dart';

class Address {
  int id;
  String title;
  String addressLine1;
  String addressLine2;
  String city;
  String pinCode;

  Address({
    required this.id,
    required this.title,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.pinCode,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'],
      title: map['title'],
      addressLine1: map['addressline1'],
      addressLine2: map['addressline2'],
      city: map['city'],
      pinCode: map['pincode'],
    );
  }
}


class AddressBookPage extends StatefulWidget {

  @override
  _AddressBookPageState createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  List<Address> addresses = [];
  final TextEditingController searchController = TextEditingController();
  List<Address> searchResults = [];


  void userAddress() async {
    try {
      var userAddressMap = await GlobalHelper().getUserAddress(context, userProfile!.userID.toString());
      setState(() {
        addresses = userAddressMap.map<Address>((address) => Address.fromMap(address)).toList();
        searchResults = addresses;
      });
      print('This is my useraddressmap:${userAddressMap}');
    } catch (e) {
      // Handle error
      print('Error fetching addresses: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    userAddress();
    searchResults = addresses;
    print('yo');
    print(addresses);
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
      floatingActionButton: FloatingActionButton(onPressed: () async{
        var getAddress=await GlobalHelper().getUserAddress(context, userProfile!.userID.toString());
        print(getAddress);
      },),
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final address = searchResults[index];
                  return Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey,width: 2))
                    ),
                    child: ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(address.title),
                      subtitle: Text(
                        '${address.addressLine1}, ${address.addressLine2}, ${address.city}, ${address.pinCode}',
                      ),
                      //here I want edit side by delete iconand selection address option also i want
                      trailing: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _navigateToEditAddressPage(address: address),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete,),
                            onPressed: () => _navigateToEditAddressPage(address: address),
                          ),
                        ],
                      ),

                    ),
                  );
                },
              ),
            ),
          ),
          MyBottomButton(title: 'Add address', onPressed: (){
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
  late TextEditingController titleController;
  late TextEditingController addressLine1Controller;
  late TextEditingController addressLine2Controller;
  late TextEditingController pinCodeController;
  String? selectedCity;
  // List<String> citylist = [];


  List cities=[];
  initial() async {
    cities = await GlobalHelper().getLocation();
    setState(() {});
  }
  

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.address?.title);
    addressLine1Controller = TextEditingController(text: widget.address?.addressLine1);
    addressLine2Controller = TextEditingController(text: widget.address?.addressLine2);
    pinCodeController = TextEditingController(text: widget.address?.pinCode);
    selectedCity=widget.address?.city;
    initial();
  }

  void saveAddress() {
    final newAddress = Address(
      id: widget.address!.id,
      title: titleController.text,
      addressLine1: addressLine1Controller.text,
      addressLine2: addressLine2Controller.text,
      city: selectedCity ?? 'Unknown ',
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
      // floatingActionButton: FloatingActionButton(onPressed: ()async{
      //   GlobalHelper().getLocation();
      //
      //   //   print('Location:$Location');
      // }),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all()
              ),
              child: Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Home'),
                      value: 'Home',
                      groupValue: titleController.text,
                      onChanged: (value) {
                        setState(() {
                          titleController.text = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Work'),
                      value: 'Work',
                      groupValue: titleController.text,
                      onChanged: (value) {
                        setState(() {
                          titleController.text = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Gap(10),
            TextField(
              controller: addressLine1Controller,
              decoration: InputDecoration(
                  labelText: 'Address Line 1',
                contentPadding:
                EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(),
              ),
            ),
            Gap(10),
            TextField(
              controller: addressLine2Controller,
              decoration: InputDecoration(labelText: 'Address Line 2',
                contentPadding:
                EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(),),
            ),
            Gap(10),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  // color: Colors.white,
                  border: Border.all(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton(
                  value: selectedCity,
                  dropdownColor: Colors.white,
                  focusColor: Colors.white,
                  isExpanded: true,
                  hint: Text('Select City'),
                  items: cities.map(
                        (e) {
                      return DropdownMenuItem(
                        value: e['city'],
                        child: Text(e['city']),

                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value.toString();
                      final selectedCityData = cities.firstWhere(
                              (city) => city['city'] == selectedCity,
                          orElse: () => {'pincode': ''});
                      pinCodeController.text = selectedCityData['pincode'] ?? '';
                    });
                    print(value);
                  },
                ),
              ),
            ),
            Gap(10),
            TextField(
              controller: pinCodeController,
              decoration: InputDecoration(
                  labelText: 'Pin Code',
                contentPadding:
                EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              enabled:false,
            ),
            SizedBox(height: 30),
            MyTextButton(
                title: widget.address == null ? '  Add Address  ' : '  Update Address  ',
                onPressed: ()async{
                  var updateAddress=
                  await GlobalHelper().updateAddress(
                  userProfile!.userID.toString(),
                      widget.address!.id.toString(),
                      titleController.text,
                      addressLine1Controller.text,
                      addressLine2Controller.text,
                      selectedCity!,
                      pinCodeController.text);
                  print('address: $updateAddress');
                  if (updateAddress['success'] == true) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddressBookPage()),
                    );
                  }
                  else {
                    constant.showCustomSnackBar1(context, "");
                  }
                  saveAddress();
                },color: Theme.of(context).primaryColor,)
          ],
        ),
      ),
    );
  }
}
//here I want edit side by delete iconand selection address option also i want
