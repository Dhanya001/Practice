import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:scrapapp/Utility/BottomNavigation.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:gap/gap.dart';
import 'package:scrapapp/Utility/global_helper.dart';
import 'package:scrapapp/models/User_Model.dart';
import 'package:scrapapp/screens/Profie_Screens/Dashboard.dart';
import 'package:scrapapp/screens/Profie_Screens/MyAccount.dart';
import 'package:scrapapp/screens/Profie_Screens/PickUpDetails.dart';
import 'package:scrapapp/screens/Rate_Card.dart';
import 'package:scrapapp/screens/Rate_Card_PickUp.dart';
import 'package:scrapapp/screens/Recycle_Product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scrapapp/Utility/constants.dart' as constant;

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex=0;
  String item1='First';
  String item2='Second';
  List<String>? rateItemsTitles;
  List<Map<String, dynamic>> scheduledPickups = [];
  // List<String> scheduledPickups=[];
  bool isNetConnected=true;
  // UserModel? userProfile;
  String? userid;

  List categoryList=[];
  initial() async {
    categoryList = await GlobalHelper().getCategory();
    setState(() {});
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  StreamSubscription<InternetStatus>? listener;
  checkInternet() async {
    bool isInternetConnected= await constant.isInternet();
    if(isInternetConnected){
      // initial();
    }else{
      setState(() {
        isNetConnected=false;
      });
      constant.showCustomSnackBarOffline(context);

      listener =
          InternetConnection().onStatusChange.listen((InternetStatus status) {
            switch (status) {
              case InternetStatus.connected:
                constant.showCustomSnackBarOnline(context);
                setState(() {
                  isNetConnected=true;
                });
                // initial(isBackToOnline: true);
                break;
              case InternetStatus.disconnected:
                break;
            }
          });}
  }


  

  Future<bool> _showExitDialog(BuildContext context) async {
    bool? exitApp=await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
        return exitApp??false;
  }

  void _reschedulePickup(Map<String, dynamic> pickup) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PickUpDetails(
          Day: DateTime.parse(pickup['date']),
          TimeSlot: pickup['slot'],
          Weight: pickup['weight'],
          Notes: pickup['notes'],
          items: List<String>.from(pickup['items']),
          existingPickup: pickup,
        ),
      ),
    );
  }

  void _cancelPickup(Map<String, dynamic> pickup) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? existingPickups = prefs.getStringList('scheduledPickups');

    if (existingPickups != null) {
      existingPickups.removeWhere((item) {
        Map<String, dynamic> pickupData = jsonDecode(item);
        return pickupData['date'] == pickup['date'] &&
            pickupData['slot'] == pickup['slot'] &&
            pickupData['weight'] == pickup['weight'] &&
            pickupData['notes'] == pickup['notes'];
      });
      await prefs.setStringList('scheduledPickups', existingPickups);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pickup canceled successfully')));
      // _getScheduledPickups();
      // Navigator.push(context, MaterialPageRoute(builder: (context)=>const Dashboard()));
    }
  }

  @override
  dispose() {
    listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            Image.asset("assets/icons/Munich_center.png"),
            const Gap(10),
            const MySmallText(title: "Munich Center",isBold: false,color: Colors.black,),
            const Gap(4),
            PopupMenuButton(
              child: const Icon(Icons.keyboard_arrow_down_sharp),
                itemBuilder: (context)=>[
              const PopupMenuItem(child: Text("First data")),
              const PopupMenuItem(child: Text("second data")),
            ],onSelected: (value){
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("$value item Clicked")));
            },),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}
              , icon: const Icon(Icons.notifications_none_sharp))
        ],
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async{
        // print(userProfile!.userPhone);
        // print(userProfile!.uname);
        // print(userProfile!.userEmail);
        var getratecard=await GlobalHelper().getRateCards();
        print('Rate Card:$getratecard');
        var getcategory=await GlobalHelper().getCategory();
        print('Category:$getcategory');
      },),
      body: isNetConnected==false?
      Container():
      SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
               Container(
                 margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                 height: 180,
                 width: double.infinity,
                 decoration: BoxDecoration(
                   color: Theme.of(context).shadowColor,
                 ),
                 child: Row(
                   children: [
                     const Expanded(flex: 7,
                       child: Padding(
                         padding: EdgeInsets.only(top: 10,left: 10),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             MySmallText(title: "Turn your scrap into cash!",isBold: true,color: Colors.white,),
                             SizedBox(height: 15,),
                             MyExtraSmallText(title: "Schedule a pickup today and make recycling effortless.",isBold: false,color: Colors.white,),
                           ],
                         ),
                       ),
                     ),
                     Expanded(flex: 5,
                         child: Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 4.0),
                           child: Image.asset("assets/home_content.png",fit: BoxFit.cover,),
                         ))
                   ],
                 ),
               ),
                Padding(padding: const EdgeInsets.only(top: 160,right: 50,left: 50,bottom: 5),
                //Positioned(top: 140,right: 10,left: 10,bottom: 5,
                  child: InkWell(
                    onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RateCardPickup(
                          selectedItems: const [],
                          scheduleWeight: '',
                          scheduleDate: DateTime.now(),
                          scheduleTimeslot: 0,
                          scheduleNotes: '',
                        )));
                  },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           MySmallText(title: "Schedule Pickup Now       ",color: Colors.grey, isBold: true),
                           Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 15,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),


              ],
            ),

            //Statistics Section
            const SizedBox(height: 10,),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: const Align(alignment: AlignmentDirectional.centerStart,
                  child: MyBigText(title: "Statistics",isBold: true,color: Colors.black,)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // _buildStatisticsCard("Scrap Collected", "145 KG", "assets/image4.png", const HomePage()),
                    // _buildStatisticsCard("Wallet Balance", "1200 Coins", "assets/image5.png", const HomePage()),
                    // _buildStatisticsCard("Completed Pickups", "10", "assets/image6.png", const HomePage())
                    _buildStatisticsCard("Scrap Collected fjgbjfbgfgnfgnfnddfjkgbjkvgbfkbgbfk", "145 KG", 'assets/recycle.png', RecycleProduct()),
                    _buildStatisticsCard("Wallet \nBalance", "1200 Coinsdegdeeeeeeeee", 'assets/doller.png', RecycleProduct()),
                    _buildStatisticsCard("Completed Changes", "10", 'assets/truck.png', RecycleProduct())
                  ],
                ),
              ),
            ),
            // Container(
            //   color: Colors.lightBlueAccent,
            //   child: SvgPicture.asset("assets/image4.svg"),
            // ),

            //Category Section
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                  child: const Align(alignment: AlignmentDirectional.centerStart,
                      child: MyBigText(title: "Products By Category",isBold: true,color: Colors.black,)),
                ),
                TextButton(onPressed: () {}, child: const MySmallText(title: "See All",isBold: true,))
              ],
            ),
            
            ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
              return _buildCategoryCard("category", RecycleProduct());
            },),

            //Ticket Section
            const SizedBox(height: 10,),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: scheduledPickups.length,
              // itemCount:1,
              itemBuilder: (context, index) {
                final pickup = scheduledPickups[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
                                    child:MyExtraSmallText(title:
                                      'In Progress',
                                      color: Theme.of(context).primaryColor,
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
                                        Icon(Icons.watch_later_outlined,color: Theme.of(context).shadowColor,size: 20,),
                                        MyExtraSmallText(title:'${formatDate(pickup['date'])}',color: Theme.of(context).shadowColor,),
                                        const Gap(5),
                                        MyExtraSmallText(
                                          title: getSlotTitle(pickup),
                                          color:Theme.of(context).shadowColor),
                                            // title: '${_timeSlots[int.parse(pickup['slot'].toString())]}',
                                            // color: Color(0xffF4A261)),
                                        // MyExtraSmallText(title: '${pickup['slot']}',color: Color(0xffF4A261)),
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
                                      backgroundColor: const Color(0xffDBEAE3),
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
                                MyTextButton(
                                    title: 'Reschedule',
                                    onPressed: () => _reschedulePickup(pickup),
                                    color: Theme.of(context).primaryColor,
                                ),
                                MyTextButton(
                                    title: 'Cancel',
                                    onPressed: () => _cancelPickup(pickup),
                                    color: Colors.red)
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
       // bottomNavigationBar: Dashboard(userProfile: widget.userProfile!),
    );
  }
  // Widget _buildStatisticsCard(String title,String value,IconData icon,Widget destination){
  Widget _buildStatisticsCard(String title,String value,String symbol,Widget destination){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
      },
      child: Container(
        height: 200,
        width: 150,
        margin: const EdgeInsets.only(right: 16.0),
        // padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [
        Color(0xff2D6A4F),
        Color(0xff58D09B),
      ]),
          // color: Colors.green[400],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 50,
                child: Text(title,
                  style: const TextStyle(
                  fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16
                ),maxLines: 2,overflow: TextOverflow.ellipsis),
              ),
            ),
            // const SizedBox(height: 4,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(value,style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                  fontSize: 17
              ),overflow: TextOverflow.ellipsis,),
              // MySmallText(title: value,isBold: true,color: Colors.white,),
            ),
            // const SizedBox(height: 8,),
            Align(alignment: Alignment.bottomRight,
                // child: Container(color: Colors.red,
                    // child: SvgPicture.asset("assets/"+svg,width: 50,height: 50,)),),
    // child: Icon(icon,size:80,color: Color(0xff2D6A4F),),
              child: Image.asset(symbol,height: 98,),
            ),],
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
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(height: 8.0),
          MyExtraSmallText(title: category),
        ],
      ),
    ),
    );
  }
}

//i want category list view with circleavatar with axis.horizontal category length came from getcategory 
// api give me proper without body layout error
