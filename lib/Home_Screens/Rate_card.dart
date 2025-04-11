import 'package:flutter/material.dart';

class AppointmentSummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Summary'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage('assets/doctor.png'), // Replace with your image
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Doctor Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Service Name',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.access_time, color: Colors.white),
                        Column(
                          children: [
                            Text('24 - 04 - 2025',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            Text('Evening',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12))
                          ],
                        ),
                        Icon(Icons.location_on, color: Colors.white),
                        Flexible(
                          child: Text(
                            'Sector 22,\nKalyan',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 30, thickness: 1),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Patient Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Patient Name\n9878586645 | patientname@gmail.com\nPatient Address',
                      style: TextStyle(height: 1.5),
                    ),
                  ),
                  Divider(height: 30, thickness: 1),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Remark',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Remark Here'),
                  ),
                  Divider(height: 30, thickness: 1),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Booking Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Original Booking: 04 - 04 - 2024 | 04:00 PM'),
                  ),
                  Divider(height: 30, thickness: 1),
                  Text.rich(TextSpan(children: [
                    TextSpan(text: 'Rescheduling is allowed up to '),
                    TextSpan(
                      text: '24 hours before',
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                    TextSpan(text: ' the appointment.'),
                  ])),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                onPressed: () {},
                child: Text('Confirm Appointment',
                    style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade100,
    );
  }
}
