initial() async {
  rateItemModel = await GlobalHelper().getRateCards();
  
  // Filter rate items based on categoryId
  if (rateItemModel != null) {
    rateItemModel = rateItemModel!.where((item) => item.categoryId == widget.categoryId).toList();
  }
  
  setState(() {});
}class RateItemModel {
  // ... existing properties ...
  String? categoryId; // Add this property

  RateItemModel.fromJson(Map<String, dynamic> json) {
    // ... existing parsing logic ...
    categoryId = json['category_id']; // Adjust according to your API response
  }
}




class RateCard extends StatefulWidget {
  final String categoryId; // Add categoryId parameter

  RateCard({Key? key, required this.categoryId}) : super(key: key);

  @override
  State<RateCard> createState() => _RateCardState();
}

class _RateCardState extends State<RateCard> {
  List<RateItemModel>? rateItemModel;

  initial() async {
    rateItemModel = await GlobalHelper().getRateCards();
    
    // Filter rate items based on categoryId
    if (rateItemModel != null) {
      rateItemModel = rateItemModel!.where((item) => item.categoryId == widget.categoryId).toList();
    }
    
    setState(() {});
  }
}
