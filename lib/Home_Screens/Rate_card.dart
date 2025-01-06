void _onDaySelected(DateTime selectedDate, DateTime focusedDay) async {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);

  if (selectedDate.isBefore(today)) {
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
      _isLoading = true;
    });

    // Fetch time slots only if the selected date is different from the focused day
    if (!isSameDay(selectedDate, focusedDay)) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
      var timeslotData = await GlobalHelper().getTimeslot(formattedDate);
      setState(() {
        _fetchedTimeSlots = timeslotData;
        _isLoading = false;
      });
    }
  }
}


GestureDetector(
  onTap: () {
    FocusScope.of(context).unfocus(); // Dismiss the keyboard
  },
  child: Container(
    margin: const EdgeInsets.only(left: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(width: 2, color: Colors.grey),
    ),
    child: TextFormField(
      controller: weightController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        border: InputBorder.none,
        hintText: "Enter Estimate Weight",
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
      ],
      onChanged: _onWeightChanged,
    ),
  ),
)
