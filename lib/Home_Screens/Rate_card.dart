class _AddressBookPageState extends State<AddressBookPage> {
  // ... existing code ...

  void _deleteAddress(Address address) async {
    // Call your API to delete the address
    var response = await GlobalHelper().deleteAddress(userProfile!.userID.toString(), address.id.toString());
    
    if (response['success'] == true) {
      setState(() {
        addresses.remove(address);
        searchResults.remove(address);
      });
      constant.showCustomSnackBar1(context, "Address deleted successfully");
    } else {
      constant.showCustomSnackBar1(context, "Failed to delete address");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myappbar(context, 'Address Book', true),
      // ... existing code ...
      body: Column(
        children: [
          // ... existing code ...
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final address = searchResults[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey, width: 2))
                    ),
                    child: ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(address.title),
                      subtitle: Text(
                        '${address.addressLine1}, ${address.addressLine2}, ${address.city}, ${address.pinCode}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _navigateToEditAddressPage(address: address),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteAddress(address), // Call delete method
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          MyBottomButton(title: 'Add address', onPressed: (){
            _navigateToEditAddressPage();
          })
        ],
      ),
    );
  }
}
