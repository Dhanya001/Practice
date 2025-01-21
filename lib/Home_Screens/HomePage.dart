import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrapapp/Profie_Screens/AddressBook.dart';
import 'package:scrapapp/screens/Dashboard.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:scrapapp/Utility/global_helper.dart';
import 'package:scrapapp/models/rateItem_Model.dart';
import 'package:gap/gap.dart';
import 'package:scrapapp/screens/scheduleCompleted.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scrapapp/Utility/constants.dart' as constants;
import '../Utility/constants.dart';

class Schedulersummary extends StatefulWidget {
  final DateTime selectedDate;
  final dynamic selectedSlot;
  final String totWeight;
  final dynamic selectedUnit;
  List<RateItemModel> selectedItems = [];
  final Map<String, dynamic> existingScheduleMap;
  Schedulersummary({
    super.key,
    required this.selectedDate,
    required this.totWeight,
    required this.selectedSlot,
    required this.selectedItems,
    required this.selectedUnit,
    required this.existingScheduleMap,
  });

  @override
  State<Schedulersummary> createState() => _SchedulersummaryState();
}

class _SchedulersummaryState extends State<Schedulersummary> {
  final TextEditingController _notescontroller = TextEditingController();
  String? addressTitle;
  String? fullAddress;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.existingScheduleMap['schedule_items'] != null) {
      _notescontroller.text =
          widget.existingScheduleMap['schedule_items'][0]['note'] ?? '';
    }
    showUserAddress();
  }

  Future<void> showUserAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      addressTitle = prefs.getString('address_title');
      fullAddress = prefs.getString('user_address');
    });
    print('Testing4:$fullAddress');
  }


  String formatDate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final uniqueSelectedItems = widget.selectedItems.toSet().toList();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: scaffoldBackgroundColor,
      appBar: appbar(context, "Schedule Pick Up", "Pick Up Summary"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.selectedDate.day} ${monthName(widget.selectedDate.month)} ${widget.selectedDate.year}",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyExtraSmallText(
                            title: widget.existingScheduleMap['schedules_id'] !=
                                    null
                                ? '#${widget.existingScheduleMap['schedules_id']}'
                                : '',
                            color: Colors.grey,
                            isBold: true,
                          ),
                        )
                      ],
                    ),
                    Text(
                      '${widget.selectedSlot['start_time']} - ${widget.selectedSlot['end_time']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        // color: Colors.white,
                        height: 200,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: uniqueSelectedItems.map((item) {
                              return Chip(
                                label: MyExtraSmallText(
                                    title: item.rateItemsName!,
                                    isBold: true,
                                    color: primaryColor),
                                backgroundColor: const Color(0xffDBEAE3),
                                onDeleted: () {
                                  setState(() {
                                    widget.selectedItems.remove(item);
                                  });
                                  debugPrint(
                                      "Deleted item: ${item.rateItemsName}");
                                },
                                avatar: const Icon(Icons.person),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const MyMediumText(
                          title: "Estimate Weight :",
                          isBold: true,
                          color: Colors.black,
                        ),
                        const Gap(20),
                        MyMediumText(
                          title:
                              "${widget.totWeight} ${widget.selectedUnit['name']}",
                          isBold: false,
                          color: Colors.black,
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    MyMediumText(
                      title: "Notes",
                      isBold: true,
                      color: Colors.black,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xffE9E9E9),
                        border: Border.all(width: 2, color: Colors.white),
                        // borderRadius: BorderRadius.circular(16)
                      ),
                      child: TextFormField(
                        controller: _notescontroller,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: InputBorder.none,
                          hintText: "Enter Product Notes",
                        ),
                        maxLines: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: scaffoldBackgroundColor,
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: MyBottomButton(
              title: "Schedule Pick Up Now",
              onPressed: () async {
                bool isInternetConnected = await constants.isInternet();
                if (!isInternetConnected) {
                  constants.showErrorDialog1(
                    context,
                    'Internet Error!',
                    'Please check your internet connection',
                    icon: const Icon(
                      Icons.wifi_off_rounded,
                      color: Colors.black38,
                    ),
                  );
                  return;
                }
              if (uniqueSelectedItems.isNotEmpty) {
                constants.showErrorDialog(
                  context,
                  'Confirmation',
                  'Are you sure you want to Pick up Schedule',
                  onConfirm: () async {
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    String? addressId = prefs.getString('user_address_id');

                    if (addressId != null) {
                      constants.showLoading(context);
                      try {
                        var response = await GlobalHelper().schedulePost(
                          widget.selectedItems,
                          widget.existingScheduleMap['schedules_id'].toString(),
                          globalUserProfileModel!.userID.toString(),
                          widget.totWeight,
                          widget.selectedUnit['id'].toString(),
                          formatDate(widget.selectedDate.toIso8601String()),
                          widget.selectedSlot['start_time'],
                          widget.selectedSlot['end_time'],
                          _notescontroller.text.trim(),
                          addressId,
                        );

                        if (response['success'] == true) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PickUpCompleted(
                                    Notes: _notescontroller.text,
                                  ),
                            ),
                          );
                        } else {
                          print('Failed to schedule pickup');
                        }
                      } catch (e) {
                        print('Error scheduling pickup: $e');
                      }
                    } else {
                      constants.showErrorDialog(
                          context,
                          'Address not selected',
                          'Please select Address',
                          onConfirm: () async {
                            final result=
                            await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => AddressBookPage(),));
                            if (result == 'selectedAddress') {
                              print('Testing');
                              showUserAddress();
                            }
                          }
                      );
                    }
                  },
                );
              } else
                {
                  constants.showCustomSnackBar(context, "Please select at least one item.");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}




import 'dart:async';

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:scrapapp/Profie_Screens/AddressBook.dart';
import 'package:scrapapp/screens/Dashboard.dart';
import 'package:scrapapp/Profie_Screens/PickUpDetails.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:gap/gap.dart';
import 'package:scrapapp/Utility/global_helper.dart';
import 'package:scrapapp/screens/rateCard.dart';
import 'package:scrapapp/screens/schedulePickUp.dart';
import 'package:scrapapp/screens/recycleProduct.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scrapapp/Utility/constants.dart' as constant;

import '../Utility/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isNetConnected = true;
  String? addressTitle;
  String? fullAddress;
  List scheduleDateList = [];
  List categoryList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternet();
    initial();
    showUserAddress();
    fetchPickups();
    print('Testing2:$fullAddress');
  }


  initial() async {
    categoryList = await GlobalHelper().getCategory();
    setState(() {});
  }

  fetchPickups() async {
    if (globalUserProfileModel != null) {
      var myPickupData = await GlobalHelper()
          .getschedulepickup(globalUserProfileModel!.userID.toString());

      if (myPickupData != null && myPickupData['schedule_data'] != null) {
        setState(() {
          scheduleDateList = myPickupData['schedule_data'];
        });
      } else {
        setState(() {
          scheduleDateList = [];
        });
      }
    }
  }

  Future<void> showUserAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      addressTitle = prefs.getString('address_title');
      fullAddress = prefs.getString('user_address');
    });
    print('Testing6:$fullAddress');
  }

  StreamSubscription<InternetStatus>? listener;
  checkInternet() async {
    bool isInternetConnected = await constant.isInternet();
    if (isInternetConnected) {
      // initial();
    } else {
      setState(() {
        isNetConnected = false;
      });
      constant.showCustomSnackBarOffline(context);

      listener =
          InternetConnection().onStatusChange.listen((InternetStatus status) {
        switch (status) {
          case InternetStatus.connected:
            constant.showCustomSnackBarOnline(context);
            setState(() {
              isNetConnected = true;
            });
            // initial(isBackToOnline: true);
            break;
          case InternetStatus.disconnected:
            break;
        }
      });
    }
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    bool? exitApp = await showDialog(
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
    return exitApp ?? false;
  }

  @override
  dispose() {
    listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     var mypickupdata = await GlobalHelper()
      //         .getschedulepickup(globalUserProfileModel!.userID.toString());
      //     log(mypickupdata.toString());
      //     print(scheduleDateList.length);
      //
      //     setState(() {
      //       scheduleDateList = mypickupdata['schedule_data'];
      //     });
      //   },
      // ),
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Image.asset("assets/icons/Munich_center.png"),
              const Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MySmallText(
                        title: addressTitle != null && addressTitle != ''
                            ? '$addressTitle'
                            : "Munich Center",
                        isBold: false,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 30,
                        child: IconButton(
                          onPressed: () async {
                            String result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddressBookPage()));
                            if (result == 'selectedAddress') {
                              print('Testing5');
                              showUserAddress();
                            }
                          },
                          icon: Icon(Icons.keyboard_arrow_down_outlined),
                        ),
                      )
                    ],
                  ),
                  MyExtraSmallText(
                    title: fullAddress != null && fullAddress != ''
                        ? '$fullAddress'
                        : "",
                    isBold: false,
                    color: Colors.black,
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_sharp))
        ],
        automaticallyImplyLeading: false,
      ),
      body: isNetConnected == false
          ? Container()
          : SingleChildScrollView(
              child: Column(
                children: [
                  //Image Structure
                  //that image came from api used getHomepageImages()
                  Stack(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: shadowColor,
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 7,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MySmallText(
                                      title: "Turn your scrap into cash!",
                                      isBold: true,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    MyExtraSmallText(
                                      title:
                                          "Schedule a pickup today and make recycling effortless.",
                                      isBold: false,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Image.asset(
                                    "assets/home_content.png",
                                    fit: BoxFit.cover,
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 160, right: 50, left: 50, bottom: 5),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RateCardPickup(
                                          existingScheduleMap: {},
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MySmallText(
                                      title: "Schedule Pickup Now       ",
                                      color: Colors.grey,
                                      isBold: true),
                                  Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    color: Colors.grey,
                                    size: 15,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //Statistics Section
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: MyBigText(
                          title: "Statistics",
                          isBold: true,
                          color: Colors.black,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          statisticsCard(
                              "Scrap Collected fjgbjfbgfgnfgnfnddfjkgbjkvgbfkbgbfk",
                              "145 KG",
                              'assets/recycle.png',
                              RecycleProduct()),
                          statisticsCard(
                              "Wallet \nBalance",
                              "1200 Coinsdegdeeeeeeeee",
                              'assets/doller.png',
                              RecycleProduct()),
                          statisticsCard("Completed Changes", "10",
                              'assets/truck.png', RecycleProduct())
                        ],
                      ),
                    ),
                  ),

                  //Category Section
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: MyBigText(
                              title: "Products By Category",
                              isBold: true,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const MySmallText(
                            title: "See All",
                            isBold: true,
                          ))
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
                          category['pic'] ?? Container(),
                          category['name'] ?? '',
                          category['id'].toString(),
                        );
                      },
                    ),
                  ),

                  //Ticket Section
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: scheduleDateList.length >= 2
                        ? 2
                        : scheduleDateList.length,
                    itemBuilder: (context, index) {
                      List uniqueSelectedItems = scheduleDateList[index]
                              ['schedule_items']
                          .toSet()
                          .toList();
                      final pickup = scheduleDateList[index];
                      // final filteredScheduleDateList = scheduleDateList.where((item) {
                      //   final pickupDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(item['pickup_date']));
                      //   return pickupDate.compareTo() >= 0;
                      // }).toList();
                      return scheduleDateList[index]['status'] == 'pending'
                          ? InkWell(
                              onTap: () {
                                print(uniqueSelectedItems.length);
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 0.5,
                                      color: Colors.grey,
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: Colors.greenAccent[100],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 8),
                                                child: MyExtraSmallText(
                                                  title: 'In Progress',
                                                  color:primaryColor,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: Colors.orange[50],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 8.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .watch_later_outlined,
                                                      color: shadowColor,
                                                      size: 20,
                                                    ),
                                                    MyExtraSmallText(
                                                      title:
                                                          '${formatDate(scheduleDateList[index]['pickup_date'])}',
                                                      color: shadowColor,
                                                    ),
                                                    const Gap(5),
                                                    MyExtraSmallText(
                                                      title:
                                                          '${scheduleDateList[index]['start_time']} - ',
                                                      color: shadowColor,
                                                    ),
                                                    MyExtraSmallText(
                                                      title:
                                                          '${scheduleDateList[index]['end_time']}',
                                                      color: shadowColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Container(
                                          // color: Colors.white,
                                          height: 50,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Wrap(
                                              spacing: 8,
                                              runSpacing: 2,
                                              children: uniqueSelectedItems
                                                  .map((item) {
                                                return Chip(
                                                  label: MyExtraSmallText(
                                                    title:
                                                        item['product_name']!,
                                                    isBold: true,
                                                    color: Color(0xff1F48AA),
                                                  ),
                                                  backgroundColor:
                                                      const Color(0xffF0F6FA),
                                                  // avatar: const Icon(Icons.person),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            MyMiniTextButton(
                                              title: 'Reschedule',
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PickUpDetails(
                                                              scheduleMap:
                                                                  scheduleDateList[
                                                                      index]),
                                                    ));
                                              },
                                              color: primaryColor,
                                            ),
                                            MyMiniTextButton(
                                                title: 'Cancel',
                                                onPressed: () {},
                                                color: Colors.red)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container();
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget statisticsCard(
      String title, String value, String symbol, Widget destination) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => destination));
      },
      child: Container(
        height: 200,
        width: 150,
        margin: const EdgeInsets.only(right: 16.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color(0xff2D6A4F),
            Color(0xff58D09B),
          ]),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 50,
                child: Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 17),
                overflow: TextOverflow.ellipsis,
              ),
              // MySmallText(title: value,isBold: true,color: Colors.white,),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                symbol,
                height: 98,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryCard(String categoryPic, String category, String categoryId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RateCard(
                      categoryId: categoryId,
                    )));
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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

// Future<void> _signOut() async {
//   await _googleSignIn.signOut();
//   setState(() {
//     _status = "Not signed in";
//     _currentUser  = null;
//   });
//
//   userProfile = null;
//
//   await fetchPickups();
//
//   var prefer = await SharedPreferences.getInstance();
//   final _islogin = await prefer.setBool('isLogin', false);
//   print('login 3:$_islogin');
//
//   Navigator.pushAndRemoveUntil(
//     context,
//     MaterialPageRoute(builder: (context) => const SignIn()),
//         (route) => false,
//   );
// }
//
// void loginUser () async {
//   await fetchPickups();
// }
