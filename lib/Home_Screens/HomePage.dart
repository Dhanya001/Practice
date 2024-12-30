import 'dart:developer';

import 'package:eschoolapp/models/payment_history_model.dart';
import 'package:eschoolapp/screen/payment_receipt.dart';
import 'package:eschoolapp/screen/payment_sucessful.dart';
import 'package:uuid/uuid.dart';
import 'package:eschoolapp/screen/fees_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';
import '../models/student_model.dart';
import '../utils/cash_fees_gateway_payment.dart';
import '../utils/global_helper.dart';
import '../widget_helper/widgets_helper.dart';
import 'package:eschoolapp/utils/constants.dart' as constants;

var uuid = const Uuid();

class FeesScreen extends StatefulWidget {
  final String studentId;
  final String currentYear;
  final StudentModel studentModel;
  const FeesScreen(
      {super.key,
      required this.studentId,
      required this.currentYear,
      required this.studentModel});
  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  StudentModel? studentModel;
  List<Map<String, dynamic>> feesDetails = [];
  List<PaymentHistoryModel> paymentHistoryModel=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: constants.backgroundColor,
        appBar: appbar(context, 'Fees', 'Installment', widgetList: [
          PopupMenuButton(
            iconColor: Colors.white,
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeesHistoryScreen(
                                  studentModel: widget.studentModel,
                                  currentYear: widget.currentYear.toString(),
                                  studentId: widget.studentId.toString()),
                            ));
                      },
                      child: const Text('Payment History'))),
            ],
          ),
          Gap(15),
        ]),
        floatingActionButton: FloatingActionButton(onPressed: () async{
          var feedetails1=await GlobalHelper().feeDetails(widget.studentId);
          print('Dhnanajay');
          print(feedetails1);
        },),
        body: FutureBuilder(
          future: GlobalHelper().feeDetails(widget.studentId),
          initialData: GlobalHelper().paidFeesHistory(widget.studentId, widget.currentYear) ,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                paymentHistoryModel=snapshot.data as List<PaymentHistoryModel>;
                List<dynamic> feesDataList = [];
                Map<String, dynamic> mapData = {};
                mapData = snapshot.data as Map<String, dynamic>;

                feesDataList = mapData['installments'] as List<dynamic>;

                return SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: [
                      // IconButton(
                      //     onPressed: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => PaymentSuccessful(
                      //               amount: '2,000 static',
                      //               transactionId: '4849398439static',
                      //              isSuccessStatus: false,
                      //               studentId: widget.studentId,
                      //               currentYear: widget.currentYear,
                      //               studentModel: widget.studentModel,
                      //             ),
                      //           ));
                      //       // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentSucessful(),));
                      //     },
                      //     icon: Icon(Icons.import_contacts)),
                      const HeaderRow(boxShadow: true, title: "Installment"),
                      Gap(15),
                      ListView.builder(
                        itemCount: feesDataList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var payHistory = paymentHistoryModel[index];
                          feesDetails.add(feesDataList[index][
                              '\u0000yii\\db\\BaseActiveRecord\u0000_attributes']);
                          return feesDetails[index]['total_fees'] == 0
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InstallmentsWidget(
                                    callback: () async {
                                      // if(mapData['allow_to_pay'][index] == 0){
                                      //   // Navigator.push(context, MaterialPageRoute(builder: (context) => FeesHistoryScreen(studentId: widget.studentId, currentYear: widget.currentYear, studentModel: widget.studentModel)));
                                      //   // Navigator.push(context,
                                      //   //     MaterialPageRoute(
                                      //   //         builder: (context) =>
                                      //   //             PaymentReceipt(
                                      //   //                 paymentHistoryModel: paymentHistoryModel[index],
                                      //   //                 studentModel: widget.studentModel)));
                                      // }else{
                                      //   log(feesDetails[index]['installment']
                                      //       .toString());
                                      //   log(feesDetails[index][
                                      //           'online_admission_fees_id']
                                      //       .toString());
                                      //   if (mapData['allow_to_pay'][index] != 0) {
                                      //     var paymentInitialStoreInfoResponse =
                                      //         await GlobalHelper()
                                      //             .paymentInitialStoreInfo(
                                      //                 widget.studentId,
                                      //                 widget.currentYear,
                                      //                 feesDetails[index]
                                      //                         ['installment']
                                      //                     .toString(),
                                      //                 feesDetails[index][
                                      //                         'online_admission_fees_id']
                                      //                     .toString());
                                      //
                                      //     InitCashFreePayment().createOrder(
                                      //         context,
                                      //         paymentInitialStoreInfoResponse[
                                      //             'reference_no'],
                                      //
                                      //         paymentInitialStoreInfoResponse[
                                      //         'total_fees'].toString(),
                                      //         // paymentInitialStoreInfoResponse[
                                      //         // 'balance_fees'].toString(),
                                      //         // mapData['balance_fees'].toString(),
                                      //
                                      //         widget.studentId,
                                      //         "${widget.studentModel.name} ${widget.studentModel.fatherName} ${widget.studentModel.surname}",
                                      //         widget.studentModel.fatherEmail!,
                                      //         widget.studentModel.fatherNumber
                                      //             .toString(),
                                      //         feesDetails[index][
                                      //                 'online_admission_fees_id']
                                      //             .toString(),
                                      //         feesDetails[index]['installment']
                                      //             .toString(),
                                      //         widget.currentYear,
                                      //         widget.studentModel,
                                      //             (){
                                      //           setState(() {});
                                      //         }
                                      //
                                      //     );
                                      //     // setState(() {});
                                      //     // setState(() {
                                      //     //   feesDetails.clear();
                                      //     // });
                                      //   }
                                      // }
                                      log(feesDetails[index]['installment']
                                          .toString());
                                      log(feesDetails[index][
                                              'online_admission_fees_id']
                                          .toString());
                                      if (mapData['allow_to_pay'][index] != 0) {
                                        var paymentInitialStoreInfoResponse =
                                            await GlobalHelper()
                                                .paymentInitialStoreInfo(
                                                    widget.studentId,
                                                    widget.currentYear,
                                                    feesDetails[index]
                                                            ['installment']
                                                        .toString(),
                                                    feesDetails[index][
                                                            'online_admission_fees_id']
                                                        .toString());

                                        InitCashFreePayment().createOrder(
                                            context,
                                            paymentInitialStoreInfoResponse[
                                                'reference_no'],

                                            paymentInitialStoreInfoResponse[
                                            'total_fees'].toString(),
                                            // paymentInitialStoreInfoResponse[
                                            // 'balance_fees'].toString(),
                                            // mapData['balance_fees'].toString(),

                                            widget.studentId,
                                            "${widget.studentModel.name} ${widget.studentModel.fatherName} ${widget.studentModel.surname}",
                                            widget.studentModel.fatherEmail!,
                                            widget.studentModel.fatherNumber
                                                .toString(),
                                            feesDetails[index][
                                                    'online_admission_fees_id']
                                                .toString(),
                                            feesDetails[index]['installment']
                                                .toString(),
                                            widget.currentYear,
                                            widget.studentModel,
                                                (){
                                              setState(() {});
                                            }

                                        );
                                        // setState(() {});
                                        // setState(() {
                                        //   feesDetails.clear();
                                        // });
                                      }
                                    },
                                    title:
                                        "Installment ${feesDetails[index]['installment']}",
                                    paid: feesDetails[index]['total_fees']
                                        .toString(),
                                    due: mapData['balance_fees'].toString(),
                                    btn: mapData['allow_to_pay'][index] == 0
                                        ? 'View Receipt'
                                        : "Pay Now",
                                    color: mapData['allow_to_pay'][index] == 0
                                        ? HexColor('#135E9E')
                                        : HexColor('#135E9E'),
                                    // paymentHistoryModel:  paymentHistoryModel.isNotEmpty ? paymentHistoryModel[index] : null,
                                    paymentHistoryModel: payHistory,
                                    studentModel: widget.studentModel,
                                    // btn1: mapData['allow_to_pay'][index] == 0
                                    //     ? 'View'
                                    //     : "View Receipt",
                                    // color1: mapData['allow_to_pay'][index] != 0
                                    //     ? HexColor('#ABADAE')
                                    //     : HexColor('#135E9E'),
                                  ));
                        },
                      ),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyContainer(
                            top: 10,
                            bottom: 10,
                            left: 10,
                            right: 10,
                            boxShadow: true,
                            child: Column(
                              children: [
                                const HeaderRow(title: "Fees Information"),
                                const Gap(15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    FeesColumn(
                                      firstVal: "Total Fees",
                                      secondVal:
                                          mapData['total_fees'].toString(),
                                    ),
                                    FeesColumn(
                                      firstVal: "Total Paid",
                                      secondVal:
                                          mapData['paid_fees'].toString(),
                                    ),
                                    FeesColumn(
                                      firstVal: "Total Balance",
                                      secondVal:
                                          mapData['balance_fees'].toString(),
                                    ),
                                  ],
                                )
                              ],
                            )),
                      ),
                      const Gap(10),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('No Data'));
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

// class InstallmentsWidget extends StatefulWidget {
//   final String title;
//   final String paid;
//   final String due;
//   final String btn;
//   // final String btn1;
//   final Color color;
//   // final Color color1;
//   final PaymentHistoryModel paymentHistoryModel;
//   final VoidCallback callback;
//   final StudentModel studentModel;
//   // final VoidCallback callback1;
//   const InstallmentsWidget(
//       {super.key,
//       required this.title,
//       required this.paid,
//       required this.due,
//       required this.btn,
//         // required this.btn1,
//       required this.color,
//         // required this.color1,
//       required this.callback,
//         required this.paymentHistoryModel,required this.studentModel,
//       // required this.callback1
//       });
//
//   @override
//   State<InstallmentsWidget> createState() => _InstallmentsWidgetState();
// }

// class _InstallmentsWidgetState extends State<InstallmentsWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return MyContainer(
//         right: 10,
//         left: 10,
//         top: 10,
//         bottom: 10,
//         height: 200,
//         boxShadow: true,
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 MyTextMedium(
//                   title: widget.title,
//                   color: HexColor("#0C6992"),
//                 )
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 FeesColumn(
//                   firstVal: widget.paid,
//                   secondVal: "Total Paid",
//                 ),
//                 Container(
//                     height: 100,
//                     child: VerticalDivider(
//                       thickness: 3.5,
//                       color: HexColor('#ABADAE'),
//                     )),
//                 FeesColumn(
//                   firstVal: widget.due,
//                   secondVal: "Total Due",
//                 ),
//               ],
//             ),
//             Container(
//                 width: double.infinity,
//                 child: MyTextButton(
//                     callback: (){
//                       if (widget.paymentHistoryModel != null) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PaymentReceipt(
//                               paymentHistoryModel: widget.paymentHistoryModel!,
//                               studentModel: widget.studentModel,
//                             ),
//                           ),
//                         );
//                       } else {
//                         widget.callback();
//                       }
//                     },
//                     radius: 5,
//                     bgColor: widget.color,
//                     myWidget: MyTextMedium(
//                       title: widget.btn,
//                       color: Colors.white,
//                     ))),
//             // Row(
//             //   children: [
//             //
//             //     Expanded(
//             //       child: Container(
//             //           width: double.infinity,
//             //           child: MyTextButton(
//             //               callback: callback,
//             //               radius: 5,
//             //               bgColor: color,
//             //               myWidget: MyTextMedium(
//             //                 title: btn,
//             //                 color: Colors.white,
//             //               ))),
//             //     ),
//             //     Gap(10),
//             //     Expanded(
//             //       child: Container(
//             //           width: double.infinity,
//             //           child: MyTextButton(
//             //               callback: callback,
//             //               radius: 5,
//             //               bgColor: color1,
//             //               myWidget: MyTextMedium(
//             //                 title: btn1,
//             //                 color: Colors.white,
//             //               ))),
//             //     ),
//             //   ],
//             // ),
//           ],
//         ));
//   }
// }

class InstallmentsWidget extends StatelessWidget {
  final String title;
  final String paid;
  final String due;
  final String btn;
  final Color color;
  final VoidCallback callback;
  final PaymentHistoryModel? paymentHistoryModel;
  final StudentModel studentModel;

  const InstallmentsWidget({
    super.key,
    required this.title,
    required this.paid,
    required this.due,
    required this.btn,
    required this.color,
    required this.callback,
    this.paymentHistoryModel, required this.studentModel, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return MyContainer(
      right: 10,
      left: 10,
      top: 10,
      bottom: 10,
      height: 200,
      boxShadow: true,
      child: Column(
        children: [
          Row(
            children: [
              MyTextMedium(
                title: title,
                color: HexColor("#0C6992"),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FeesColumn(
                firstVal: paid,
                secondVal: "Total Paid",
              ),
              Container(
                height: 100,
                child: VerticalDivider(
                  thickness: 3.5,
                  color: HexColor('#ABADAE'),
                ),
              ),
              FeesColumn(
                firstVal: due,
                secondVal: "Total Due",
              ),
            ],
          ),
          Container(
            width: double.infinity,
            child: MyTextButton(
              callback: () {
                if (paymentHistoryModel != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentReceipt(
                        paymentHistoryModel: paymentHistoryModel!,
                        studentModel: studentModel,
                      ),
                    ),
                  );
                } else {
                  callback();
                }
              },
              radius: 5,
              bgColor: color,
              myWidget: MyTextMedium(
                title: btn,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeesColumn extends StatelessWidget {
  final String firstVal;
  final String secondVal;
  const FeesColumn(
      {super.key, required this.firstVal, required this.secondVal});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyTextSmall(title: firstVal, color: HexColor('#646668')),
        Gap(5),
        MyTextSmall(title: secondVal, color: HexColor('#646668')),
      ],
    );
  }
}
import 'dart:async';

import 'package:eschoolapp/models/student_model.dart';
import 'package:eschoolapp/utils/global_helper.dart';
import 'package:eschoolapp/screen/payment_receipt.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../models/payment_history_model.dart';
import '../widget_helper/widgets_helper.dart';
import 'package:eschoolapp/utils/constants.dart' as constant;

class FeesHistoryScreen extends StatefulWidget {
  final String studentId;
  final String currentYear;
  final StudentModel studentModel;
  // final Map<String, dynamic> studentMap;

  const FeesHistoryScreen(
      {super.key,
        required this.studentId,
        required this.currentYear, required this.studentModel,
        // required this.studentMap
      });

  @override
  State<FeesHistoryScreen> createState() => _FeesHistoryScreenState();
}

class _FeesHistoryScreenState extends State<FeesHistoryScreen> {
  List<PaymentHistoryModel> paymentHistoryModel=[];
  bool isNetConnected=true;
  @override
  void initState() {
    super.initState();
    checkInternet();
    // initial();

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
  // initial({isBackToOnline=false}) async {
  //   if(isBackToOnline==true){
  //     constant.showCustomSnackBarOnline(context);
  //     setState(() {
  //
  //     });
  //   }
  //   // listener?.cancel();
  //   // paymentHistoryModel =
  //   //     (await GlobalHelper().feePaid(widget.studentId, widget.currentYear))!;
  //
  // }
  @override
  dispose() {
    listener?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
        appBar: appbar(context, 'Payment History', 'Academic Year ${widget.currentYear.substring(0, 4)}-${widget.currentYear.substring(4, 6)}'),
        // appBar: PreferredSize(
        //     preferredSize: const Size.fromHeight(200),
        //     child: MyAppBar(
        //       leading: MyTextButton(
        //         myWidget: const Icon(Icons.arrow_back_ios, color: Colors.white),
        //         callback: () {
        //           Navigator.pop(context);
        //         },
        //       ),
        //       title: "Payment History",
        //       containerHeight: 160,
        //       between: Positioned(
        //         bottom: -20,
        //         left: 25,
        //         right: 25,
        //         child: Container(
        //           decoration: BoxDecoration(
        //               color: Colors.white,
        //               borderRadius: BorderRadius.circular(10)),
        //           height: 45,
        //           child: Center(
        //               child: Text(
        //             'Academic Year ${widget.currentYear.substring(0, 4)}-${widget.currentYear.substring(4, 6)}',
        //             style: const TextStyle(fontSize: 18),
        //           )),
        //         ),
        //       ),
        //     )),
        body:
        isNetConnected==false?Container():  FutureBuilder(
            future: GlobalHelper().paidFeesHistory(widget.studentId, widget.currentYear) ,
            builder: (context,snapshot) {
              if(snapshot.connectionState==ConnectionState.done){
                if(snapshot.hasData){
                  paymentHistoryModel=snapshot.data as List<PaymentHistoryModel>;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: paymentHistoryModel.length,
                    itemBuilder: (context, index) {
                      var payHistory = paymentHistoryModel[index];
                      return SizedBox(
                        height: 180,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 27),
                                  child: Column(
                                    children: [
                                      const Gap(34),
                                      Expanded(
                                        child: MyTextMedium(
                                            maxLines: 2,
                                            title: constant.dateToDate2(
                                                payHistory.createDate.toString())),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Row(
                                children: [
                                  const Gap(25),
                                  SizedBox(
                                    width: 32,
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: VerticalDivider(
                                              color: HexColor('#ABADAE'),
                                              thickness: 3),
                                        ),
                                        const Positioned(
                                          top: 36,
                                          child: Icon(Icons.brightness_1,
                                              color: Colors.green, size: 35),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MyTextSmall(
                                            color: HexColor('#7B7B7B'),
                                            title:
                                            "Receipt No: ${payHistory.receiptNo}"),
                                        const Gap(7),
                                        MyTextBig(
                                          title:
                                          "${payHistory.totalFeesPaid.toString()}/-",
                                        ),
                                        const Gap(10),
                                        MyTextButton(
                                            callback: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PaymentReceipt(
                                                          paymentHistoryModel:
                                                          payHistory,
                                                          studentModel: widget.studentModel,
                                                        ),
                                                  ));
                                            },
                                            bgColor: Colors.blue,
                                            myWidget: const MyTextSmall(
                                              title: "View Receipt",
                                              color: Colors.white,
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }else{

                  return Center(child: Text('No Data'),);
                }
              }else{
                return Center(child:  CircularProgressIndicator(),);
              }
            }
        ));
  }
}


import 'package:eschoolapp/models/payment_history_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../models/student_model.dart';

class PaymentReceipt extends StatefulWidget {
  final PaymentHistoryModel paymentHistoryModel;
  final StudentModel studentModel;
  // final Map<String, dynamic> studentMap;

  const PaymentReceipt(
      {super.key, required this.paymentHistoryModel, required this.studentModel,
        // required this.studentMap
      });

  @override
  State<PaymentReceipt> createState() => _PaymentReceiptState();
}

class _PaymentReceiptState extends State<PaymentReceipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Receipt'),),
      // appBar: PreferredSize(
      //     preferredSize: const Size.fromHeight(170),
      //     child: MyAppBar(
      //       leading: MyTextButton(
      //         myWidget: const Icon(Icons.arrow_back_ios, color: Colors.white),
      //         callback: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //       title: "Receipt",
      //       containerHeight: 160,
      //       between: Positioned(
      //         bottom: -20,
      //         left: 25,
      //         right: 25,
      //         child: Container(
      //           decoration: BoxDecoration(
      //               color: Colors.white,
      //               borderRadius: BorderRadius.circular(10)),
      //           height: 45,
      //           child: const Center(
      //               child: Text(
      //                 'Payment Receipt',
      //                 style: TextStyle(fontSize: 18),
      //               )),
      //         ),
      //       ),
      //     )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Row(
            children: [
              Image.asset(
                'assets/icon_logo.png',
                height: 90,
              ),
              const Gap(10),
              const Expanded(
                child: Text('Gurukul Internation School',
                    style: TextStyle(fontSize: 22)),
              ),
            ],
          ),
          const Divider(),
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Fees Receipt No.: ${widget.paymentHistoryModel.receiptNo}'),
                      Text('Roll No.: ${widget.studentModel.rollNo}'),
                      Text(
                        'Name: ${widget.studentModel.name} ${widget.studentModel.fatherName} ${widget.studentModel.surname}',
                      ),
                      Text('Class: ${widget.studentModel.std}'),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Date: ${widget.paymentHistoryModel.receiptDate.toString().substring(0, 10)}'),
                      Text(
                          'Student ID: ${widget.paymentHistoryModel.studentId}'),
                      Text('Div: ${widget.studentModel.div}'),
                      Text(
                          'Academic Year: ${widget.paymentHistoryModel.txtYear.toString().substring(0, 4)}-${widget.paymentHistoryModel.txtYear.toString().substring(4, 6)}'),
                    ],
                  ),
                )
              ]),
          const Divider(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Fees Head'),
              Text('Amount'),
            ],
          ),
          const Divider(),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Admission Fees'),
                      const Text('Tuition Fees'),
                      (widget.paymentHistoryModel.numTerm1Fee != null &&
                          widget.paymentHistoryModel.numTerm1Fee != '0')
                          ? const Text('Term 1 Fees')
                          : Container(),
                      (widget.paymentHistoryModel.numTerm2Fee != null &&
                          widget.paymentHistoryModel.numTerm2Fee != '0')
                          ? const Text('Term 2 Fees')
                          : Container(),
                      const Text('Exam Fees'),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(widget.paymentHistoryModel.admissionFees
                          .toString()),
                      Text(widget.paymentHistoryModel.tuitionFees
                          .toString()),
                      (widget.paymentHistoryModel.numTerm1Fee != null &&
                          widget.paymentHistoryModel.numTerm1Fee != '0')
                          ? Text(widget.paymentHistoryModel.numTerm1Fee
                          .toString())
                          : Container(),
                      (widget.paymentHistoryModel.numTerm2Fee != null &&
                          widget.paymentHistoryModel.numTerm2Fee != '0')
                          ? Text(widget.paymentHistoryModel.numTerm2Fee
                          .toString())
                          : Container(),
                      Text(widget.paymentHistoryModel.examFee.toString()),
                    ],
                  ),
                )
              ]),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Paid'),
              Text(widget.paymentHistoryModel.totalFeesPaid.toString()),
            ],
          ),
          const Divider(),
        ]),
      ),
    );
  }
}

//I want when view receipt page then directly navigate payment receipt page
//I want skip that payment_historypage
