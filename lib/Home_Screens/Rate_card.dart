Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => UpdateProfileScreen(
      studentModel: widget.studentModel,
      std: widget.std,
      studentId: widget.studentId,
    ),
  ),
).then((updatedData) {
  if (updatedData != null) {
    setState(() {
      // Assuming updatedData is a Map<String, dynamic>
      widget.studentModel = StudentModel.fromJson(updatedData);
    });
  }
});

if (response['success'] == true) {
  var studentUpdatedData =
      await GlobalHelper().getStudentInfo(context, widget.studentId!);
  
  // Pass the updated data back to the ProfileScreen
  Navigator.pop(context, studentUpdatedData);
}

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => UpdateProfileScreen(
      studentModel: widget.studentModel,
      std: widget.std,
      studentId: widget.studentId,
    ),
  ),
).then((updatedData) {
  if (updatedData != null) {
    setState(() {
      // Update the studentModel with the new data
      widget.studentModel = updatedData;
    });
  }
});

// In ProfileScreen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => UpdateProfileScreen(
      studentModel: widget.studentModel,
      std: widget.std,
      studentId: widget.studentId,
    ),
  ),
).then((updatedData) {
  if (updatedData != null) {
    setState(() {
      widget.studentModel = updatedData; // Update the model with new data
    });
  }
});

// In UpdateProfileScreen
if (response['success'] == true) {
  var studentUpdatedData =
      await GlobalHelper().getStudentInfo(context, widget.studentId!);
  Navigator.pop(context, studentUpdatedData); // Pass updated data back
}
