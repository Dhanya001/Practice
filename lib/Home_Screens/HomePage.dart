import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';

class AppointmentInfoCard extends StatelessWidget {
  const AppointmentInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        return Container(
          height: 130,
          width: width * 0.9,
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade400,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Dotted Line
              Positioned(
                top: 40,
                left: width * 0.18,
                right: width * 0.18,
                child: DottedLine(
                  dashColor: Colors.white,
                  lineThickness: 1.5,
                ),
              ),

              // Circle in the middle
              Positioned(
                top: 32,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Time Section
              Positioned(
                left: 20,
                top: 20,
                child: Column(
                  children: [
                    Icon(Icons.access_time, color: Colors.white, size: 28),
                    SizedBox(height: 8),
                    Text('24 - 04 - 2025',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                    Text('Evening',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),

              // Location Section
              Positioned(
                right: 20,
                top: 20,
                child: Column(
                  children: [
                    Icon(Icons.location_on, color: Colors.white, size: 28),
                    SizedBox(height: 8),
                    Text('Sector 22,',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                    Text('Kalyan',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
