import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrapapp/Utility/BottomNavigation.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:scrapapp/Utility/global_helper.dart';
import 'package:scrapapp/screens/HomePage.dart';
import 'package:scrapapp/screens/Profie_Screens/Dashboard.dart';
import 'package:scrapapp/screens/Profie_Screens/MyAccount.dart';
import 'package:scrapapp/screens/Profie_Screens/PickUpDetails.dart';
import 'package:scrapapp/screens/Rate_Card.dart';
import 'package:scrapapp/screens/Recycle_Product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:scrapapp/Utility/constants.dart' as constant;

class MyPickUp extends StatefulWidget {
  const MyPickUp({super.key});

  @override
  State<MyPickUp> createState() => _MyPickUpState();
}

class _MyPickUpState extends State<MyPickUp>
    with SingleTickerProviderStateMixin {
  int _currentIndex=0;
  final String _Day='';
  TabController? _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  getschedulepickup(String user_id) async {
    try {
      var response = await http.get(Uri.parse(
        '${constant.apiLocalName}/pickupHistory?user_id=$user_id',
      ));
      log(response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var pickupData = responseData['schedule_data'];
        return pickupData;
      } else {
        return throw Exception('Failed to Fetch Schedule pickup details: ${response.statusCode}');
      }
    } on Exception catch (e) {
      print('Error during Fetch Schedule pickup details: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('My Pick Ups',
          style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w500,
        ),),
        centerTitle: true,
        bottom: TabBar(
          indicatorColor: Theme.of(context).primaryColor,
          controller: _tabController,
          tabs: [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Canceled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UpcomingPickUps(),
          CompletedPickUps(),
          CanceledPickUps(),
        ],
      ),
      // bottomNavigationBar: BottomNavigation(currentIndex: _currentIndex, onTap: _onTap),
    );
  }
}


class UpcomingPickUps extends StatefulWidget {
  @override
  State<UpcomingPickUps> createState() => _UpcomingPickUpsState();
}

class _UpcomingPickUpsState extends State<UpcomingPickUps> {
  // List<Map<String, dynamic>> scheduledPickups = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getpickupsummary().then((pickups){
    //   setState(() {
    //     scheduledPickups = pickups;
    //   });
    // });
    initial();
  }

  List? getSchedulePickUp;
  initial() async {
    getSchedulePickUp = await GlobalHelper().getschedulepickup(userProfile!.userID.toString());
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        final pickup = getSchedulePickUp==null?Container():getSchedulePickUp![index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: index == 0 ? Theme.of(context).primaryColor : Colors.grey,
                ),
                color: index == 0 ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Upcoming',
                          style: TextStyle(color: index == 0 ? Colors.white : Theme.of(context).shadowColor),
                        ),
                        Text(
                          // 'pick up id',
                          '${pickup['schedules_id']}',
                          style: TextStyle(color: index == 0 ? Colors.white : Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0), child: Align(
                    alignment: Alignment.topLeft,
                    child:
                    MyBigText(title: '${formatDate(pickup['pickup_date'])}', color: index == 0 ? Colors.white : Theme.of(context).primaryColor),
                    ),
                  ),
                  Divider(
                    color: index == 0 ? Colors.white : Colors.grey[300],
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyTextButton(
                            title: 'Reschedule',
                            onPressed: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>PickUpDetails(
                              //             // Day: '${formatDate(pickup['date'])}',
                              //             Day: DateTime.parse(pickup['date']),
                              //             TimeSlot: pickup['slot'],
                              //             Weight: '${pickup['weight']}',
                              //             Notes: '${pickup['notes']}',
                              //             items: List<String>.from(pickup['items']),
                              //           )));print('${formatDate(pickup['date'])}');
                            },
                            color: Theme.of(context).shadowColor,),

                        TextButton(
                          onPressed: () {

                          },
                          child: Text('View Details',
                            style: TextStyle(
                              color: index == 0 ? Colors.white : Theme.of(context).primaryColor,
                            ),
                          ),
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

class CompletedPickUps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: index == 0 ? Theme.of(context).primaryColor : Colors.grey,
                ),
                color: index == 0 ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Completed',
                          style: TextStyle(color: index == 0 ? Colors.white :Theme.of(context).shadowColor),
                        ),
                        Text(
                          'Pick Up Id',
                          style: TextStyle(color: index == 0 ? Colors.white : Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0), child: Align(
                    alignment: Alignment.topLeft,
                    child:
                    Text('Day',
                      style: TextStyle(fontSize: 20, color: index == 0 ? Colors.white : Theme.of(context).primaryColor),
                    ),
                  ),
                  ),
                  Divider(
                    color: index == 0 ? Colors.white : Colors.grey[300],
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                          ),
                          child: TextButton(
                            onPressed: () {

                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>PickUpDetails(
                              // )));
                            },
                            child: MySmallText(title: 'Reschedule',color: Colors.white,),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>PickUpDetails()));
                          },
                          child: Text('View Details',
                            style: TextStyle(
                              color: index == 0 ? Colors.white : Theme.of(context).primaryColor,
                            ),
                          ),
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

class CanceledPickUps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: index == 0 ? Theme.of(context).primaryColor : Colors.grey,
                ),
                color: index == 0 ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Canceled',
                          style: TextStyle(color: index == 0 ? Colors.white : Theme.of(context).shadowColor),
                        ),
                        Text(
                          'Pick Up Id',
                          style: TextStyle(color: index == 0 ? Colors.white : Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0), child: Align(
                    alignment: Alignment.topLeft,
                    child:
                    Text('Day',
                      style: TextStyle(fontSize: 20, color: index == 0 ? Colors.white : Theme.of(context).primaryColor),
                    ),
                  ),
                  ),
                  Divider(
                    color: index == 0 ? Colors.white : Colors.grey[300],
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                          ),
                          child: TextButton(
                            onPressed: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>PickUpDetails()));
                            },
                            child: MySmallText(title: 'Reschedule',color: Colors.white,),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>PickUpDetails()));
                          },
                          child: Text('View Details',
                            style: TextStyle(
                              color: index == 0 ? Colors.white : Theme.of(context).primaryColor,
                            ),
                          ),
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

I want according status data pending then show list of data upcomming if sataus complete then show in completed tab and if cancel then showed cancel tab
This is getschedulepickup data
"schedule_data":[ {"schedules_id":15,"pickup_date":"2026-12-01","start_time":"11:30","end_time":"12:00","schedule_items_id":11,"product_id":1,"product_name":"bottles","product_title":"dumy bottel","product_description":"1 box  5kg near about","product_img":"1734584700_dumy.jpg","category_id":2,"unit_id":1,"est_weight":"35","note":null,"address_id":10,"title":"Home","addressline1":"drggghvjfugughghfjggjgififjgjgiguffigigic","addressline2":"fggfghggvjgogogogcigococofihihihigohihy","city":"Dombivli","pincode":"400612","status":"complete"},
{"schedules_id":16,"pickup_date":"2026-12-01","start_time":"15:00","end_time":"15:30","schedule_items_id":13,"product_id":1,"product_name":"bottles","product_title":"dumy bottel","product_description":"1 box  5kg near about","product_img":"1734584700_dumy.jpg","category_id":2,"unit_id":1,"est_weight":"45","note":"yes","address_id":10,"title":"Home","addressline1":"drggghvjfugughghfjggjgififjgjgiguffigigic","addressline2":"fggfghggvjgogogogcigococofihihihigohihy","city":"Dombivli","pincode":"400612","status":"pending"}],




