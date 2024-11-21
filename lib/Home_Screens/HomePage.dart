import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:scrapapp/Utility/BottomNavigation.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:gap/gap.dart';
import 'package:scrapapp/screens/Profie_Screens/MyAccount.dart';
import 'package:scrapapp/screens/Profie_Screens/PickUpDetails.dart';
import 'package:scrapapp/screens/Rate_Card.dart';
import 'package:scrapapp/screens/Rate_Card_PickUp.dart';
import 'package:scrapapp/screens/Recycle_Product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  // final List<Map<String, String>> selecteditems;
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex=0;
  String item1='First';
  String item2='Second';
  List<String>? RateItemsTitles;
  String? Daytimeslot;
  String? Daytimeslot1;
  final DateTime _now = DateTime.now();
  List<Map<String, dynamic>> scheduledPickups = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getRateItems();
    _saveRateItems();
    _getScheduledPickups().then((pickups){
      setState(() {
        scheduledPickups = pickups;
      });
    });
  }

  Future<List<String>?> _getRateItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? Items=prefs.getString('RateItemsTitles');
    final String? Dayslot=prefs.getString('Day');
    setState(() {
      DateTime? parsedDate;
      if (Dayslot != null) {
              parsedDate = DateFormat("MMM d,yy").parse(Dayslot); // Adjust the format as needed
            }
      Daytimeslot = parsedDate != null ? DateFormat('MMM d,yy').format(parsedDate) : 'No date';
      RateItemsTitles = Items?.split(',');
    });

    print(RateItemsTitles);
    print('hey your day ${Daytimeslot}');
  }

  Future<List<Map<String, dynamic>>> _getScheduledPickups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? pickups = prefs.getStringList('scheduledPickups');

    if (pickups != null) {
      return pickups.map((pickup) => jsonDecode(pickup) as Map<String, dynamic>).toList();
    }
    return [];
  }

  Future<void> _saveRateItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  String formatDate(String isoDate) {
  DateTime dateTime = DateTime.parse(isoDate);
  return DateFormat('d MMM').format(dateTime);
}

  void _onTap(int index){
    setState(() {
      _currentIndex=index;
    });
    switch(index){
      case 0:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context)=>HomePage()));
        break;
      case 1:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context)=>RateCard()));
        break;
      case 2:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context)=>RecycleProduct()));
        break;
      case 3:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context)=>MyAccount()));
        break;
    }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            Image.asset("assets/icons/Munich_center.png"),
            Gap(10),
            MySmallText(title: "Munich Center",isBold: false,color: Colors.black,),
            Gap(4),
            PopupMenuButton(
              child: Container(
                child: Icon(Icons.keyboard_arrow_down_sharp),
              ),
                itemBuilder: (context)=>[
              PopupMenuItem(child: Text("First data")),
              PopupMenuItem(child: Text("second data")),
            ],onSelected: (value){
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("$value item Clicked")));
            },),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}
              , icon: Icon(Icons.notifications_none_sharp))
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
               Container(
                 margin: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                 height: 180,
                 width: double.infinity,
                 decoration: BoxDecoration(
                   color: Color(0xffF4A261),
                 ),
                 child: Padding(
                   padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
                   child: SingleChildScrollView(
                     scrollDirection: Axis.horizontal,
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         Padding(
                           padding: const EdgeInsets.symmetric(vertical: 8.0),
                           child: Column(
                             children: [
                               MySmallText(title: "Turn your scrap into cash!",isBold: true,color: Colors.white,),
                               SizedBox(height: 15,),
                               MySmallText(title: "Schedule a pickup today and\n make recycling effortless.",isBold: false,color: Colors.white,),
                             ],
                           ),
                         ),
                         Image.asset("assets/home_content.png",fit: BoxFit.cover,width: 135,)
                       ],
                     ),
                   ),
                 ),
               ),
                Padding(padding: EdgeInsets.only(top: 160,right: 50,left: 50,bottom: 5),
                //Positioned(top: 140,right: 10,left: 10,bottom: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RateCardPickup()));
                        },
                        child: MySmallText(title: "Schedule Pickup Now",color: Colors.grey, isBold: true),
                                  ),
                        IconButton(onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>RateCardPickup()));
                        }, icon: Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 15,))
                      ],
                    ),
                  ),
                ),
            
            
              ],
            ),

            //Statistics Section
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              child: Align(alignment: AlignmentDirectional.centerStart,
                  child: MyBigText(title: "Statistics",isBold: true,color: Colors.black,)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStatisticsCard("Scrap Collectedfjgbjfbgfgnfgnfnddfjkgbjkvgbfkbgbfk", "145 KG", Icons.recycling_sharp, HomePage()),
                    _buildStatisticsCard("Wallet Balance", "1200 Coins", Icons.monetization_on_sharp, HomePage()),
                    _buildStatisticsCard("Completed Changes", "10", Icons.fire_truck_sharp, HomePage())
                  ],
                ),
              ),
            ),

            //Category Section
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                  child: Align(alignment: AlignmentDirectional.centerStart,
                      child: MyBigText(title: "Products By Category",isBold: true,color: Colors.black,)),
                ),
                TextButton(onPressed: () {}, child: MySmallText(title: "See All",isBold: true,))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryCard("Category", HomePage()),
                    _buildCategoryCard("Category", HomePage()),
                    _buildCategoryCard("Category", HomePage()),
                    _buildCategoryCard("Category", HomePage()),
                    _buildCategoryCard("Category", HomePage()),
                    _buildCategoryCard("Category", HomePage()),
                    _buildCategoryCard("Category", HomePage()),
                    _buildCategoryCard("Category", HomePage()),
                  ],
                ),
              ),
            ),

            //Ticket Section
            SizedBox(height: 10,),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: scheduledPickups.length,
              itemBuilder: (context, index) {
                final pickup = scheduledPickups[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Card(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.greenAccent[100],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                                    child: Text(
                                      'In Progress',
                                      style: TextStyle(color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.orange[50],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical:4,horizontal: 8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.watch_later_outlined,color: Color(0xffF4A261),size: 20,),
                                        MyExtraSmallText(title:'${formatDate(pickup['date'])}',color: Color(0xffF4A261),),
                                        Gap(5),
                                        MyExtraSmallText(title: '${pickup['slot']}',color: Color(0xffF4A261)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Wrap(
                              children: (pickup['items'] as List).map((item) =>
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal:4.0),
                                    child: Chip(
                                      label: Text(item),
                                      backgroundColor: Color(0xffDBEAE3),
                                    ),
                                  ),
                              ).toList(),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: TextButton(
                                    onPressed: () async {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PickUpDetails()));
                                    },
                                    child: MyExtraSmallText(title: 'Reschedule',color:Colors.white,),
                                  ),
                                ),
                                Gap(15),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                                    },
                                    child: Text('Cancel',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
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
            ),

          ],
        ),
      ),
       bottomNavigationBar: BottomNavigation(currentIndex: _currentIndex, onTap: _onTap),
    );
  }

  Widget _buildStatisticsCard(String title,String value,IconData icon,Widget destination){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
      },
      child: Container(
        height: 200,
        width: 150,
        margin: EdgeInsets.only(right: 16.0),
        padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
          color: Colors.green[400],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8,),
            Container(
              child: Text(title,
                style: TextStyle(
                fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 17
              ),maxLines: 2,overflow: TextOverflow.ellipsis),
            ),
            SizedBox(height: 8,),
            MyBigText(title: value,isBold: true,color: Colors.white,),
            SizedBox(height: 8,),
            Align(alignment: Alignment.bottomRight,
                child: Icon(icon,size: 60,)),

          ],
        ),
      ),
    );


  }

  Widget _buildCategoryCard(String category,Widget destination){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
      },child: Container(
      height: 100,
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
          ),
          SizedBox(height: 8.0),
          MyExtraSmallText(title: category),
        ],
      ),
    ),
    );
  }

  Widget _buildStatusCard(String title,IconData icon){
    return GestureDetector(
          child: Container(
            height: 300,
            width: double.infinity,
            margin: EdgeInsets.only(right: 16.0),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.topLeft,
                    child: Icon(icon)),
                MyBigText(title: title,isBold: true,color: Colors.blueAccent,),
              ],
            ),
          ),
    );
  }
}




