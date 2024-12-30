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
  const FeesScreen(
      {super.key,
      required this.studentId,
      required this.currentYear,
      required this.studentModel});
  
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
        appBar: appbar(context, 'Fees', 'Installment'),
        floatingActionButton: FloatingActionButton(onPressed: () async {
          var feedetails1 = await GlobalHelper().feeDetails(widget.studentId);
          print('Dhnanajay');
          print(feedetails1);
        }),
        body: FutureBuilder(
          future: GlobalHelper().feeDetails(widget.studentId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                paymentHistoryModel = snapshot.data as List<PaymentHistoryModel>;
                List<dynamic> feesDataList = [];
                Map<String, dynamic> mapData = snapshot.data as Map<String, dynamic>;
                feesDataList = mapData['installments'] as List<dynamic>;

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
                          feesDetails.add(feesDataList[index]['\u0000yii\\db\\BaseActiveRecord\u0000_attributes']);
                          return feesDetails[index]['total_fees'] == 0
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InstallmentsWidget(
                                    callback: () async {
                                      // Directly navigate to PaymentReceipt
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PaymentReceipt(
                                            paymentHistoryModel: paymentHistoryModel[index],
                                            studentModel: widget.studentModel,
                                          ),
                                        ),
                                      );
                                    },
                                    title: "Installment ${feesDetails[index]['installment']}",
                                    paid: feesDetails[index]['total_fees'].toString(),
                                    due: mapData['balance_fees'].toString(),
                                    btn: "View Receipt",
                                    color: HexColor('#135E9E'),
                                    paymentHistoryModel: paymentHistoryModel[index],
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
                                    secondVal : mapData['balance_fees'].toString(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('No Data'));
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

class InstallmentsWidget extends StatelessWidget {
  final String title;
  final String paid;
  final String due;
  final String btn;
  final Color color;
  final VoidCallback callback;
  final PaymentHistoryModel paymentHistoryModel;
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
  const FeesColumn({super.key, required this.firstVal, required this.secondVal});

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
