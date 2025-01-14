import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrapapp/Utility/BottomNavigation.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:gap/gap.dart';
import 'package:scrapapp/Utility/global_helper.dart';
import 'package:scrapapp/screens/HomePage.dart';
import 'package:scrapapp/screens/Profie_Screens/MyAccount.dart';
import 'package:scrapapp/screens/Rate_Card.dart';
import 'package:scrapapp/screens/Rate_Card_PickUp.dart';
import 'package:scrapapp/screens/Recycle_Product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scrapapp/Utility/constants.dart' as constants;

class PickUpDetails extends StatefulWidget {
  // final DateTime Day;
  final String startTime;
  final String endTime;
  final String date;
  final String unitId;
  final String weight;
  final String notes;
  // List <String> items=[];
  // final Map<String, dynamic>? existingPickup;
  final String pickupId;
  PickUpDetails({super.key,
    required this.pickupId,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.weight,
    required this.notes, required this.unitId,
  // required this.items, this.existingPickup
  });

  @override
  State<PickUpDetails> createState() => _PickUpDetailsState();
}

class _PickUpDetailsState extends State<PickUpDetails> {
  int _currentIndex=0;
  List<Map<String, dynamic>> scheduledPickups = [];
  List units=[];

  initial() async {
    units = await GlobalHelper().getUnits();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getScheduledPickups().then((pickups){
    //   setState(() {
    //     scheduledPickups = pickups;
    //     print(pickups);
    //   });
    // });
    initial();
  }

  // Future<List<Map<String, dynamic>>> _getScheduledPickups() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? pickups = prefs.getStringList('scheduledPickups');
  //
  //   if (pickups != null) {
  //     return pickups.map((pickup) => jsonDecode(pickup) as Map<String, dynamic>).toList();
  //
  //   }
  //   return [];
  // }


  @override
  Widget build(BuildContext context) {
    final uniqueSelectedItems = widget.selectedItems.toSet().toList();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: myappbar(context, "Pick Up Details",true),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child:
                Text(
                  '${formatDate1(widget.date)}',
                  // widget.Day != null ? DateFormat('yyyy-MM-dd').format(widget.Day!) : 'Date not available',
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
                  //here want timeslot
                  child: Text(
                    '${widget.startTime} - ${widget.endTime}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Container(
            //   margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            //   height: 160,
            //   child: widget.items.isNotEmpty
            //       ?
            //   ListView.builder(
            //       itemCount: 1,
            //       itemBuilder: (context, index) {
            //         final item = widget.items[index];
            //         return Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 4.0),
            //           child: Wrap(
            //             children: widget.items.map((item) =>
            //                 Chip(
            //                   label: Text(item),
            //                   backgroundColor: Color(0xffDBEAE3),
            //                   onDeleted: () {
            //                     setState(() {
            //                       widget.items.remove(item);
            //                     });
            //                     debugPrint("Deleted item: ${item}");
            //                   },
            //                   avatar: Icon(Icons.person),
            //                 )
            //             ).toList(),
            //             spacing: 8,
            //           ),
            //         );
            //       }
            //   )
            //   :
            //   Center(child: Text("No items selected.")),
            // ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                // color: Colors.white,
                height: 200,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: uniqueSelectedItems.map((item) {
                      return Chip(
                        label: Text(item.rateItemsName!),
                        backgroundColor: const Color(0xffDBEAE3),
                        onDeleted: () {
                          setState(() {
                            widget.selectedItems.remove(item);
                          });
                          debugPrint("Deleted item: ${item.rateItemsName}");
                        },
                        avatar: const Icon(Icons.person),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
              child: Row(
                children: [
                  MyMediumText(title: "Estimate Weight :",isBold: true,color: Colors.black,),
                  Gap(20),
                  MyMediumText(
                    //getunits function get unit name from unit id
                    title: "${widget.weight} " "${widget.unitId}",
                    isBold: false,
                    color: Colors.black,)
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
              height: 150,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical:10,horizontal: 10),
              decoration: BoxDecoration(
                color: Color(0xffE9E9E9),
                border: Border.all(width: 2,color: Colors.white),
                // borderRadius: BorderRadius.circular(16)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MySmallText(
                    title: "${widget.notes}"
                ),
              ),
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MyEvalutedButton(title: "Reschedule", onPressed: () async{
                  // SharedPreferences prefs = await SharedPreferences.getInstance();
                  // await prefs.setString('selectedItems', jsonEncode(widget.items));
                  // await prefs.setString('weight', widget.Weight);
                  // await prefs.setString('notes', widget.Notes);
                  // await prefs.setString('date', widget.Day.toIso8601String());
                  // print("Date${widget.Day}");
                  // await prefs.setString('timeSlot', widget.TimeSlot.toString());
                  // print('ScheduleTimeslot1:${widget.TimeSlot}');
                  // await prefs.setString('existing', '${widget.existingPickup}');
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => RateCardPickup(
                  //   selectedItems: widget.items,
                  //   scheduleWeight: widget.Weight,
                  //   scheduleDate: widget.Day,
                  //   scheduleTimeslot: widget.TimeSlot,
                  //   scheduleNotes: widget.Notes,
                  //   existingPickup: widget.existingPickup,
                  // )));
                },),
                MyEvalutedButton(
                  title: "Cancel",
                  onPressed: () {
                    // Map<String, dynamic> pickup = {
                    //   'date': widget.Day,
                    //   'slot': widget.TimeSlot,
                    //   'weight': widget.Weight,
                    //   'notes': widget.Notes,
                    //   'items': widget.items,
                    // };
                    // _cancel(pickup);
                  },
                ),
              ],
            )
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigation(currentIndex: _currentIndex, onTap: _onTap),
    );
  }
}


import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrapapp/Utility/BottomNavigation.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:scrapapp/Utility/global_helper.dart';
import 'package:scrapapp/models/schedule_Model.dart';
import 'package:scrapapp/screens/HomePage.dart';
import 'package:scrapapp/screens/Profie_Screens/Dashboard.dart';
import 'package:scrapapp/screens/Profie_Screens/MyAccount.dart';
import 'package:http/http.dart' as http;
import 'package:scrapapp/Utility/constants.dart' as constant;
import 'package:scrapapp/screens/Profie_Screens/PickUpDetails.dart';

class MyPickUp extends StatefulWidget {
  const MyPickUp({super.key});

  @override
  State<MyPickUp> createState() => _MyPickUpState();
}

class _MyPickUpState extends State<MyPickUp> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  // ScheduleModel? scheduleModel;
  List<dynamic> allPickups = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    print('Test');
    fetchPickups();
    print('Test1');
    print(fetchPickups().toString());
    initial();
  }

  List<ScheduleModel>? scheduleModel;
  initial() async {
    scheduleModel = await GlobalHelper().getschedulepickup(userProfile!.userID.toString());
    setState(() {});
  }

  getschedulepickup(String user_id) async {
    var response = await http.get(
        Uri.parse('${constant.apiLocalName}/pickupHistory?user_id=$user_id',
        ));
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var pickupData = responseData['schedule_data'];
      List<ScheduleModel>? pickUpDataList;
      pickUpDataList = pickupData
          .map((items) => ScheduleModel.from(items))
          .toList()
          .cast<ScheduleModel>();
      print('Pickup Api Data Updated');
      print(responseData);
      return pickUpDataList;
    }else{
      print('Pickup Api Data Not Updated');
    }
  }

  fetchPickups() async {
    String userId = userProfile!.userID.toString();
    allPickups = await getschedulepickup(userId);
    setState(() {});
    print(allPickups);
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
          UpcomingPickUps(pickups: allPickups.where((pickup) => pickup['status'] == 'pending').toList()),
          CompletedPickUps(pickups: allPickups.where((pickup) => pickup['status'] == 'complete').toList()),
          CanceledPickUps(pickups: allPickups.where((pickup) => pickup['status'] == 'canceled').toList()),
        ],
      ),
    );
  }
}

class UpcomingPickUps extends StatelessWidget {
  final List<dynamic> pickups;

  UpcomingPickUps({required this.pickups});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pickups.length,
      itemBuilder: (context, index) {
        final pickup = pickups[index];
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
                          '${pickup['schedules_id']}',
                          style: TextStyle(color: index == 0 ? Colors.white : Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0), child: Align(
                    alignment: Alignment.topLeft,
                    child: MyBigText(title: '${formatDate1(pickup['pickup_date'])}', color: index == 0 ? Colors.white : Theme.of(context).primaryColor),
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
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PickUpDetails(
                                    pickupId: pickup['schedules_id'].toString(),
                                    startTime: pickup['start_time'].toString(),
                                    endTime: pickup['end_time'].toString(),
                                    date: pickup['pickup_date'].toString(),
                                    notes: pickup['note'].toString(),
                                    weight: pickup['est_weight'].toString(),
                                    unitId: pickup['unit_id'].toString(),
                                  ),)
                            );
                          },
                          color: Theme.of(context).shadowColor,
                        ),
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
  final List<dynamic> pickups;

  CompletedPickUps({required this.pickups});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pickups.length,
      itemBuilder: (context, index) {
        final pickup = pickups[index];
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
                          style: TextStyle(color: index == 0 ? Colors.white : Theme.of(context).shadowColor),
                        ),
                        Text(
                          '${pickup['schedules_id']}',
                          style: TextStyle(color: index == 0 ? Colors.white : Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0), child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('${formatDate(pickup['pickup_date'])}',
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
                            },
                            child: MySmallText(title: 'Reschedule', color: Colors.white,),
                          ),
                        ),
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

class CanceledPickUps extends StatelessWidget {
  final List<dynamic> pickups;

  CanceledPickUps({required this.pickups});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pickups.length,
      itemBuilder: (context, index) {
        final pickup = pickups[index];
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
                          '${pickup['schedules_id']}',
                          style: TextStyle(color: index == 0 ? Colors.white : Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0), child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('${formatDate(pickup['pickup_date'])}',
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
                            },
                            child: MySmallText(title: 'Reschedule', color: Colors.white,),
                          ),
                        ),
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

class ScheduleModel{
  int? orderItemsID;
  String? pickupDate;
  String? startTime;
  String? endTime;
  int? itemsName;
  int? unitId;
  String? totWeight;
  String? notes;
  int? addressId;
  String? status;

  ScheduleModel({
    this.orderItemsID,
    this.pickupDate,
    this.startTime,
    this.endTime,
    this.itemsName,
    this.unitId,
    this.totWeight,
    this.notes,
    this.addressId,
    this.status,
  });

  ScheduleModel.from(Map<String,dynamic>map)
      : orderItemsID=map['schedules_id'],
        pickupDate=map['pickup_date'],
        startTime=map['start_time'],
        endTime=map['end_time'],
        itemsName=map['product_id'],
        unitId=map['unit_id'],
        totWeight=map['est_weight'],
        notes=map['note'],
        addressId=map['address_id'],
        status=map['status'];

  Map<String,Object?>toMap(){
    return{
      'schedules_id':orderItemsID,
      'pickup_date':pickupDate,
      'start_time':startTime,
      'end_time':endTime,
      'product_id':itemsName,
      'unit_id':unitId,
      'est_weight':totWeight,
      'note':notes,
      'address_id':addressId,
      'status':status,
    };
  }

}


{success: true, message: schedules history fetched successfully., schedule_data: [{schedules_id: 14, pickup_date: 2026-12-01, start_time: 11:30, end_time: 12:00, schedule_items_id: 9, product_id: 1, product_name: bottles, product_title: dumy bottel, product_description: 1 box  5kg near about, product_img: 1734584700_dumy.jpg, category_id: 2, unit_id: 1, est_weight: 35, note: gg, address_id: 10, title: Home, addressline1: drggghvjfugughghfjggjgififjgjgiguffigigic, addressline2: fggfghggvjgogogogcigococofihihihigohihy, city: Dombivli, pincode: 400612, status: pending}, {schedules_id: 14, pickup_date: 2026-12-01, start_time: 11:30, end_time: 12:00, schedule_items_id: 10, product_id: 2, product_name: fridge, product_title: steel and composer weight 6kg, product_description: fridge condition is good problem cooling, product_img: 1734605475_fridge.jpg, category_id: 5, unit_id: 1, est_weight: 35, note: gg, address_id: 10, title: Home, addressline1: drggghvjfugughghfjggjgififjgjgiguffigigic, addressline2: fggfghggvj

  I want getschedulepickup came from schedule model and when reshedule onclick navigate to pickupdeatail page with all data in single paramete
