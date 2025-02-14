void incrementQuantity(int index) {
  if (mounted) {
    int currentQty = quantityControllers[index].text.isEmpty ? 0 : int.parse(quantityControllers[index].text);
    setState(() {
      quantityControllers[index].text = (currentQty + 1).toString();
      handleQuantityChange(index, quantityControllers[index].text);
    });
  }
}

void decrementQuantity(int index) {
  if (mounted) {
    int currentQty = quantityControllers[index].text.isEmpty ? 0 : int.parse(quantityControllers[index].text);
    if (currentQty > 0) {
      setState(() {
        quantityControllers[index].text = (currentQty - 1).toString();
        handleQuantityChange(index, quantityControllers[index].text);
      });
    }
  }

  void handleQuantityChange(int index, String value) {
  if (mounted) {
    setState(() {
      if (value.isNotEmpty) {
        double unitPrice = double.parse(inputDependentList[index]['unit_price']); // Use inputDependentList
        int qty = int.parse(value);
        double totalPrice = unitPrice * qty;
        itemCardTotals[index] = totalPrice.toStringAsFixed(2);
      } else {
        itemCardTotals[index] = '0';
      }
    });
  }
}

  setState(() {
  if (newProducts.length < 100) {
    hasMore = false;
  }
  currentPage++;
  listData = [];
  listData.addAll(newProducts);
  inputDependentList = listData;

  // Initialize quantityControllers and itemCardTotals based on the new list
  quantityControllers = List.generate(newProducts.length, (index) => TextEditingController());
  itemCardTotals = List.generate(newProducts.length, (index) => '0');
});



  void updateFilterList() {
  if (mounted) {
    setState(() {
      if (searchVal.isEmpty && brandVal.isEmpty && formatVal.isEmpty && variantVal.isEmpty) {
        // Reset quantities and totals when all filters are cleared
        for (int i = 0; i < quantityControllers.length; i++) {
          quantityControllers[i].clear(); // Clear the quantity controllers
          itemCardTotals[i] = '0'; // Reset total price
        }
        inputDependentList = newList; // Reset the input dependent list
      } else {
        // Filtering logic
        inputDependentList = newList.where((element) {
          // Apply your filtering conditions here
          bool matchesSearch = element['name'].toString().toLowerCase().contains(searchVal.toLowerCase());
          bool matchesBrand = element['brand_name'].toString().toLowerCase().startsWith(brandVal.toLowerCase());
          bool matchesFormat = element['format_name'].toString().toLowerCase().startsWith(formatVal.toLowerCase());
          bool matchesVariant = element['variant_name'].toString().toLowerCase().contains(variantVal.toLowerCase());
          return matchesSearch && matchesBrand && matchesFormat && matchesVariant;
        }).toList();
      }
    });
  }
}
