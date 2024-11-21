class PickUpDetails extends StatelessWidget {
  final List<String> items;
  final String day;
  final String timeSlot;

  const PickUpDetails({
    Key? key,
    required this.items,
    required this.day,
    required this.timeSlot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the items, day, and timeSlot as needed in the UI
    return Scaffold(
      appBar: AppBar(title: Text("Pick Up Details")),
      body: Column(
        children: [
          Text("Items: ${items.join(', ')}"),
          Text("Day: $day"),
          Text("Time Slot: $timeSlot"),
        ],
      ),
    );
  }
}

ListView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemCount: scheduledPickups.length,
  itemBuilder: (context, index) {
    final pickup = scheduledPickups[index];
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Colors.grey,
            ),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... (rest of your code)
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: TextButton(
                        onPressed: () async {
                          // Pass the items, day, and time slot to PickUpDetails
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PickUpDetails(
                                items: List<String>.from(pickup['items']),
                                day: formatDate(pickup['date']),
                                timeSlot: pickup['slot'],
                              ),
                            ),
                          );
                        },
                        child: MyExtraSmallText(title: 'Reschedule', color: Colors.white),
                      ),
                    ),
                    Gap(15),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
),
