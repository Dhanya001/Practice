// Widget_Helper.dart

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

const List<String> timeSlots = [
  "09:00 AM - 12:00 PM",
  "01:00 PM - 04:00 PM",
  "05:00 PM - 08:00 PM",
];

String monthName(int month) {
  const monthNames = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];
  return monthNames[month - 1];
}

String formatDate(String isoDate) {
  DateTime dateTime = DateTime.parse(isoDate);
  return DateFormat('d MMM').format(dateTime);
}

String getSlotTitle(Map<String, dynamic> pickup) {
  try {
    int slotIndex = int.parse(pickup['slot'].toString());
    if (slotIndex >= 0 && slotIndex < timeSlots.length) {
      return timeSlots[slotIndex];
    } else {
      return 'Unknown Slot';
    }
  } catch (e) {
    return 'Invalid Slot';
  }
}



print("Fetched pickups: $pickups");
if (pickups != null) {
  setState(() {
    scheduledPickups = pickups;
  });
}


Expanded(
  child: scheduledPickups.isNotEmpty
      ? ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: scheduledPickups.length,
          itemBuilder: (context, index) {
            final pickup = scheduledPickups[index];
            // ...
          },
        )
      : Center(
          child: Text("No scheduled pickups"),
        ),
)


@override
void initState() {
  super.initState();
  print("initState called");
  _getScheduledPickups().then((pickups) {
    setState(() {
      scheduledPickups = pickups;
      print(pickups);
    });
  });
}
