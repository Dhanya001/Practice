import 'package:flutter/material.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:scrapapp/screens/HomePage.dart';
import 'package:gap/gap.dart';
import 'package:scrapapp/screens/PickUpCompleted.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Schedulersummary extends StatefulWidget {
  final DateTime selectedDate;
  final String selectedSlot;
  final String TotWeight;
  List<Map<String, dynamic>> selecteditems=[];
  // const Schedulersummary({super.key, required this.selectedDate, required this.selectedSlot});
  Schedulersummary({super.key, required this.selectedDate, required this.TotWeight, required this.selectedSlot,required this.selecteditems});
  @override
  State<Schedulersummary> createState() => _SchedulersummaryState();
}

class _SchedulersummaryState extends State<Schedulersummary> {
  final TextEditingController _notescontroller=TextEditingController();

  String _monthName(int month) {
    const monthNames = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: appbar(context, "Schedule Pick Up", "Pick Up Summary"),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "${widget.selectedDate.day} ${_monthName(widget.selectedDate.month)} ${widget.selectedDate.year}",
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
                child: Text(
                  "${widget.selectedSlot}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              height: 160,
              child: ListView.builder(
            itemCount: 1,
                itemBuilder: (context, index) {
                  final item = widget.selecteditems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Wrap(
                      children: widget.selecteditems.map((item) =>
                          Chip(
                            label: Text(item['title']),
                            backgroundColor: Color(0xffDBEAE3),
                            onDeleted: () {
                              setState(() {
                                widget.selecteditems.remove(item);
                              });
                              debugPrint("Deleted item: ${item['title']}");
                            },
                            avatar: Icon(Icons.person),
                          )
                      ).toList(),
                      spacing: 8,
                    ),
                  );
                }
            ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
              child: Row(
                children: [
                  MyMediumText(title: "Estimate Weight :",isBold: true,color: Colors.black,),
                  Gap(20),
                  MyMediumText(title: "${widget.TotWeight}",isBold: false,color: Colors.black,)
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
              margin: const EdgeInsets.symmetric(vertical:10,horizontal: 10),
              decoration: BoxDecoration(
                color: Color(0xffE9E9E9),
                border: Border.all(width: 2,color: Colors.white),
                // borderRadius: BorderRadius.circular(16)
              ),
              child: TextFormField(
                controller: _notescontroller,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  border: InputBorder.none,
                  hintText: "Enter Product Notes",
                ),maxLines: 4,
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: MyBottomButton(
                  title: "Schedule Pick Up Now",
                  onPressed: () async{
                    final prefs = await SharedPreferences.getInstance();
                    final dynamicList = widget.selecteditems;
                    await prefs.setString('Day',"${widget.selectedDate}");
                      print("Day${widget.selectedDate}");
                      await prefs.setString('TimeSlot', "${widget.selectedSlot}");
                    await prefs.setString('TimeSlot', "${widget.selectedSlot.length}");
                    print("count${widget.selectedSlot.length}");
                      await prefs.setStringList('RateItems', <String> ["${widget.selecteditems}"]);
                      // await prefs.setStringList("RateItemsTitles", <String>["${widget.selecteditems.map((item) => item['title']!).toList()}"]);
                    await prefs.setString("RateItemsTitles", "${widget.selecteditems.map((item) => item['title']!)}");
                    print("${widget.selecteditems.map((item)=>item['title'])}");
                      print("${widget.selecteditems}");
                    // await prefs.setStringList('RateItems', dynamicList.cast<String>());
                    // print(dynamicList);
                      await prefs.setString('Notes', _notescontroller.text);
                      await
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PickUpCompleted(
                                Notes: _notescontroller.text,)
                          )
                      );
              }),
            ),
          ],
        ),
      ),

    );
  }
}


import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:scrapapp/Utility/BottomNavigation.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:gap/gap.dart';
import 'package:scrapapp/screens/Profie_Screens/MyAccount.dart';
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getRateItems();
    _saveRateItems();
  }
  Future<List<String>?> _getRateItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? Items=prefs.getString('RateItemsTitles');
    final String? Dayslot=prefs.getString('Day');
    // DateTime parseDate = DateFormat("MMM d, y").parse(Daytimeslot!);
    setState(() {
      // Daytimeslot=parseDate as String?;
      Daytimeslot=Dayslot!;
      RateItemsTitles = Items?.split(',');
    });
    print(RateItemsTitles);
  }

 
  Future<void> _saveRateItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
body: SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
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
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.greenAccent[100],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 10),
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
                                      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 10),
                                      child: Text(
                                        // Daytimeslot!??'',
                                         'Day',
                                          // DateFormat('MMM d, y')
                                          //     .format(DateTime.now())
                                          //     .toString()
                                        style: TextStyle(color: Color(0xffF4A261)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
                          child: Wrap(
                            children: (RateItemsTitles??[]).map((title) =>
                                Chip(
                                  label: Text(title),
                                  backgroundColor: Color(0xffDBEAE3),
                                  avatar: Icon(Icons.person),
                                )
                            ).toList(),
                            spacing: 8,
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
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                                      },
                                      child: MySmallText(title: 'Reschedule',color:Colors.white,),
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
            ),
	);
      }

how to know when i have stored 2-3 schedule summary now want show only 2-3 and there stored data
