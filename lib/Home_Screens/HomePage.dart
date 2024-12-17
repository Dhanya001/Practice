import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:scrapapp/screens/HomePage.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:scrapapp/Utility/constants.dart' as constants;



class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final TextEditingController _searchcontroller=TextEditingController();
  // final String token='1234567890';
  var uuid = Uuid();
  // List<dynamic>ListOfLocation=[];

  String? _currentAddress;
  Position? _currentPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentPosition();
    _handleLocationPermission();
    _searchcontroller.addListener((){});
    // _onchange();
  }



  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      constants.showCustomSnackBar1(context, "Location services are disabled. Please enable the services");
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        constants.showCustomSnackBar1(context, "Location permissions are denied");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      constants.showCustomSnackBar1(context, "Location permissions are permanently denied, we cannot request permissions.");
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
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


  List<dynamic> ListOfLocation = [
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
            // visible: _searchcontroller.text.isEmpty?true:false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: TextButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CurrentUserLocation()));
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
              Text('LAT: ${_currentPosition?.latitude ?? ""}'),
              Text('LNG: ${_currentPosition?.longitude ?? ""}'),
              Text('ADDRESS: ${_currentAddress ?? ""}'),
            ],
          ),
          SizedBox(height: 10,),
          Visibility(
            // visible: _searchcontroller.text.isEmpty?false:true,
            child: Expanded(
                child: ListView.builder(
                shrinkWrap: true,
                itemCount: ListOfLocation.length,
                itemBuilder: ( context,index){
                  return GestureDetector(
                    onTap: (){},
                    child: Center(child: MySmallText(title:ListOfLocation[index],color: Colors.black,isBold: true,)),
                  );
                }
            )),
          ),
        ],),
    );
  }
}



class CurrentUserLocation extends StatefulWidget {
  const CurrentUserLocation({super.key});

  @override
  State<CurrentUserLocation> createState() => _CurrentUserLocationState();
}

class _CurrentUserLocationState extends State<CurrentUserLocation> {
  late GoogleMapController googleMapController;
  static const CameraPosition initialCameraPosition=CameraPosition(target: LatLng(19.2530317,73.1366),zoom: 14);

  Set<Marker>markers={};

  Future<Position> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      constants.showCustomSnackBar1(context, "Location services are disabled. Please enable the services");
      // return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        constants.showCustomSnackBar1(context, "Location permissions are denied");
        // return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      constants.showCustomSnackBar1(context, "Location permissions are permanently denied, we cannot request permissions.");
      // return false;
    }
    Position position=await Geolocator.getCurrentPosition();
    return position;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: false,
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller){
          googleMapController=controller;
      },),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          Position position=await _handleLocationPermission();
        googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude),zoom: 14)));

        markers.clear();
        markers.add( Marker(markerId: MarkerId('currentlocation'),position: LatLng(position.latitude, position.longitude)));

        setState(() {});

      },label: Text("current Location"),),
    );
  }
}
//I want show list with onclick for particular city with some vertical spacing in list and search bar functionality then particular location came and currentLocation class getting error
