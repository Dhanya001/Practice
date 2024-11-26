void _handleSaveAction(int index) async {
  var sharedPref = await SharedPreferences.getInstance();
  var company_id = sharedPref.getInt('company_id');

  if (quantityControllers[index] != '0' &&
      itemCardTotals[index] != '0' &&
      itemCardTotals[index] != '0.00') {
    // ... (existing code)

    // Save cart item count to SharedPreferences
    int cartItemCount = sharedPref.getInt('cartItemCount') ?? 0;
    cartItemCount++;
    await sharedPref.setInt('cartItemCount', cartItemCount);

    // Update state
    setState(() {
      widget.cartItemCount = cartItemCount;
    });

    // ... (existing code)
  }
}


@override
void initState() {
  super.initState();
  _loadCartItemCount();
  // ... (existing code)
}

Future<void> _loadCartItemCount() async {
  var sharedPref = await SharedPreferences.getInstance();
  int cartItemCount = sharedPref.getInt('cartItemCount') ?? 0;

  setState(() {
    widget.cartItemCount = cartItemCount;
  });
}


--------------------------------

Future<void> initializeData() async {
  try {
    final response = await globalHelper.view_order(widget.orderId, widget.outletId);
    if (mounted) {
      setState(() {
        order = List<Map<String, dynamic>>.from(response['order']);
        total = response['total_sum'].toStringAsFixed(2);
        taxTotal = response['gst_amount_sum'].toStringAsFixed(2);
        grossTotal = (response['total_sum'] + response['gst_amount_sum']).round();

        // Set cart item count based on existing order items
        if (order.isNotEmpty) {
          var orderItems = order[0]['purchaseorder_items'] ?? [];
          widget.cartItemCount = orderItems.length; // Initialize cart item count
        }
      });
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    await Future.delayed(Duration(seconds: constants.delayedTime));
  }
}


void _handleSaveAction(int index) async {
  var sharedPref = await SharedPreferences.getInstance();
  var company_id = sharedPref.getInt('company_id');

  if (quantityControllers[index] != '0' &&
      itemCardTotals[index] != '0' &&
      itemCardTotals[index] != '0.00') {
    // ... (existing code)

    // Save cart item count to SharedPreferences
    int cartItemCount = sharedPref.getInt('cartItemCount') ?? 0;
    cartItemCount++;
    await sharedPref.setInt('cartItemCount', cartItemCount);

    // Update state
    setState(() {
      widget.cartItemCount = cartItemCount;
    });

    // Notify OrderBookingEditPage to update its count
    Navigator.of(context).pop(cartItemCount); // Pass the updated count back
  }
}


void _navigateToEditPage() async {
  final updatedCount = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => OrderBookingEditPage(
        outletId: widget.outletId,
        orderId: widget.orderId,
        cartItemCount: widget.cartItemCount,
      ),
    ),
  );

  if (updatedCount != null) {
    setState(() {
      widget.cartItemCount = updatedCount; // Update the cart item count
    });
  }
}

---------------------------------------
Padding(
  padding: const EdgeInsets.all(8.0),
  child: customElevatedButton(
    () async {
      // Save functionality
      showDialog(
        context: context,
        builder: (BuildContext context) => Center(child: CircularProgressIndicator()),
      );

      // Assuming you have a method to save the order
      final res = await globalHelper.save_order(widget.orderId);

      if (res['error'] != null) {
        constants.Notification(res['error']);
        Navigator.pop(context);
      } else if (res['success'] != null) {
        constants.Notification(res['success']);
        
        // Decrement the cart item count by the number of items in the order
        var sharedPref = await SharedPreferences.getInstance();
        int cartItemCount = sharedPref.getInt('cartItemCount') ?? 0;
        
        // Assuming you want to decrement by the number of items in the current order
        int itemsInOrder = order.isNotEmpty ? order[0]['purchaseorder_items'].length : 0;
        
        cartItemCount -= itemsInOrder; // Decrement the cart item count
        await sharedPref.setInt('cartItemCount', cartItemCount); // Save the updated count

        // Update the widget cart item count if needed
        setState(() {
          widget.cartItemCount = cartItemCount;
        });

        Navigator.pop(context); // Navigate back
      }
    },
    'Save Order',
  ),
),


class OrderBookingEditPage extends StatefulWidget {
  final int orderId;
  final int outletId;
  int cartItemCount; // Make mutable

  const OrderBookingEditPage({
    Key? key,
    required this.orderId,
    required this.outletId,
    this.cartItemCount = 0,
  }) : super(key: key);

  @override
  _OrderBookingEditPageState createState() => _OrderBookingEditPageState();
}

class _OrderBookingEditPageState extends State<OrderBookingEditPage> {
  // ... (existing code)

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    try {
      final response = await globalHelper.view_order(widget.orderId, widget.outletId);
      if (mounted) {
        setState(() {
          order = List<Map<String, dynamic>>.from(response['order']);
          total = response['total_sum'].toStringAsFixed(2);
          taxTotal = response['gst_amount_sum'].toStringAsFixed(2);
          grossTotal = (response['total_sum'] + response['gst_amount_sum']).round();
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constants.scaffoldColor,
      appBar: appbar('Update Order Booking'),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: customElevatedButton(
              () async {
                // Save functionality
                showDialog(
                  context: context,
                  builder: (BuildContext context) => Center(child: CircularProgressIndicator()),
                );

                // Assuming you have a method to save the order
                final res = await globalHelper.save_order(widget.orderId);

                if (res['error'] != null) {
                  constants.Notification(res['error']);
                  Navigator.pop(context);
                } else if (res['success'] != null) {
                  constants.Notification(res['success']);
                  
                  // Decrement the cart item count by the number of items in the order
                  var sharedPref = await SharedPreferences.getInstance();
                  int cartItemCount = sharedPref.getInt('cartItemCount') ?? 0;
                  
                  // Assuming you want to decrement by the number of items in the current order
                  int itemsInOrder = order.isNotEmpty ? order[0]['purchaseorder_items'].length : 0;
                  
                  cartItemCount -= itemsInOrder; // Decrement the cart item count
                  await sharedPref.setInt('cartItemCount', cartItemCount); // Save the updated count

                  // Update the widget cart item count if needed
                  setState(() {
                    widget.cartItemCount = cartItemCount;
                  });

                  Navigator.pop(context); // Navigate back
                }
              },
              'Save Order',
            ),
          ),
          // Other UI elements for displaying order details
        ],
      ),
    );
  }
}
