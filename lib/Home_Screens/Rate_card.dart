class ScheduleModel {
  int? orderItemsID;
  String? pickupDate;
  String? startTime;
  String? endTime;
  List<ScheduleItem>? scheduleItems; // Add this line
  int? unitId;
  String? totWeight;
  String? notes;
  int? addressId;
  String? status;

  ScheduleModel({
    this.orderItemsID,
    this.pickupDate,
    this.startTime,
    this.endTime,
    this.scheduleItems, // Add this line
    this.unitId,
    this.totWeight,
    this.notes,
    this.addressId,
    this.status,
  });

  ScheduleModel.from(Map<String, dynamic> map)
      : orderItemsID = map['schedules_id'],
        pickupDate = map['pickup_date'],
        startTime = map['start_time'],
        endTime = map['end_time'],
        scheduleItems = (map['schedule_items'] as List)
            .map((item) => ScheduleItem.from(item))
            .toList(), // Parse schedule items
        unitId = map['unit_id'],
        totWeight = map['est_weight'],
        notes = map['note'],
        addressId = map['address_id'],
        status = map['status'];

  Map<String, Object?> toMap() {
    return {
      'schedules_id': orderItemsID,
      'pickup_date': pickupDate,
      'start_time': startTime,
      'end_time': endTime,
      'schedule_items': scheduleItems?.map((item) => item.toMap()).toList(), // Convert schedule items to map
      'unit_id': unitId,
      'est_weight': totWeight,
      'note': notes,
      'address_id': addressId,
      'status': status,
    };
  }
}

class ScheduleItem {
  int? scheduleItemsID;
  int? productId;
  String? productName;
  String? estWeight;
  String? note;

  ScheduleItem({
    this.scheduleItemsID,
    this.productId,
    this.productName,
    this.estWeight,
    this.note,
  });

  ScheduleItem.from(Map<String, dynamic> map)
      : scheduleItemsID = map['schedule_items_id'],
        productId = map['product_id'],
        productName = map['product_name'],
        estWeight = map['est_weight'],
        note = map['note'];

  Map<String, Object?> toMap() {
    return {
      'schedule_items_id': scheduleItemsID,
      'product_id': productId,
      'product_name': productName,
      'est_weight': estWeight,
      'note': note,
    };
  }
}


TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PickUpDetails(
          pickupId: pickup['schedules_id'].toString(),
          startTime: pickup['start_time'].toString(),
          endTime: pickup['end_time'].toString(),
          date: pickup['pickup_date'].toString(),
          notes: pickup['note'].toString(),
          weight: pickup['est_weight'].toString(),
          unitId: pickup['unit_id'].toString(),
        ),
      ),
    );
  },
  child: Text('View Details',
    style: TextStyle(
      color: index == 0 ? Colors.white : Theme.of(context).primaryColor,
    ),
  ),
),

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    appBar: myappbar(context, "Pick Up Details", true),
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                '${formatDate1(widget.scheduleModel.pickupDate)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                '${widget.scheduleModel.startTime} - ${widget.scheduleModel.endTime}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                MyMediumText(title: "Estimate Weight :", isBold: true, color: Colors.black),
                Gap(20),
                MyMediumText(
                  title: "${widget.scheduleModel.totWeight} ${unitName}", // Adjust this line
                  isBold: false,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: MyMediumText(title: "Notes", isBold: true, color: Colors.black),
                ),
              ],
            ),
          ),
          Container(
            height: 150,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: Color(0xffE9E9E9),
              border: Border.all(width: 2, color: Colors.white),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MySmallText(title: "${widget.scheduleModel.notes}"),
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MyEvalutedButton(
                title: "Reschedule",
                onPressed: () {
                  // Handle reschedule action
                },
              ),
              MyEvalutedButton(
                title: "Cancel",
                onPressed: () {
                  // Handle cancel action
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
