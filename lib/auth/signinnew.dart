import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scrapapp/screens/HomePage.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';



class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final TextEditingController _searchcontroller=TextEditingController();
  final String token='1234567890';
  var uuid = Uuid();
  List<dynamic>ListOfLocation=[];

  String? _currentAddress;
  Position? _currentPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentPosition();
    _handleLocationPermission();
    _searchcontroller.addListener((){});
    _onchange();
  }



  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });

    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    // List<Placemark> placemarks = await placemarkFromCoordinates(52.2165157, 6.9437819);
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }


  // List<String> predefinedLocations = [
  //   "Mumbai",
  //   "Delhi",
  //   "Bangalore",
  //   "Chennai",
  //   "Kolkata",
  //   "Pune",
  //   "Hyderabad",
  //   "Ahmedabad",
  //   "Jaipur",
  //   "Lucknow",
  // ];


  _onchange(){
    PlaceSugguestion(_searchcontroller.text);
  }

  void PlaceSugguestion(String input) async{
   String apikey="AIzaSyB8GbF5swuHTP0pCHgGid-pGY-WqR50Ao0";
   try{
     String baseurl="https://maps.googleapis.com/maps/api/place/autocomplete/json";
     String request='$baseurl?input=$input&Key=$apikey&sessiontoken=$token';
     var response =await http.get(Uri.parse(request));
     var data=jsonDecode(response.body);
     if(kDebugMode){
       print(data);
     }
     if(response.statusCode==200){
        setState(() {
          ListOfLocation=json.decode(response.body)['predictions'];
        });
     }else{
        throw Exception("Failed to load");
     }
   }catch(e){
     print(e.toString());
   }
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
        title: Text("Enter your location",style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold),),centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              border: Border.all(width: 2,color: Color(0xff2D6A4F)),
            ),
            child: TextFormField(
              controller: _searchcontroller,
              decoration: const InputDecoration(
                icon: Icon(Icons.search),
                //border: OutlineInputBorder(),
                border: InputBorder.none,
                hintText: "Enter Location",
                //labelText: "Location",
              ),
              onChanged: (value){
                setState(() {

                });
              },
            ),
          ),
          Visibility(
            visible: _searchcontroller.text.isEmpty?false:true,
            child: Expanded(child: ListView.builder(
              shrinkWrap: true,
              itemCount: ListOfLocation.length,
                itemBuilder: ( context,index){
                return GestureDetector(
                  onTap: (){},
                  child: Text(ListOfLocation[index]["description"],),
                );
            }
            )),
          ),
          Visibility(
            visible: _searchcontroller.text.isEmpty?true:false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: TextButton(onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
                }, child: Text("Use my current location",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18
                  ),)),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text('LAT: ${_currentPosition?.latitude ?? ""}'),
              // Text('LNG: ${_currentPosition?.longitude ?? ""}'),
              Text('ADDRESS: ${_currentAddress ?? ""}'),
            ],
          ),
      ],),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:scrapapp/screens/HomePage.dart';
//
// class LocationPage extends StatefulWidget {
// const LocationPage({super.key});
//
// @override
// State<LocationPage> createState() => _LocationPageState();
// }
//
// class _LocationPageState extends State<LocationPage> {
// final TextEditingController _searchController = TextEditingController();
//
// // Predefined list of locations
// List<String> predefinedLocations = [
// "Mumbai",
// "Delhi",
// "Bangalore",
// "Chennai",
// "Kolkata",
// "Pune",
// "Hyderabad",
// "Ahmedabad",
// "Jaipur",
// "Lucknow",
// ];
//
// List<String> filteredLocations = [];
//
// @override
// void initState() {
// super.initState();
// _searchController.addListener(_onSearchChanged);
// filteredLocations = predefinedLocations; // Show all locations by default
// }
//
// @override
// void dispose() {
// _searchController.removeListener(_onSearchChanged);
// _searchController.dispose();
// super.dispose();
// }
//
// void _onSearchChanged() {
// setState(() {
// if (_searchController.text.isEmpty) {
// filteredLocations = predefinedLocations;
// } else {
// filteredLocations = predefinedLocations
//     .where((location) => location
//     .toLowerCase()
//     .contains(_searchController.text.toLowerCase()))
//     .toList();
// }
// });
// }
//
// @override
// Widget build(BuildContext context) {
// return Scaffold(
// appBar: AppBar(
// backgroundColor: Theme.of(context).scaffoldBackgroundColor,
// leading: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// decoration: BoxDecoration(
// shape: BoxShape.circle,
// color: Colors.white,
// ),
// child: IconButton(
// icon: Icon(Icons.chevron_left, color: Colors.black),
// onPressed: () => Navigator.of(context).pop(),
// ),
// ),
// ),
// title: Text(
// "Enter your location",
// style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// ),
// centerTitle: true,
// ),
// body: Column(
// children: [
// // Search bar
// Container(
// margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
// padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(60),
// border: Border.all(width: 2, color: Color(0xff2D6A4F)),
// ),
// child: TextFormField(
// controller: _searchController,
// decoration: const InputDecoration(
// icon: Icon(Icons.search),
// border: InputBorder.none,
// hintText: "Enter Location",
// ),
// ),
// ),
//
// // List of filtered locations
// Expanded(
// child: ListView.builder(
// itemCount: filteredLocations.length,
// itemBuilder: (context, index) {
// return GestureDetector(
// onTap: () {
// Navigator.pushReplacement(
// context,
// MaterialPageRoute(builder: (context) => HomePage()),
// );
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(
// content: Text(
// "Selected Location: ${filteredLocations[index]}",
// ),
// ),
// );
// },
// child: ListTile(
// title: Text(
// filteredLocations[index],
// style: TextStyle(fontSize: 18),
// ),
// ),
// );
// },
// ),
// ),
//
// // Use current location button
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 8.0),
// child: Align(
// alignment: Alignment.topCenter,
// child: TextButton(
// onPressed: () {
// Navigator.pushReplacement(
// context,
// MaterialPageRoute(builder: (context) => HomePage()),
// );
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(content: Text("Using current location")),
// );
// },
// child: Text(
// "Use my current location",
// style: TextStyle(
// fontWeight: FontWeight.bold,
// color: Colors.black,
// fontSize: 18,
// ),
// ),
// ),
// ),
// ),
// ],
// ),
// );
// }
// }
