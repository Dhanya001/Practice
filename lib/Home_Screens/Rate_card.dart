class _OrderScreenState extends State<OrderScreen> {
  String? selectedpurpose;
  final TextEditingController controller = TextEditingController();
  List productList = [];

  initial() async {
    productList = await GlobalHelper().getProductList();
    setState(() {});
  }

  final List<String> Purpose = [
    'Transportation',
    'Power Generation',
    'Construction and Industrial Equipment',
    'Heating',
    'Agriculture',
    'Marine Applications',
    'Emergency and Military'
  ];

  @override
  void initState() {
    super.initState();
    initial();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightGreen.shade100,
                Colors.blue.shade100,
              ])),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios_new)),
          backgroundColor: Colors.transparent,
          title: Text('Order'),
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Purpose of diesel',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedpurpose,
                hint: Text("Select Purpose"),
                items: Purpose.map((purpose) {
                  return DropdownMenuItem(
                    value: purpose,
                    child: Text(purpose),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedpurpose = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Diesel Quantity: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter quantity',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedpurpose != null && controller.text.isNotEmpty
                      ? () {
                          int quantity = int.parse(controller.text);
                          String productId;

                          // Determine which product ID to use based on quantity
                          if (quantity >= 500) {
                            // Assuming the product ID for Diesel Tank is 360
                            productId = '360'; // Replace with actual ID if different
                          } else {
                            // Assuming the product ID for Diesel Jerrycan is 364
                            productId = '364'; // Replace with actual ID if different
                          }

                          // Navigate to CheckoutScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                singleProductInfo: productList.firstWhere((product) => product['product_id'].toString() == productId),
                                qty: controller.text,
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Order placed successfully!"),
                            ),
                          );
                        }
                      : null,
                  child: Text("Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
