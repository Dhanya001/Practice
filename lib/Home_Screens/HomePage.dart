void showCancelRemarkDialog(
  BuildContext context,
  String title, {
  Icon? icon,
  Function? onConfirm,
  TextEditingController? remarkController, // Add this parameter
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xffE9E9E9),
            border: Border.all(width: 2, color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            controller: remarkController, // Set the controller here
            autofocus: true,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              hintText: "Enter Remark",
              border: InputBorder.none,
            ),
            maxLines: 2,
          ),
        ),
        actions: [
          Container(
            color: primaryColor,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onConfirm != null && remarkController != null) {
                  onConfirm(remarkController.text); // Pass the entered remark
                }
              },
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            color: Colors.red,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    },
  );
}
MyEvalutedButton(
  title: "Cancel",
  onPressed: () async {
    TextEditingController remarkController = TextEditingController(); // Initialize the controller

    constants.showCancelRemarkDialog(
      context,
      'Schedule cancel',
      remarkController: remarkController, // Pass the controller
      onConfirm: (remark) async { // This is where the entered remark is accessed
        print("Entered Remark: $remark"); // Print the remark

        constants.showLoading(context);
        try {
          var response = await GlobalHelper().cancelSchedule(
            widget.scheduleMap['schedules_id'].toString(),
          );
          if (response['success'] == true) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyPickUp()));
          } else {
            print('Failed to cancel schedule pickup');
          }
        } catch (e) {
          print('Error cancel scheduling pickup: $e');
        }
      },
    );
  },
)
