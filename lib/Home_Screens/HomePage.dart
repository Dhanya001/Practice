This is homepage

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
    checkInternet();
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
        // var getratecard=await GlobalHelper().getRateCards();
        // print('Rate Card:$getratecard');
        // var getcategory=await GlobalHelper().getCategory();
        // print('Category:$getcategory');
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
                    statisticsCard("Scrap Collected fjgbjfbgfgnfgnfnddfjkgbjkvgbfkbgbfk", "145 KG", 'assets/recycle.png', RecycleProduct()),
                    statisticsCard("Wallet \nBalance", "1200 Coinsdegdeeeeeeeee", 'assets/doller.png', RecycleProduct()),
                    statisticsCard("Completed Changes", "10", 'assets/truck.png', RecycleProduct())
                  ],
                ),
              ),
            ),

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

            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  final category = categoryList[index];
                  return categoryCard(
                      category['pic']??Container(),
                      category['name']??'',
                      RateCard());
                },
              ),
            ),

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

  Widget statisticsCard(String title,String value,String symbol,Widget destination){
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

  Widget categoryCard(String categoryPic,String category, Widget destination) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CircleAvatar(
            //   radius: 30,
            //   backgroundColor: Colors.grey[300],
            //   child: Image.network(categoryPic,fit: BoxFit.fill,),
            // ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                  shape: BoxShape.circle,
                border: Border.all(color: Colors.grey),
              ),
              child: ClipOval(
                child: Image.network(
                  categoryPic,
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            MyExtraSmallText(title: category, isBold: true),
          ],
        ),
      ),
    );
  }
}


This is ratecard page


import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:scrapapp/Utility/global_helper.dart';
import 'package:scrapapp/models/rateItem_Model.dart';
import 'package:scrapapp/screens/Rate_card_details.dart';

class RateCard extends StatefulWidget {
  @override
  State<RateCard> createState() => _RateCardState();
}

class _RateCardState extends State<RateCard> {
  int _currentIndex = 0;
  final TextEditingController _searchcontroller = TextEditingController();
  List<RateItemModel> _searchitems = [];
  bool isSearchClicked = false;
  // List<dynamic> rateCardItems = [];

  List<RateItemModel>? rateItemModel;
  initial() async {
    rateItemModel = await GlobalHelper().getRateCards();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  void _runFilter(String keyword) {
    List<RateItemModel> results = [];
    if (keyword.isEmpty) {
      results = rateItemModel!;
    } else {
      // results=rateItems.where((user=>user["title"])).toList()
      results = rateItemModel!
          .where((user) =>
              user.rateItemsName != null &&
              user.rateItemsName!.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _searchitems = results;

    });
  }

  @override
  Widget build(BuildContext context) {
    // print('kkkk1');
    // print(rateItemModel.toString());
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: isSearchClicked
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextFormField(
                  controller: _searchcontroller,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    //border: OutlineInputBorder(),
                    border: InputBorder.none,
                    hintText: "Search",
                    //labelText: "Location",
                  ),
                  onChanged: (value) => _runFilter(value),
                ),
              )
            : const Text(
                "Rate Card",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearchClicked = !isSearchClicked;
                  if (!isSearchClicked) {
                    _searchcontroller.clear();
                  }
                });
              },
              icon: Icon(isSearchClicked ? Icons.close : Icons.search_sharp))
        ],
      ),
    
      body: _searchcontroller.text == ''
          ? rateItemModel == null
              ? Container()
              : customgridview(rateItemModel!)
          : _searchitems.isEmpty
              ? Container(
                  child: const Center(
                      child: MyMediumText(
                    title: "No result Found",
                    color: Colors.black,
                  )),
                )
              : customgridview(_searchitems),
      // bottomNavigationBar:
      //     BottomNavigation(currentIndex: _currentIndex, onTap: _onTap),
    );
  }
}

Widget customgridview(List<RateItemModel> rateItemModel) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
      children: [
        Expanded(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  // childAspectRatio: 0.5,
                  childAspectRatio: 2/3,
                ),
                itemCount: rateItemModel.length,
                itemBuilder: (context, index) {
                  return _buildRateCardPickUp(
                    context: context,
                    rateSingleItemModel: rateItemModel[index],
                  );
                })),
      ],
    ),
  );
}

Widget _buildRateCardPickUp(
    {required BuildContext context,
    required RateItemModel rateSingleItemModel}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RateCardDetails(
                    rateItemModel: rateSingleItemModel,
                  )));
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          rateSingleItemModel.rateItemsImage == null
              ? Container(
                  height: 160,
                  color: Colors.white,
                )
              : Expanded(
                child: Container(
                    // height: 160,
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage('${rateSingleItemModel.rateItemsImage!}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                rateSingleItemModel.rateItemsName!,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                '\₹${rateSingleItemModel.rateItemsPrice!}/${rateSingleItemModel.rateItemsUnit}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );
}


This is dashboard

import 'package:flutter/material.dart';
import 'package:scrapapp/Utility/global_helper.dart';
import 'package:scrapapp/models/User_Model.dart';
import 'package:scrapapp/screens/HomePage.dart';
import 'package:scrapapp/screens/Profie_Screens/MyAccount.dart';
import 'package:scrapapp/screens/Rate_Card.dart';
import 'package:scrapapp/screens/Recycle_Product.dart';
import 'package:shared_preferences/shared_preferences.dart';
UserModel? userProfile;
class Dashboard extends StatefulWidget {
  final UserModel userProfile;

  const Dashboard({super.key, required this.userProfile});

  @override
  State<Dashboard> createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  String? userid;


  @override
  void initState() {
    super.initState();
    userinfo();
    // print('Dj:$widget.userProfile!.userEmail');
    // print('Dj1:${userProfile!.userEmail}');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  List widgetOptions = <Widget>[
    HomePage(),
    RateCard(),
    RecycleProduct(),
    MyAccount()
  ];

  void userinfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
    userid = prefs.getString('user_id');
    });

    print('User Id: $userid');

    var userMap = await GlobalHelper().getUserDetails(context, userid.toString());
    print('This is usermap$userMap');
    setState(() {
      userProfile = UserModel.from(userMap!);
          print(userProfile);
    });

    print('User Function Called: ${userProfile!.userEmail}');
  }

  @override
  Widget build(BuildContext context) {

// return Scaffold();
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   // print(widget.userProfile!.userPhone);
      //   // print(widget.userProfile!.uname);
      //   print(widget.userProfile!.userEmail);
      // },),
      body: Center(child: widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(topRight: Radius.circular(24),topLeft: Radius.circular(24)),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/Home.png'),color: Colors.white),
              label: 'Home',
              backgroundColor: Theme.of(context).primaryColor,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/product-hunt.png'),color: Colors.white),
              label: 'Rate Card',
              backgroundColor: Theme.of(context).primaryColor,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/recycle.png'),color: Colors.white),
              label: 'Recycle',
              backgroundColor: Theme.of(context).primaryColor,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/Profile.png'),color: Colors.white),
              label: 'My Account',
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}


//when category ontap navigate to ratecard now check the category api id and ratecard api category_id if matched then show only that products
