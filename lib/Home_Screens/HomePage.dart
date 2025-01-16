backup ratecardpickup page

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:scrapapp/Utility/global_helper.dart';
import 'package:scrapapp/models/rateItem_Model.dart';
import 'package:scrapapp/screens/Capture_PickUp.dart';
import 'package:scrapapp/Utility/constants.dart' as constants;

class RateCardPickup extends StatefulWidget {

  final Map<String, dynamic> existingScheduleMap;
  RateCardPickup(
      {super.key,
        required this.existingScheduleMap,
      });

  @override
  State<RateCardPickup> createState() => _RateCardPickupState();
}

class _RateCardPickupState extends State<RateCardPickup> {
  final TextEditingController _searchcontroller = TextEditingController();
  List<RateItemModel> _searchitems = [];
  List<RateItemModel> SelectedItems = [];
  bool isNetConnected = true;
  // List<String> existingselectedItems = [];
  // final List<String> selectedItemId = _searchitems.map((item) => item.productId.toString()).toList();

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
    print('Testing');

    // log(widget.existingScheduleModel.toString());
  }

  StreamSubscription<InternetStatus>? listener;
  checkInternet() async {
    bool isInternetConnected = await constants.isInternet();
    if (isInternetConnected) {
      // initial();
    } else {
      setState(() {
        isNetConnected = false;
      });
      constants.showCustomSnackBarOffline(context);

      listener =
          InternetConnection().onStatusChange.listen((InternetStatus status) {
        switch (status) {
          case InternetStatus.connected:
            constants.showCustomSnackBarOnline(context);
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

  void _runFilter(String keyword) {
    List<RateItemModel> results = [];
    if (keyword.isEmpty) {
      results = rateItemModel!;
    } else {
      // results=rateItems.where((user=>user["title"])).toList()
      results = rateItemModel!
          .where((user) =>
              user.rateItemsName!.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _searchitems = results;
    });
  }

  @override
  dispose() {
    listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar:
          appbar(context, "Schedule Pick Up", "Select  Products for pick up"),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16)),
              child: TextFormField(
                controller: _searchcontroller,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  //border: OutlineInputBorder(),
                  border: InputBorder.none,
                  hintText: "Enter Product",
                  //labelText: "Location",
                ),
                onChanged: (value) => _runFilter(value),
              ),
            ),
            Expanded(
                child: _searchcontroller.text == ''
                    ? rateItemModel == null
                        ? Container()
                        : CustomGridview(
                            rateItemModel: rateItemModel!,
                            selectedlist: SelectedItems,
                existingScheduleMap: widget.existingScheduleMap,)
                    : _searchitems.isEmpty
                        ? Container(
                            child: const Center(
                                child: MyMediumText(
                              title: "No result Found",
                              color: Colors.black,
                            )),
                          )
                        : CustomGridview(
                            rateItemModel: _searchitems,
                            selectedlist: SelectedItems,
                existingScheduleMap: widget.existingScheduleMap,)),
            MyBottomButton(
                title: "Next",
                onPressed: () async {
                  bool isInternetConnected = await constants.isInternet();
                  if (isInternetConnected) {
                    if (SelectedItems.isEmpty) {
                      constants.showCustomSnackBar(context, "Please select at least one item.");
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CapturePickup(
                              onWeightChanged: (String weight) {
                                return weight;
                              },
                              selectedItems: SelectedItems,
                            ),
                          ));
                    }
                  } else {
                    constants.showErrorDialog(context, 'Internet Error!',
                        'Please check your internet connection',
                        icon: const Icon(
                          Icons.wifi_off_rounded,
                          color: Colors.black38,
                        ));
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class CustomGridview extends StatefulWidget {
  final List<RateItemModel> rateItemModel;
  final List<RateItemModel> selectedlist;
  final Map<String, dynamic> existingScheduleMap;
  const CustomGridview(
      {super.key,
        required this.rateItemModel,
        required this.selectedlist,
        required this.existingScheduleMap
      });

  @override
  State<CustomGridview> createState() => _CustomGridviewState();
}

class _CustomGridviewState extends State<CustomGridview> {
  @override
  void initState() {
    super.initState();
    print('Dhananjay');
    print(widget.selectedlist);
    log(widget.existingScheduleMap.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 2/3,
          ),
          itemCount: widget.rateItemModel.length,
          itemBuilder: (context, index) {
            bool isSelected = false;
            for (int i = 0; i < widget.selectedlist.length; i++) {
              if (widget.selectedlist[i].rateItemsName ==
                  widget.rateItemModel[index].rateItemsName) {
                isSelected = true;
              }
            }
            // final item = _searchitems[index];
            return GestureDetector(
              onTap: () {
                print(widget.existingScheduleMap['schedule_items'][index]['product_name']);
                print(widget.rateItemModel[index].rateItemsName);
                setState(() {
                  if (widget.selectedlist
                      .contains(widget.rateItemModel[index])) {
                    widget.selectedlist.remove(widget.rateItemModel[index]);
                  } else {
                    widget.selectedlist.add(widget.rateItemModel[index]);
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: widget.rateItemModel[index].rateItemsImage == null
                          ? Container(
                              color: Colors.white,
                            )
                          : Container(
                              margin: const EdgeInsets.all(5),
                              width: double.infinity,
                              // height: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage('${widget.rateItemModel[index].rateItemsImage}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:5,horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: 40,
                              child: Text(
                                // "NNNNNNNnnnnnnnnnNNNNN",
                                widget.rateItemModel[index].rateItemsName??'',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.selectedlist
                                    .contains(widget.rateItemModel[index])) {
                                  widget.selectedlist
                                      .remove(widget.rateItemModel[index]);
                                } else {
                                  widget.selectedlist
                                      .add(widget.rateItemModel[index]);
                                }
                              });
                            },
                            child: isSelected
                                ? Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                  border:
                                  Border.all(color: Colors.black)),
                              child: Icon(
                                Icons.check,
                                size: 15,
                                color: Colors.white,
                              ),
                            )
                                : Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                  Border.all(color: Colors.black)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

//i want existingschedule compared with selectedlist means existindschedule list item selected then selected item otherwise not selected
