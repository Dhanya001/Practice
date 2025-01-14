class MyPickUp extends StatefulWidget {
  const MyPickUp({super.key});

  @override
  State<MyPickUp> createState() => _MyPickUpState();
}

class _MyPickUpState extends State<MyPickUp> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<dynamic> allPickups = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchPickups();
  }

  fetchPickups() async {
    // Assuming you have a method to get the user ID
    String userId = "your_user_id"; // Replace with actual user ID
    allPickups = await getschedulepickup(userId);
    setState(() {});
  }

  getschedulepickup(String user_id) async {
    try {
      var response = await http.get(Uri.parse(
        '${constant.apiLocalName}/pickupHistory?user_id=$user_id',
      ));
      log(response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var pickupData = responseData['schedule_data'];
        return pickupData;
      } else {
        throw Exception('Failed to Fetch Schedule pickup details: ${response.statusCode}');
      }
    } on Exception catch (e) {
      print('Error during Fetch Schedule pickup details: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('My Pick Ups',
          style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w500,
          ),),
        centerTitle: true,
        bottom: TabBar(
          indicatorColor: Theme.of(context).primaryColor,
          controller: _tabController,
          tabs: [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Canceled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UpcomingPickUps(pickups: allPickups.where((pickup) => pickup['status'] == 'pending').toList()),
          CompletedPickUps(pickups: allPickups.where((pickup) => pickup['status'] == 'complete').toList()),
          CanceledPickUps(pickups: allPickups.where((pickup) => pickup['status'] == 'canceled').toList()),
        ],
      ),
    );
  }
}

class UpcomingPickUps extends StatelessWidget {
  final List<dynamic> pickups;

  UpcomingPickUps({required this.pickups});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pickups.length,
      itemBuilder: (context, index) {
        final pickup = pickups[index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: index == 0 ? Theme.of(context).primaryColor : Colors.grey,
                ),
                color: index == 0 ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Upcoming',
                          style: TextStyle(color: index == 0 ? Colors.white : Theme.of(context).shadowColor),
                        ),
                        Text(
                          '${pickup['schedules_id']}',
                          style: TextStyle(color: index == 0 ? Colors.white : Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0), child: Align(
                    alignment: Alignment.topLeft,
                    child: MyBigText(title: '${formatDate(pickup[' pickup_date'])}', color: index == 0 ? Colors.white : Theme.of(context).primaryColor),
                    ),
                  ),
                  Divider(
                    color: index == 0 ? Colors.white : Colors.grey[300],
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyTextButton(
                          title: 'Reschedule',
                          onPressed: () {
                            // Implement reschedule functionality
                          },
                          color: Theme.of(context).shadowColor,
                        ),
                        TextButton(
                          onPressed: () {
                            // Implement view details functionality
                          },
                          child: Text('View Details',
                            style: TextStyle(
                              color: index == 0 ? Colors.white : Theme.of(context).primaryColor,
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
    );
  }
}

class CompletedPickUps extends StatelessWidget {
  final List<dynamic> pickups;

  CompletedPickUps({required this.pickups});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pickups.length,
      itemBuilder: (context, index) {
        final pickup = pickups[index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: index == 0 ? Theme.of(context).primaryColor : Colors.grey,
                ),
                color: index == 0 ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Completed',
                          style: TextStyle(color: index == 0 ? Colors.white : Theme.of(context).shadowColor),
                        ),
                        Text(
                          '${pickup['schedules_id']}',
                          style: TextStyle(color: index == 0 ? Colors.white : Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0), child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('${formatDate(pickup['pickup_date'])}',
                      style: TextStyle(fontSize: 20, color: index == 0 ? Colors.white : Theme.of(context).primaryColor),
                    ),
                  ),
                  ),
                  Divider(
                    color: index == 0 ? Colors.white : Colors.grey[300],
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                          ),
                          child: TextButton(
                            onPressed: () {
                              // Implement reschedule functionality
                            },
                            child: MySmallText(title: 'Reschedule', color: Colors.white,),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Implement view details functionality
                          },
                          child: Text('View Details',
                            style: TextStyle(
                              color: index == 0 ? Colors.white : Theme.of(context).primaryColor,
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
    );
  }
}

class CanceledPickUps extends StatelessWidget {
  final List<dynamic> pickups;

  CanceledPickUps({required this.pickups});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pickups.length,
      itemBuilder: (context, index) {
        final pickup = pickups[index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: index == 0 ? Theme.of(context).primaryColor : Colors.grey,
                ),
                color: index == 0 ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Canceled',
                          style: TextStyle(color: index == 0 ? Colors.white : Theme.of(context).shadowColor),
                        ),
                        Text(
                          '${pickup['schedules_id']}',
                          style: TextStyle(color: index == 0 ? Colors.white : Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0), child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('${formatDate(pickup['pickup_date'])}',
                      style: TextStyle(fontSize: 20, color: index == 0 ? Colors.white : Theme.of(context).primaryColor),
                    ),
                  ),
                  ),
                  Divider(
                    color: index == 0 ? Colors.white : Colors.grey[300],
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                          ),
                          child: TextButton(
                            onPressed: () {
                              // Implement reschedule functionality
                            },
                            child: MySmallText(title: 'Reschedule', color: Colors.white,),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Implement view details functionality
                          },
                          child: Text('View Details',
                            style: TextStyle(
                              color: index == 0 ? Colors.white : Theme.of(context).primaryColor,
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
    );
  }
} ```dart
// The code above has been updated to filter the pickup data based on their status.
// Ensure that the `CanceledPickUps` class is also updated to handle the canceled status if needed.

class MyPickUp extends StatefulWidget {
  const MyPickUp({super.key});

  @override
  State<MyPickUp> createState() => _MyPickUpState();
}

class _MyPickUpState extends State<MyPickUp> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<dynamic> allPickups = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchPickups();
  }

  fetchPickups() async {
    String userId = "your_user_id"; // Replace with actual user ID
    allPickups = await getschedulepickup(userId);
    setState(() {});
  }

  getschedulepickup(String user_id) async {
    try {
      var response = await http.get(Uri.parse(
        '${constant.apiLocalName}/pickupHistory?user_id=$user_id',
      ));
