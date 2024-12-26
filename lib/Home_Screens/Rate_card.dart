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


import 'package:intl/intl.dart';

String formatTransactionDate(String? date) {
  if (date == null) return 'Unknown Date';
  DateTime transactionDate = DateTime.parse(date);
  DateTime now = DateTime.now();
  if (transactionDate.isToday()) {
    return 'Today';
  } else if (transactionDate.isYesterday()) {
    return 'Yesterday';
  } else {
    return DateFormat('dd MMM yyyy').format(transactionDate);
  }
}

// Extension methods for DateTime
extension DateTimeExtensions on DateTime {
  bool isToday() {
    return this.year == DateTime.now().year &&
           this.month == DateTime.now().month &&
           this.day == DateTime.now().day;
  }

  bool isYesterday() {
    return this.year == DateTime.now().year &&
           this.month == DateTime.now().month &&
           this.day == DateTime.now().day - 1;
  }
}
