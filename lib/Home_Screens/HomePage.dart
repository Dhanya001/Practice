backup file constant

void showCancelRemarkDialog(
    BuildContext context,
    String title,
    // String message,
    {Icon? icon, Function? onConfirm}
    ) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Container(
          margin: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xffE9E9E9),
            border: Border.all(width: 2, color: Colors.white),
            borderRadius: BorderRadius.circular(16)
          ),
          child: TextFormField(
            autofocus: true,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  vertical: 10, horizontal: 20),
              hintText: "Enter Remark",
              border: InputBorder.none,
            ),
            maxLines: 2,
          ),
        ),
        // content: Text(message),
        actions: [
          Container(
            color: primaryColor,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onConfirm != null) {
                  onConfirm();
                }
              },
              child: Text('Yes',style: TextStyle(color: Colors.white),),
            ),
          ),
          Container(
            color: Colors.red,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No',style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    },
  );
}


MyEvalutedButton(
                  title: "Cancel",
                  onPressed: () async{
                    constants.showCancelRemarkDialog(
                        context,
                        'Schedule cancel','are you sure',
                        remarkController: TextEditingController(),
                        onConfirm:() async {
                          print(TextEditingController());
                          constants.showLoading(context);
                          try {

                            var response = await GlobalHelper().cancelSchedule(
                                widget.scheduleMap['schedules_id'].toString());
                            if (response['success'] == true) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MyPickUp(),));
                            } else {
                              print('Failed to cancel schedule pickup');
                            }
                          } catch (e) {
                            print('Error cancel scheduling pickup: $e');
                          }
                        }
                    );
                  },
                ),
