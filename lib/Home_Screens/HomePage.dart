import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:scrapapp/Utility/global_helper.dart';
import 'package:scrapapp/models/rateItem_Model.dart';
import 'package:scrapapp/screens/Rate_card_details.dart';

class RateCard extends StatefulWidget {
  final String? categoryId;

  const RateCard({super.key, this.categoryId});

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
    if (rateItemModel != null) {
      if(widget.categoryId!=null){
      rateItemModel =
          rateItemModel!.where((item) => item.categoryId.toString() ==
              widget.categoryId.toString()).toList();
      }else{
        rateItemModel = await GlobalHelper().getRateCards();
      }
        }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
    print("yo");
    print(widget.categoryId);
    print(widget.categoryId.toString());
    print(rateItemModel.toString());
    print(widget.categoryId);
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
      // const Center(
      //         child: MySmallText(
      //                 title: 'No Items!!',isBold: true,color: Colors.black,)
      //         )
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

//I want widget.categoryid==ratemodel.categoryid is not matched then show body contaniner no items in this category!!
