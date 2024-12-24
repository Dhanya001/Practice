class EditAddressPage extends StatefulWidget {
  final Address? address;
  final Function(Address) onSave;

  EditAddressPage({this.address, required this.onSave});

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  late TextEditingController titleController;
  late TextEditingController addressLine1Controller;
  late TextEditingController addressLine2Controller;
  late TextEditingController pinCodeController;
  String? selectedCity;
  List<String> cities = ['Kalyan', 'Mumbai', 'Dombivli'];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.address?.title);
    addressLine1Controller = TextEditingController(text: widget.address?.addressLine1);
    addressLine2Controller = TextEditingController(text: widget.address?.addressLine2);
    pinCodeController = TextEditingController(text: widget.address?.pinCode);
    // Uncomment to fetch cities from API
    // initial();
  }

  void saveAddress() {
    final newAddress = Address(
      title: titleController.text,
      addressLine1: addressLine1Controller.text,
      addressLine2: addressLine2Controller.text,
      city: selectedCity ?? 'Unknown',
      pinCode: pinCodeController.text,
    );
    widget.onSave(newAddress);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Radio buttons for Title
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Home'),
                    value: 'Home',
                    groupValue: titleController.text,
                    onChanged: (value) {
                      setState(() {
                        titleController.text = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Work'),
                    value: 'Work',
                    groupValue: titleController.text,
                    onChanged: (value) {
                      setState(() {
                        titleController.text = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Gap(10),
            TextField(
              controller: addressLine1Controller,
              decoration: InputDecoration(
                labelText: 'Address Line 1',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(),
              ),
            ),
            Gap(10),
            TextField(
              controller: addressLine2Controller,
              decoration: InputDecoration(
                labelText: 'Address Line 2',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(),
              ),
            ),
            Gap(10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(),
              ),
              value: selectedCity,
              hint: Text('Select City'),
              items: cities.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCity = newValue;
                  // Optionally fetch pin code based on selected city
                });
              },
 },
            ),
            Gap(10),
            TextField(
              controller: pinCodeController,
              decoration: InputDecoration(
                labelText: 'Pin Code',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              enabled: selectedCity != null, // Disable if no city is selected
            ),
            SizedBox(height: 30),
            MyTextButton(
              title: widget.address == null ? '  Add Address  ' : '  Update Address  ',
              onPressed: () {
                saveAddress();
              },
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
