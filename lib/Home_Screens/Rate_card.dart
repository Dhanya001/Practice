ListView.builder(
  itemCount: ApiGlbData.parentCommunicationGlbData.length,
  itemBuilder: (context, index) {
    return NotificationTile(
      title: ApiGlbData.parentCommunicationGlbData[index].title,
      dateTime: ApiGlbData.parentCommunicationGlbData[index].createdAt,
      notificationId: ApiGlbData.parentCommunicationGlbData[index].id,
      notificationIdList: perfectCommunicationId,
    );
  },
),


// Add this method to fetch parent communication data
Future<List<CommunicationModel>> fetchParentCommunications() async {
  // Replace with your actual method to fetch communications
  return await GlobalHelper().parentCommunicationList(widget.studentId);
}

// Update the NotificationIcon class
class _NotificationIconState extends State<NotificationIcon> {
  List<dynamic> homeworkIdList = [];
  List<dynamic> announceIdList = [];
  List<dynamic> communicationIdList = []; // New list for communications
  List<dynamic> perfectAnnId = [];
  List<dynamic> perfectHomeworkId = [];
  List<dynamic> perfectCommunicationId = []; // New list for perfect communications

  @override
  void initState() {
    super.initState();
    initial();
  }

  initial() async {
    // Fetch announcements and homework as before
    var notificationId = (await GlobalHelper().getListOfNotificationId(widget.studentId))!;
    announceIdList = notificationId['notification_announcement'];
    homeworkIdList = notificationId['notification_homework'];
    communicationIdList = await fetchParentCommunications(); // Fetch communications

    // Process the lists as before
    announceIdList.removeWhere((element) => element == null);
    homeworkIdList.removeWhere((element) => element == null);
    perfectAnnId = announceIdList.toSet().toList();
    perfectHomeworkId = homeworkIdList.toSet().toList();
    perfectCommunicationId = communicationIdList.toSet().toList(); // Process communications

    // Update notification count logic as needed
    updateNotificationCount();
  }

  void updateNotificationCount() {
    // Update your logic to include communication notifications
    List homeworkAndHomeworkRangId = [];
    var set1 = Set.from(homeworkAndHomeworkRangId);
    var set2 = Set.from(perfectHomeworkId + perfectAnnId + perfectCommunicationId); // Include communications

    notificationUnreadCount = set1.difference(set2).length;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            initial();
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                body: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back)),
                      const MyTextMedium(title: "Notification"),
                      const MyTextMedium(title: " "),
                    ],
                  ),
                  const TabBar(
                      labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      isScrollable: true,
                      tabAlignment: TabAlignment.center,
                      tabs: [
                        Tab(text: "Announcement"),
                        Tab(text: "Homework"),
                        Tab(text: "Other") // New tab for Other
                      ]),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Existing Announcement ListView
                        ListView.builder(
                          itemCount: ApiGlbData.announcementGlbData.length > 10
                              ? 10
                              : ApiGlbData.announcementGlbData.length,
                          itemBuilder: (context, index) {
                            // Your existing code for announcements
                          },
                        ),
                        // Existing Homework ListView
                        ListView.builder(
                          itemCount: ApiGlbData.homeworkGlbData.length > 10
                              ? 10
                              : ApiGlbData.homeworkGlbData.length,
                          itemBuilder: (context, index) {
                            // Your existing code for homework
                          },
                        ),
                        // New ListView for Parent Communications
                        ListView.builder(
                          itemCount: perfectCommunicationId.length,
                          itemBuilder: (context, index) {
                            // Replace with your communication model
                            var communication = perfectCommunicationId[index];
                            return InkWell(
                              onTap: () {
                                // Handle communication tap
                              },
                              child: NotificationTile(
                                notificationIdList: perfectCommunicationId,
                                notificationId: communication.id, // Adjust as per your model
                                title: communication .title, // Adjust as per your model
                                dateTime: communication.createdAt, // Adjust as per your model
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ])),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Stack(
            children: [
              const SizedBox(
                height: 30,
                width: 46,
                child: Icon(
                  color: Colors.white,
                  Icons.notifications,
                  size: 32,
                ),
              ),
              Positioned(
                  right: 0,
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(5),
                            left: Radius.circular(5)),
                        color: notificationUnreadCount == 0
                            ? Colors.transparent
                            : Colors.red.shade200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Center(
                        child: Text(
                            notificationUnreadCount == 0
                                ? ''
                                : notificationUnreadCount.toString(),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 10)),
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
}
