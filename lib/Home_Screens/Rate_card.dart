import 'dart:developer';
import 'package:eschoolapp/models/payment_history_model.dart';
import 'package:eschoolapp/screen/payment_receipt.dart';
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

  const FeesScreen({
    super.key,
    required this.studentId,
    required this.currentYear,
    required this.studentModel,
  });

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  List<Map<String, dynamic>> feesDetails = [];
  List<PaymentHistoryModel> paymentHistoryModel = [];

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
                        currentYear: widget.currentYear,
                        studentId: widget.studentId,
                      ),
                    ),
                  );
                },
                child: const Text('Payment History'),
              ),
            ),
          ],
        ),
        Gap(15),
      ]),
      body: FutureBuilder(
        future: GlobalHelper().feeDetails(widget.studentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // Check if the data is of the expected type
              if (snapshot.data is Map<String, dynamic>) {
                Map<String, dynamic> mapData = snapshot.data as Map<String, dynamic>;
                List<dynamic> feesDataList = mapData['installments'] as List<dynamic>;

                // Ensure paymentHistoryModel is populated correctly
                paymentHistoryModel = mapData['paymentHistory'] as List<PaymentHistoryModel>? ?? [];

                return SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: [
                      const HeaderRow(boxShadow: true, title: "Installment"),
                      Gap(15),
                      ListView.builder(
                        itemCount: feesDataList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index >= feesDataList.length) {
                            return Container(); // Prevent out of range access
                          }

                          feesDetails.add(feesDataList[index]['\u0000yii\\db\\BaseActiveRecord\u0000_attributes']);
                          if (feesDetails[index]['total_fees'] == 0) {
                            return Container(); // Skip if total fees is 0
                          }

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InstallmentsWidget(
                              callback: () async {
                                // Check if paymentHistoryModel has data for the index
                                if (index < paymentHistoryModel.length) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentReceipt(
                                        paymentHistoryModel: paymentHistoryModel[index],
                                        studentModel: widget.studentModel,
                                      ),
                                    ),
                                  );
                                } else {
                                  // Handle the case where there is no corresponding payment history
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('No payment history available for this installment')),
                                  );
                                }
                              },
                              title: "Installment ${feesDetails[index]['installment']}",
                              paid: feesDetails[index]['total_fees'].toString(),
                              due: mapData['balance_fees'].toString(),
                              btn: "View Receipt",
                              color: HexColor('#135E9E'),
                              paymentHistoryModel: paymentHistoryModel.isNotEmpty && index < paymentHistoryModel.length ? paymentHistoryModel[index] : null,
                              studentModel: widget.studentModel,
                            ),
                          );
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
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  FeesColumn(
                                    firstVal: "Total Fees",
                                    secondVal: mapData['total_fees'].toString(),
                                  ),
                                  FeesColumn(
                                    firstVal: "Total Paid",
                                    secondVal: mapData['paid_fees'].toString(),
                                  ),
                                  FeesColumn(
                                    firstVal: "Total Balance",
                                    secondVal: mapData['balance_fees'].toString(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('Data format is incorrect'));
              }
            } else {
              return const Center(child: Text('No Data'));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class InstallmentsWidget extends StatelessWidget {
  final String title;
  final String paid;
  final String due;
  final String btn;
  final Color color;
  final VoidCallback callback;
  final PaymentHistoryModel? paymentHistoryModel; // Nullable
  final StudentModel studentModel;

  const InstallmentsWidget({
    super.key,
    required this.title,
    required this.paid,
    required this.due,
    required this.btn,
    required this.color,
    required this.callback,
    required this.paymentHistoryModel,
    required this.studentModel,
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
              ),
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
              callback: callback,
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

  const FeesColumn({
    super.key,
    required this.firstVal,
    required this.secondVal,
  });

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

This code includes checks to ensure that the lists are not empty before accessing their elements, which should help prevent the "RangeError" you were encountering. If the `paymentHistoryModel` does not have a corresponding entry for the index, it will show a message instead of causing an error.
