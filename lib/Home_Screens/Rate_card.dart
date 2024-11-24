class InitCashFreePayment {
  createOrder(String amount, String studentId, String studentFullName,
      String email, String contactNumber) async {
    String paymentApi = "https://sandbox.cashfree.com/pg/orders";


    final http.Response response = await http.post(Uri.parse(paymentApi),
        headers: <String, String>{
          'X-Client-Secret': 'YOUR_CLIENT_SECRET',
          'X-Client-Id': 'YOUR_CLIENT_ID',
          'x-api-version': '2023-08-01',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(inputParams));

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      // Handle success
      if (responseData['order_id'] != null && responseData['payment_session_id'] != null) {
        initialPay(responseData['payment_session_id'], responseData['order_id'], amount, studentId);
      }
    } else {
      print("Failed to create order: ${response.statusCode}");
    }
  }

  void initialPay(String sessionId, String orderId, String amount, String studentId) {
    var session = CFSessionBuilder()
        .setEnvironment(CFEnvironment.SANDBOX)
        .setOrderId(orderId)
        .setPaymentSessionId(sessionId)
        .build();
    var cfWebCheckout = CFWebCheckoutPaymentBuilder().setSession(session).build();
    var cfPaymentGateway = CFPaymentGatewayService();
    cfPaymentGateway.setCallback(
      (p0) {
        // Handle successful payment
        print('Payment successful');
        savePaymentHistory(orderId, amount, studentId, true);
      },
      (p0, p1) {
        // Handle failed payment
        print('Payment failed: ${p0.getMessage()}');
        savePaymentHistory(orderId, amount, studentId, false);
      },
    );
    cfPaymentGateway.doPayment(cfWebCheckout);
  }

  void savePaymentHistory(String orderId, String amount, String studentId, bool isSuccess) async {
    // Call your API to save the payment history
    // Example:
    await GlobalHelper().savePaymentHistory({
      "order_id": orderId,
      "amount": amount,
      "student_id": studentId,
      "status": isSuccess ? "Success" : "Failed",
      "created_at": DateTime.now().toIso8601String()
    });
  }
}


@override
void initState() {
  super.initState();
  checkInternet();
  fetchPaymentHistory();
}

void fetchPaymentHistory() async {
paymentHistoryModel = await GlobalHelper().feePaid(widget.studentId, widget.currentYear);
  setState(() {});
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
    appBar: appbar(context, 'Payment History', 'Academic Year ${widget.currentYear.substring(0, 4)}-${widget.currentYear.substring(4, 6)}'),
    body: isNetConnected == false
        ? Container()
        : FutureBuilder(
            future: GlobalHelper().feePaid(widget.studentId, widget.currentYear),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  paymentHistoryModel = snapshot.data as List<PaymentHistoryModel>;
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
                                          title: constant.dateToDate2(payHistory.createDate.toString()),
                                        ),
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
                                          child: VerticalDivider(color: HexColor('#ABADAE'), thickness: 3),
                                        ),
                                        const Positioned(
                                          top: 36,
                                          child: Icon(Icons.brightness_1, color: Colors.green, size: 35),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MyTextSmall(color: HexColor('#7B7B7B'), title: "Receipt No: ${payHistory.receiptNo}"),
                                        const Gap(7),
                                        MyTextBig(title: "${payHistory.totalFeesPaid.toString()}/-"),
                                        const Gap(10),
                                        MyTextButton(
                                          callback: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => PaymentReceipt(
                                                  paymentHistoryModel: payHistory,
                                                  studentModel: widget.studentModel,
                                                ),
                                              ),
                                            );
                                          },
                                          bgColor: Colors.blue,
                                          myWidget: const MyTextSmall(
                                            title: "View Receipt",
                                            color: Colors.white,
                                          ),
                                        )
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
                } else {
                  return Center(child: Text('No Data'));
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
  );
}



------------------------------------------------


----------------------
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      print("Order ID: ${responseData['order_id']}");
      print("Payment Session ID: ${responseData['payment_session_id']}");
      initialPay(responseData['payment_session_id'], responseData['order_id']);
      return responseData;
    } else {
      print("Failed to payment: ${response.statusCode}");
    }
	
	
	  void initialPay(String sessionId, String orderId) {
    try {
      var session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.SANDBOX)
          .setOrderId(orderId)
          .setPaymentSessionId(sessionId)
          .build();
      var cfWebCheckout =
          CFWebCheckoutPaymentBuilder().setSession(session).build();
      var cfPaymentGateway = CFPaymentGatewayService();
      cfPaymentGateway.setCallback(
        (p0) {
          print('Payment Successful');
          print('Order ID: $orderId');
          print('Payment Session ID: $sessionId');
          print('Payment Response: $p0');
        },
        (p0, p1) {
          print('Payment Failed');
          print('Error Message: ${p0.getMessage()}');
          print('Error Code: $p1');
        },
      );
      cfPaymentGateway.doPayment(cfWebCheckout);
    } catch (e) {
      print('Error during payment: $e');
    }
  }
  
  
  feescreen
  InstallmentsWidget(
  callback: () {
    if (mapData['allow_to_pay'][index] != 0) {
      InitCashFreePayment().createOrder(
        feesDetails[index]['total_fees'].toString(),
        widget.studentId,
        "${widget.studentModel.name} ${widget.studentModel.fatherName} ${widget.studentModel.surname}",
        '', // email can be passed if available
        widget.studentModel.fatherNumber.toString(),
      );
    }
  },
  title: "Installment ${feesDetails[index]['installment']}",
  paid: feesDetails[index]['total_fees'].toString(),
  due: mapData['balance_fees'].toString(),
  btn: mapData['allow_to_pay'][index] == 0 ? 'Paid' : "Pay Now",
  color: mapData['allow_to_pay'][index] == 0 ? HexColor('#ABADAE') : HexColor('#135E9E'),
)
