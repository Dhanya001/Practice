import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:scrapapp/Utility/BottomNavigation.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:scrapapp/screens/PickUpDetails.dart';
import 'package:scrapapp/screens/Rate_Card_PickUp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> scheduledPickups = [];

  @override
  void initState() {
    super.initState();
    _getScheduledPickups();
  }

  Future<void> _getScheduledPickups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? pickups = prefs.getStringList('scheduledPickups');

    if (pickups != null) {
      setState(() {
        scheduledPickups = pickups.map((pickup) => jsonDecode(pickup) as Map<String, dynamic>).toList();
      });
    }
  }

  String formatDate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('d MMM').format(dateTime);
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Navigate based on index
  }

  void _reschedulePickup(Map<String, dynamic> pickup) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PickUpDetails(
        Day: formatDate(pickup['date']),
        TimeSlot: pickup['slot'],
        Weight: pickup['weight'],
        Notes: pickup['notes'],
        items: List<String>.from(pickup['items']),
      )),
    );
  }

  void _cancelPickup(Map<String, dynamic> pickup) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? existingPickups = prefs.getStringList('scheduledPickups');

    if (existingPickups != null) {
      existingPickups.removeWhere((item) {
        Map<String, dynamic> pickupData = jsonDecode(item);
        return pickupData['date'] == pickup['date'] &&
               pickupData['slot'] == pickup['slot'] &&
               pickupData['weight'] == pickup['weight'] &&
               pickupData['notes'] == pickup['notes'];
      });
      await prefs.setStringList('scheduledPickups', existingPickups);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pickup canceled successfully')));
      _getScheduledPickups(); // Refresh the list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: ListView.builder(
        itemCount: scheduledPickups.length,
        itemBuilder: (context, index) {
          final pickup = scheduledPickups[index];
          return ListTile(
            title: Text(formatDate(pickup['date'])),
            subtitle: Text(pickup['slot']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _reschedulePickup(pickup),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _cancelPickup(pickup),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigation(currentIndex: _currentIndex, onTap: _onTap),
    );
  }
}

class PickUpDetails extends StatefulWidget {
  final String Day;
  final String TimeSlot;
  final String Weight;
  final String Notes;
  List<String> items;

  PickUpDetails({
    super.key,
    required this.Day,
    required this.TimeSlot,
    required this.Weight,
    required this.Notes,
    required this.items,
 });

  @override
  State<PickUpDetails> createState() => _PickUpDetailsState();
}

class _PickUpDetailsState extends State<PickUpDetails> {
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Navigate based on index
  }

  void _reschedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? existingPickups = prefs.getStringList('scheduledPickups');

    if (existingPickups != null) {
      existingPickups.removeWhere((pickup) {
        Map<String, dynamic> pickupData = jsonDecode(pickup);
        return pickupData['date'] == widget.Day &&
               pickupData['slot'] == widget.TimeSlot &&
               pickupData['weight'] == widget.Weight &&
               pickupData['notes'] == widget.Notes;
      });

      // Update the pickup details
      Map<String, dynamic> updatedPickup = {
        'date': widget.Day,
        'slot': widget.TimeSlot,
        'weight': widget.Weight,
        'notes': widget.Notes,
        'items': widget.items,
      };
      existingPickups.add(jsonEncode(updatedPickup));
      await prefs.setStringList('scheduledPickups', existingPickups);
      Navigator.pop(context); // Go back to the previous screen
    }
  }

  void _cancel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? existingPickups = prefs.getStringList('scheduledPickups');

    if (existingPickups != null) {
      existingPickups.removeWhere((pickup) {
        Map<String, dynamic> pickupData = jsonDecode(pickup);
        return pickupData['date'] == widget.Day &&
               pickupData['slot'] == widget.TimeSlot &&
               pickupData['weight'] == widget.Weight &&
               pickupData['notes'] == widget.Notes;
      });

      await prefs.setStringList('scheduledPickups', existingPickups);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pickup canceled successfully')));
      Navigator.pop(context); // Go back to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pick Up Details")),
      body: Column(
        children: [
          Text("Date: ${widget.Day}"),
          Text("Time Slot: ${widget.TimeSlot}"),
          Text("Weight: ${widget.Weight}"),
          Text("Notes: ${widget.Notes}"),
          // Display items
          Wrap(
            children: widget.items.map((item) => Chip(label: Text(item))).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: _reschedule, child: Text("Reschedule")),
              ElevatedButton(onPressed: _cancel, child: Text("Cancel")),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(currentIndex: _currentIndex, onTap: _onTap),
    );
  }
}

class RateCardPickup extends StatefulWidget {
  List<String> SelectedItems;
  String ScheduleWeight;
  String ScheduleDate;
  int ScheduleTimeslot;
  String ScheduleNotes;

  RateCardPickup({
    super.key,
    required this.SelectedItems,
    required this.ScheduleWeight,
    required this.ScheduleDate,
    required this.ScheduleTimeslot,
    required this.ScheduleNotes,
  });

  @override
  State<RateCardPickup> createState() => _RateCardPickupState();
}

class _RateCardPickupState extends State<RateCardPickup> {
  // Existing code...

  void _schedulePickup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? existingPickups = prefs.getStringList('scheduledPickups');

    Map<String, dynamic> newPickup = {
      'date': widget.ScheduleDate,
      'slot': widget.ScheduleTimeslot,
      'weight': widget.ScheduleWeight,
      'notes': widget.ScheduleNotes,
      'items': widget.SelectedItems,
    };

    if (existingPickups != null) {
      existingPickups.add(jsonEncode(newPickup));
      await prefs.setStringList('scheduledPickups', existingPickups);
    } else {
      await prefs.setStringList('scheduledPickups', [jsonEncode(newPickup)]);
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => CapturePickup(
      onWeightChanged: (String weight) {},
      SelectedItems: widget.SelectedItems,
      ScheduleWeight: widget.ScheduleWeight,
      ScheduleNotes: widget.ScheduleNotes,
      ScheduleDate: widget.ScheduleDate,
      ScheduleTimeslot: widget.ScheduleTimeslot,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rate Card Pickup")),
      body: Column(
        children: [
          // Existing UI components...
          ElevatedButton(
            onPressed: _schedulePickup,
            child: Text("Schedule Pickup"),
          ),
        ],
      ),
    );
  }
}

Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => CapturePickup(
    onWeightChanged: (String weight) {},
    SelectedItems: widget.SelectedItems,
    ScheduleWeight: widget.ScheduleWeight,
    ScheduleNotes: widget.ScheduleNotes,
    ScheduleDate: widget.ScheduleDate,
    ScheduleTimeslot: widget.ScheduleTimeslot,
  )),
);

MyBottomButton(
  title: "Next",
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CalendarPickup(
        TotWeight: _weightcontroller.text,
        selectedItems: widget.SelectedItems,
        ScheduleNotes: widget.ScheduleNotes,
        ScheduleDate: widget.ScheduleDate,
        ScheduleTimeslot: widget.ScheduleTimeslot,
      )),
    );
  },
);


MyBottomButton(
  title: "Next",
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScheduleSummary(
        selectedDate: _focusedDay,
        TotWeight: widget.TotWeight,
        selectedSlot: _timeslot[_selectedslot!],
        selectedItems: widget.selectedItems,
        ScheduleNotes: widget.ScheduleNotes,
      )),
    );
  },
);


class ScheduleSummary extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedSlot;
  final String TotWeight;
  final String ScheduleNotes;
  final List<Map<String, dynamic>> selectedItems;

  ScheduleSummary({
    super.key,
    required this.selectedDate,
    required this.TotWeight,
    required this.selectedSlot,
    required this.selectedItems,
    required this.ScheduleNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Schedule Summary")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Scheduled Date: ${selectedDate.toLocal()}"),
                Text("Time Slot: $selectedSlot"),
                Text("Estimated Weight: $TotWeight"),
                Text("Notes: $ScheduleNotes"),
                Wrap(
                  children: selectedItems.map((item) => Chip(label: Text(item['title']))).toList(),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Logic to confirm the schedule
              // This is where you could save to SharedPreferences if needed
            },
            child: Text("Confirm Schedule"),
          ),
        ],
      ),
    );
  }
}
import 'package:google_sign_in/google_sign_in.dart';

// Add this method to handle Google Sign-In
Future<void> _signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleUser  = await googleSignIn.signIn();
  final GoogleSignInAuthentication? googleAuth = await googleUser ?.authentication;

  if (googleAuth != null) {
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    // Navigate to the home page after successful sign-in
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}

@override
void initState() {
  super.initState();
  Timer(Duration(seconds: 3), () async {
    User? user = FirebaseAuth.instance.currentUser ;
    if (user != null) {
      // User is signed in, navigate to home page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      // User is not signed in, navigate to onboarding
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => OnboardingView()),
      );
    }
  });
}
