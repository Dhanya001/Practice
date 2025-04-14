import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppointmentScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String selectedTab = "All";

  List<Map<String, dynamic>> allAppointments = [
    {"status": "Completed", "date": "24 - 04 - 2025", "time": "Evening", "location": "Sector 22, Kalyan"},
    {"status": "Upcoming", "date": "24 - 04 - 2025", "time": "Evening", "location": "Sector 22, Kalyan"},
    {"status": "Upcoming", "date": "24 - 04 - 2025", "time": "Evening", "location": "Sector 22, Kalyan"},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredAppointments = selectedTab == "All"
        ? allAppointments
        : allAppointments.where((item) => item["status"] == selectedTab).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        centerTitle: true,
        title: Text("My Appointment", style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ["All", "Upcoming", "Completed"].map((tab) {
              bool isSelected = selectedTab == tab;
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedTab = tab;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.blue : Colors.orange,
                  shape: StadiumBorder(),
                ),
                child: Text(tab, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAppointments.length,
              itemBuilder: (context, index) {
                var appointment = filteredAppointments[index];
                bool isCompleted = appointment["status"] == "Completed";

                return Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(backgroundImage: AssetImage('assets/doctor.jpg')), // Replace with actual image
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Doctor Name", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("Service Name"),
                              ],
                            ),
                            Spacer(),
                            if (isCompleted)
                              Row(
                                children: [
                                  Icon(Icons.circle, color: Colors.green, size: 10),
                                  SizedBox(width: 4),
                                  Text("Completed", style: TextStyle(color: Colors.green)),
                                ],
                              ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Icon(Icons.access_time, color: Colors.white),
                                  SizedBox(height: 4),
                                  Text(appointment["date"], style: TextStyle(color: Colors.white)),
                                  Text(appointment["time"], style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              Icon(Icons.more_horiz, color: Colors.white),
                              Column(
                                children: [
                                  Icon(Icons.location_on, color: Colors.white),
                                  SizedBox(height: 4),
                                  Text(appointment["location"], style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
