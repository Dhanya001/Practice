class _EditAddressPageState extends State<EditAddressPage> {
  late TextEditingController titleController;
  late TextEditingController addressLine1Controller;
  late TextEditingController addressLine2Controller;
  late TextEditingController pinCodeController; // Initialize this controller
  String? selectedCity;
  List<Map<String, String>> cities = []; // Change to a list of maps

  initial() async {
    cities = await GlobalHelper().getLocation();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.address?.title);
    addressLine1Controller = TextEditingController(text: widget.address?.addressLine1);
    addressLine2Controller = TextEditingController(text: widget.address?.addressLine2);
    pinCodeController = TextEditingController(text: widget.address?.pinCode); // Initialize pin code controller
    initial();
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
            // ... other widgets ...
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton(
                  value: selectedCity,
                  dropdownColor: Colors.white,
                  isExpanded: true,
                  hint: Text('Select City'),
                  items: cities.map((e) {
                    return DropdownMenuItem(
                      value: e['city'],
                      child: Text(e['city']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value.toString();
                      // Find the corresponding pin code for the selected city
                      final selectedCityData = cities.firstWhere(
                          (city) => city['city'] == selectedCity,
                          orElse: () => {'pinCode': ''});
                      pinCodeController.text = selectedCityData['pinCode'] ?? '';
                    });
                  },
                ),
              ),
            ),
            // ... other widgets ...
            TextField(
              controller: pinCodeController,
              decoration: InputDecoration(
                  labelText: 'Pin Code',
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              enabled: false, // Keep this disabled if you want it to be auto-filled
            ),
            // ... other widgets ...
          ],
        ),
      ),
    );
  }
}
