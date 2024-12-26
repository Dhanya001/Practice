import 'package:intl/intl.dart';

String formatTransactionDate(String? date) {
  if (date == null) return '';
  DateTime transactionDate = DateTime.parse(date);
  DateTime now = DateTime.now();
  DateTime yesterday = now.subtract(Duration(days: 1));

  if (transactionDate.isAfter(yesterday) && transactionDate.isBefore(now)) {
    return 'Yesterday';
  } else if (transactionDate.isAfter(now)) {
    return 'Today';
  } else {
    return DateFormat('dd MMM yyyy').format(transactionDate);
  }
}

Text(formatTransactionDate(transactionModel.date))

  MyMediumText(
  title: '₹${userWalletModel!.first.amount ?? 0}',
  color: Colors.white,
),
