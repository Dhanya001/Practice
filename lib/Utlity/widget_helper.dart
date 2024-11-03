import 'package:flutter/material.dart';

class MySmallText extends StatelessWidget {
  final String title;
  final Color color;
  final bool isBold;

  const MySmallText({
    Key? key,
    required this.title,
    this.color = Colors.black,
    this.isBold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        color: color,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

class MyMediumText extends StatelessWidget {
  final String title;
  final Color color;
  final bool isBold;

  const MyMediumText({
    Key? key,
    required this.title,
    this.color = Colors.black,
    this.isBold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        color: color,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

class MyBigText extends StatelessWidget {
  final String title;
  final Color color;
  final bool isBold;

  const MyBigText({
    Key? key,
    required this.title,
    this.color = Colors.black,
    this.isBold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        color: color,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
