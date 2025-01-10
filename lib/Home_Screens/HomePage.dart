import 'package:diesel_wala/screens/checkout_screen.dart';
import 'package:diesel_wala/screens/order_details_screen.dart';
import 'package:diesel_wala/utils/constants.dart';
import 'package:diesel_wala/utils/global_helper.dart';
import 'package:diesel_wala/utils/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OrderScreen extends StatefulWidget {
  final Map<String, dynamic> mapData;
  const OrderScreen({super.key, required this.mapData});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? selectedpurpose;
  final TextEditingController controller=TextEditingController();
  List productList = [];


  initial() async {
    productList = await GlobalHelper().getProductList();

    setState(() {});
  }

  final List<String> Purpose=[
    'Transportation',
    'Power Generation',
    'Construction and Industrial Equipment',
    'Heating',
    'Agriculture',
    'Marine Applications',
    'Emergency and Military'
  ];

  @override
  void initState() {
    // TODO: implement initState
    initial();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // Colors.blueAccent,
                // Colors.red,
                Colors.lightGreen.shade100,
                Colors.blue.shade100,

                // HexColor('#eaf9e7'),
                // HexColor('#e3f2fb'),
              ])),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios_new)),
          backgroundColor: Colors.transparent,
          title: Text(
            'Order',
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Purpose of diesel',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedpurpose,
                hint: Text("Select Purpose"),
                items: Purpose.map((purpose) {
                  return DropdownMenuItem(
                    value: purpose,
                    child: Text(purpose),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedpurpose = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Diesel Quantity: ',
                    style: TextStyle(fontSize: 16),),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter quantity',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedpurpose != null && controller.text.isNotEmpty
                      ? () {
                    // Navigate to CheckoutScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(
                          singleProductInfo: widget.mapData,//here passed single product info
                          qty: controller.text,
                        ),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Order placed successfully!"),
                      ),
                    );
                  }
                      : null,
                  child: Text("Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget productTile(
    BuildContext context,
    String minimumOrder,
    Map singleProductInfo,
    TextEditingController controller,
    String imgUrl,
    String price,
    String description,
    String name) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: textDullColor,
            width: 0.5,
          )),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: textDullColor,
              ),
              height: 100,
              width: 100,
              // child: Image.network(imgUrl,fit: BoxFit.cover,),
              child: Image.network(
                imgUrl,
                fit: BoxFit.cover,
              ),
            ),
            Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  Gap(5),
                  Text(description),
                  Gap(5),
                  Text(
                    '₹$price',
                    style: TextStyle(
                        color: greenHexColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  customTextField('Min Qty: $minimumOrder', controller),
                  SizedBox(
                      width: 130,
                      child: customButton(
                        'Buy Now',
                            () {
                          print(minimumOrder);
                          print(controller.text);
                          if (controller.text != '') {
                            if (int.parse(minimumOrder) <=
                                int.parse(controller.text)) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CheckoutScreen( qty: controller.text,singleProductInfo: singleProductInfo,),
                                  ));
                            } else {
                              showCustomSnackBar(
                                  context, 'Please enter Minimum');
                            }
                          } else {
                            showCustomSnackBar(context, 'Please enter Qty');
                          }
                        },
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}


import 'package:diesel_wala/utils/constants.dart';
import 'package:diesel_wala/utils/global_helper.dart';
import 'package:diesel_wala/utils/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'add_address_Screen.dart';
import 'dashboard_screen.dart';
import 'order_confirmed_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final String qty;

  final Map<dynamic, dynamic> singleProductInfo;

  const CheckoutScreen(
      {super.key, required this.singleProductInfo, required this.qty});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    initial();
    print('Testing');
    print(widget.singleProductInfo);
  }

  initial() async {
    var customerInfo = await GlobalHelper()
        .getCustomerInfo(userInfoData!['user_details']['id'].toString());
    setState(() {
      addressList = customerInfo!['user_address'];
      // radioVal=addressList[];
      addressId = addressList[radioSelected]['address_id'].toString();
      selectedFullAddress =
      "${addressList[radioSelected]['area']},${addressList[radioSelected]['city']},${addressList[radioSelected]['landmark']},${addressList[radioSelected]['pincode']}";
      selectedCity = addressList[radioSelected]['city'].toString();
      selectedPincode = addressList[radioSelected]['pincode'].toString();
      selectedArea = addressList[radioSelected]['area'].toString();
      selectedLandMark = addressList[radioSelected]['landmark'].toString();
    });
  }

  List<dynamic> addressList = [];
  String? addressId;
  int radioSelected = 0;
  String selectedFullAddress = '';
  String selectedArea = '';
  String selectedPincode = '';
  String selectedCity = '';
  String selectedLandMark = '';
  String transportationCharges = '500';
  @override
  Widget build(BuildContext context) {
    return customScaffold(
        context,
        'Checkout',
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(child: customHeadline('Address Details')),
            addressList.isEmpty
                ? Container()
                : ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: addressList.length,
              itemBuilder: (context, index) {
                return customAddressTile(index, radioSelected,
                    "${addressList[index]['area']},${addressList[index]['city']},${addressList[index]['landmark']},${addressList[index]['pincode']}",
                        (selectedIndex, tileTitle) {
                      setState(() {
                        radioSelected = selectedIndex;
                        addressId = addressList[radioSelected]['address_id']
                            .toString();

                        selectedCity =
                            addressList[radioSelected]['city'].toString();
                        selectedPincode =
                            addressList[radioSelected]['pincode'].toString();
                        selectedArea =
                            addressList[radioSelected]['area'].toString();
                        selectedLandMark =
                            addressList[radioSelected]['landmark'].toString();
                      });
                    });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                customTextButton(color: primaryColor, '+ Add New Address', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddAddressScreen(),
                      ));
                })
              ],
            ),
            customHeadline('Order Summery'),
            orderSummery( widget.singleProductInfo['image'].toString(),
                widget.singleProductInfo['product_name'],
                widget.qty,
                (double.parse(widget.singleProductInfo['product_price']) *
                    double.parse(widget.qty))
                    .toString()),
            Gap(20),
            customHeadline('Payment Method'),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: textDullColor)),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                      activeColor: primaryColor,
                      value: '',
                      groupValue: '',
                      onChanged: (value) {},
                    ),
                    Text("Online Payment", style: TextStyle(fontSize: 16))
                  ],
                ),
              ),
            ),
            Gap(25),
            titleValRow(
                'Subtotal',
                (double.parse(widget.singleProductInfo['product_price']) *
                    double.parse(widget.qty))
                    .toString()),
            titleValRow(
                'Transportation Charges', transportationCharges.toString()),
            titleValRow(
                'Total',
                ((double.parse(widget.singleProductInfo['product_price']) *
                    double.parse(widget.qty)) +
                    double.parse(transportationCharges))
                    .toString(),
                fontSize: 18,
                fontWeight: FontWeight.w800),
            Gap(20),
            customExpandedButton('Place Order', () async {


              var createOrderData = await GlobalHelper().createOrder(
                  widget.singleProductInfo['product_price'].toString(),
                  userInfoData!['user_details']['id'].toString(),
                  addressId!,
                  selectedCity,
                  selectedArea,
                  selectedLandMark,
                  selectedPincode,
                  widget.singleProductInfo['product_id'].toString(),
                  widget.qty,
                  (double.parse(widget.singleProductInfo['product_price']) *
                      double.parse(widget.qty))
                      .toString(),
                  ((double.parse(widget.singleProductInfo['product_price']) *
                      double.parse(widget.qty)) +
                      double.parse(transportationCharges))
                      .toString());
              if (createOrderData['success'] == true) {
                Navigator.pop(context);
                Navigator.pop(context);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderConfirmedScreen(),
                    ));
              }
            })
          ],
        ));
  }
}

Widget customHeadline(String headline) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        headline,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Container(
          decoration: BoxDecoration(color: greenHexColor),
          width: 40,
          height: 4,
        ),
      ),
      Gap(15)
    ],
  );
}

Widget customAddressTile(int index, int selectedIndex, String tileTitle,
    Function(int selectedIndex, String slectedTileTitle) function) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: textDullColor)),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, right: 8, bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              activeColor: primaryColor,
              value: index,
              groupValue: selectedIndex,
              onChanged: (value) {
                function(value!, tileTitle);
              },
            ),
            Expanded(
              child: Text(
                tileTitle,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget orderSummery(String imageName, String productName, String qty, String price) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: textDullColor)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  color: textDullColor, borderRadius: BorderRadius.circular(5)),
              child: Image.network('https://parasightdemo.com//diesel_wala//public//uploads//products//$imageName'),
            ),
            Gap(10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Gap(3),
                  Text(
                    'Qty: $qty',
                    style: TextStyle(fontSize: 14, color: textDullColor),
                  ),
                ],
              ),
            ),
            Text(
              '₹$price',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget titleValRow(String title, String price,
    {FontWeight fontWeight = FontWeight.w400, double fontSize = 17}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(fontWeight: fontWeight, fontSize: fontSize),
      ),
      Text('₹$price',
          style: TextStyle(fontWeight: fontWeight, fontSize: fontSize))
    ],
  );
}

//I want set that logic diesel qty 500 above then Diesel Tank product id passed sinleproducts in checkout page and below then Diesel Jerrycan

//productlist map{"product_id":360,"product_name":"Diesel Tank","product_desc":"Tank","image":"1735294510.jpeg","minimum_order":"500","product_price":"110","created_at":"2024-12-19T08:04:22.000000Z","updated_at":"2024-12-27T10:15:10.000000Z","deleted_at":null,"product_image":"http:\/\/parasightdemo.com\/diesel_wala\/public\/uploads\/products\/1735294510.jpeg"},{"product_id":364,"product_name":"Diesel Jerrycan","product_desc":"Jerrycan","image":"1735286740.jpeg","minimum_order":"20","product_price":"100","created_at":"2024-12-23T14:33:40.000000Z","updated_at":"2024-12-27T08:05:40.000000Z","deleted_at":null,"product_image":"http:\/\/parasightdemo.com\/diesel_wala\/public\/uploads\/products\/1735294510.jpeg"},{"product_id":364,"product_name":"Diesel Jerrycan","product_desc":"Jerrycan","image":"1735286740.jpeg","minimum_order":"20","product_price":"100","created_at":"2024-12-23T14:33:40.000000Z","updated_at":"2024-12-27T08:05:40.000000Z","deleted_at":null,"product_image":"http:\/\/parasightdemo.com\/diesel_wala\/public\/uploads\/products\/1735286740.jpeg"}]}
