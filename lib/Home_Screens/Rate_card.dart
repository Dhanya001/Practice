void initialPay(
    BuildContext context,
    String sessionId,
    String orderId,
    String amount,
    String studentId,
    String cf_id,
    String currentYear,
    String installments,
    String installment_id,
    Function onPaymentSuccess
    ) {
  var session = CFSessionBuilder()
      .setEnvironment(CFEnvironment.SANDBOX)
      .setOrderId(orderId)
      .setPaymentSessionId(sessionId)
      .build();
  var cfWebCheckout = CFWebCheckoutPaymentBuilder().setSession(session).build();
  var cfPaymentGateway = CFPaymentGatewayService();
  cfPaymentGateway.setCallback(
    (p0) async{
      // InitCashFreePayment().orderStatus(orderId);
       onPaymentSuccess();
  
      await GlobalHelper().paymentResponse(
          orderId, studentId, currentYear, installments, installment_id);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessful(
              amount: amount,
              transactionId: '4849398439static',
             isSuccessStatus: true,
            ),
          ));

      print('Payment successful p0: $p0}');
      print('Payment successful cf_order_id: $cf_id}');
      print('Payment successful sessionId: $sessionId}');
      print('Payment successful orderId: $orderId}');
      print('Payment successful amount: $amount}');
      print('Payment successful studentId: $studentId}');
    },
    (p0, p1) async {
      // await InitCashFreePayment().orderStatus(cf_id);

     await GlobalHelper().paymentResponse(
          orderId, studentId, currentYear, installments, installment_id);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessful(
              amount: amount,
              transactionId: '4849398439static',
              isSuccessStatus: false,
            ),
          ));
      print('Payment failed p0.getMessage(): ${p0.getMessage()}');
      print('Payment failed p0.getCode(): ${p0.getCode()}');
      print('Payment failed p0.getStatus(): ${p0.getStatus()}');
      print('Payment failed p0.getType(): ${p0.getType()}');

      print('Payment failed cf_order_id: $cf_id');
      print('Payment failed p1: $p1');
      print('Payment failed sessionId: $sessionId}');
      print('Payment failed orderId: $orderId}');
      print('Payment failed amount: $amount}');
      print('Payment failed studentId: $studentId}');
    },
  );
  cfPaymentGateway.doPayment(cfWebCheckout);
}

                                            InitCashFreePayment().createOrder(
                                            context,
                                            paymentInitialStoreInfoResponse[
                                                'reference_no'],

                                            paymentInitialStoreInfoResponse[
                                            'total_fees'],

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
                                            (){
                                              setState(() {});
                                            }
                                            );
											



-----------------------------------------

  
void initialPay(
    BuildContext context,
    String sessionId,
    String orderId,
    String amount,
    String studentId,
    String cf_id,
    String currentYear,
    String installments,
    String installment_id) {
  var session = CFSessionBuilder()
      .setEnvironment(CFEnvironment.SANDBOX)
      .setOrderId(orderId)
      .setPaymentSessionId(sessionId)
      .build();
  var cfWebCheckout = CFWebCheckoutPaymentBuilder().setSession(session).build();
  var cfPaymentGateway = CFPaymentGatewayService();
  cfPaymentGateway.setCallback(
    (p0) async{
      String actualTransactionId = cf_id;
       String actualAmount = amount;
      // InitCashFreePayment().orderStatus(orderId);
      await GlobalHelper().paymentResponse(
          orderId, studentId, currentYear, installments, installment_id);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessful(
              amount: actualAmount,
              transactionId: actualTransactionId,
             isSuccessStatus: true,
            ),
          ));

      print('Payment successful p0: $p0}');
      print('Payment successful cf_order_id: $cf_id}');
      print('Payment successful sessionId: $sessionId}');
      print('Payment successful orderId: $orderId}');
      print('Payment successful amount: $amount}');
      print('Payment successful studentId: $studentId}');
    },
    (p0, p1) async {
      // await InitCashFreePayment().orderStatus(cf_id);

     await GlobalHelper().paymentResponse(
          orderId, studentId, currentYear, installments, installment_id);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessful(
              amount: actualAmount,
              transactionId: 'Transaction failed',
              isSuccessStatus: false,
            ),
          ));
      print('Payment failed p0.getMessage(): ${p0.getMessage()}');
      print('Payment failed p0.getCode(): ${p0.getCode()}');
      print('Payment failed p0.getStatus(): ${p0.getStatus()}');
      print('Payment failed p0.getType(): ${p0.getType()}');

      print('Payment failed cf_order_id: $cf_id');
      print('Payment failed p1: $p1');
      print('Payment failed sessionId: $sessionId}');
      print('Payment failed orderId: $orderId}');
      print('Payment failed amount: $amount}');
      print('Payment failed studentId: $studentId}');
    },
  );
  cfPaymentGateway.doPayment(cfWebCheckout);
}

InitCashFreePayment().createOrder(
                                            context,
                                            paymentInitialStoreInfoResponse[
                                                'reference_no'],

                                            paymentInitialStoreInfoResponse[
                                            'total_fees'],

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
                                            widget.currentYear);
setState(() {
                                              feesDetails.clear(); 
                                               });

