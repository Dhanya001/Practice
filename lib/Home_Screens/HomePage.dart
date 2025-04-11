import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';

class DateLocationRow extends StatelessWidget {
  const DateLocationRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Time Section
          Column(
            children: [
              Icon(Icons.access_time, color: Colors.white),
              SizedBox(height: 4),
              Text('24 - 04 - 2025',
                  style: TextStyle(color: Colors.white, fontSize: 12)),
              Text('Evening',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),

          // Dotted Line with Circle
          Expanded(
            child: Column(
              children: [
                DottedLine(
                  dashColor: Colors.white,
                  lineThickness: 1.5,
                ),
                SizedBox(height: 6),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          // Location Section
          Column(
            children: [
              Icon(Icons.location_on, color: Colors.white),
              SizedBox(height: 4),
              Text('Sector 22,',
                  style: TextStyle(color: Colors.white, fontSize: 12)),
              Text('Kalyan',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
