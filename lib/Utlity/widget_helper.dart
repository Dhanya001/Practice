List<Map<String, String>> _fetchedTimeSlots = [];
bool _isLoading = false;


void _onDaySelected(DateTime selectedDate, DateTime focusedDay) async {
  if (selectedDate.isBefore(DateTime.now())) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const MySmallText(title: "Invalid Date"),
          content: const MySmallText(
              title: "Please select today's date or a future date."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else {
    setState(() {
      _focusedDay = selectedDate;
      _selectedDate = selectedDate;
      _isLoading = true; // Start loading
    });

    // Fetch time slots from the API
    String formattedDate = DateFormat('MM-dd-yyyy').format(selectedDate);
    var timeslotData = await GlobalHelper().getTimeslot(formattedDate);
    
    setState(() {
      _fetchedTimeSlots = timeslotData; // Update the fetched time slots
      _isLoading = false; // Stop loading
    });
  }
}


Column(
  children: _isLoading
      ? [CircularProgressIndicator()] // Show loading indicator
      : List.generate(_fetchedTimeSlots.length, (index) {
          return Column(
            children: [
              Container(
                color: Colors.white,
                child: RadioListTile<int?>(
                  dense: true,
                  value: index,
                  groupValue: _selectedslot,
                  onChanged: (value) {
                    setState(() {
                      _selectedslot = value;
                    });
                  },
                  title: Text(
                    "${_fetchedTimeSlots[index]['start_time']} - ${_fetchedTimeSlots[index]['end_time']}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  activeColor: Theme.of(context).primaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
              ),
              const Gap(10),
            ],
          );
        }),
},


Future<List<Map<String, String>>> getTimeslot(String date) async {
  try {
    var response = await http.get(Uri.parse(
      '${constants.apiLocalName}/getSchedule?date=$date',
    ));
    log(response.body);
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var timeslotData = responseData['slots_data'] as List;
      return timeslotData.map((slot) {
        return {
          'start_time': slot['start_time'],
          'end_time': slot['end_time'],
        };
      }).toList();
    } else {
      throw Exception('Failed to Fetch Time slot: ${response.statusCode}');
    }
  } on Exception catch (e) {
    print('Error during Fetch Time slot: $e');
    rethrow;
  }
}
