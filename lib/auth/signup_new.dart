import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  int _cartItemCount = 0;

  int get cartItemCount => _cartItemCount;

  void addItem() {
    _cartItemCount++;
    notifyListeners();
  }

  void removeItem() {
    if (_cartItemCount > 0) {
      _cartItemCount--;
      notifyListeners();
    }
  }

  void setItemCount(int count) {
    _cartItemCount = count;
    notifyListeners();
  }
}



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MyApp(),
    ),
  );
}

import 'package:provider/provider.dart';

// Inside your AddItemList class
void _handleSaveAction(int index) async {
  // ... existing code ...

  if (response['success'] != null) {
    print(response['success']);
    // Update the cart item count
    Provider.of<CartProvider>(context, listen: false).addItem();
    setState(() {
      widget.cartItemCount++;
    });
    Navigator.pop(context);
  }
}

import 'package:provider/provider.dart';

// Inside your OrderBookingEditPage class
void _deleteOrderItem(int itemId) async {
  // ... existing code ...

  if (confirmDelete == true) {
    var res = await globalHelper.delete_order_item(itemId);
    if (res['success'] != null) {
      constants.Notification(res['success']);
      // Update the cart item count
      Provider.of<CartProvider>(context, listen: false).removeItem();
    }
  }
}

@override
Widget build(BuildContext context) {
  final cartCount = Provider.of<CartProvider>(context).cartItemCount;

  return Scaffold(
    appBar: AppBar(
      title: Text('Add Item'),
      actions: [
        Badge(
          badgeContent: Text(cartCount.toString()),
          child: Icon(Icons.shopping_cart),
        ),
      ],
    ),
    // ... rest of your widget tree ...
  );
}
