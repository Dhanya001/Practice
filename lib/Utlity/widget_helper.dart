import 'package:http/http.dart' as http;

Future<List<RateItemModel>> getRateCards() async {
  var response = await http.get(
    Uri.parse('http://localhost/scrap_app/api/getRateCard'),
  );
  if (response.statusCode == 200) {
    var responseData = jsonDecode(response.body);
    var rateCardData = responseData['ratecards'];
    List<RateItemModel> rateCardList = rateCardData
        .map<RateItemModel>((item) => RateItemModel.from(item))
        .toList();
    return rateCardList;
  } else {
    throw Exception('Failed to load rate cards');
  }
}


@override
void initState() {
  super.initState();
  fetchRateCards();
}

Future<void> fetchRateCards() async {
  try {
    List<RateItemModel> fetchedRateCards = await getRateCards();
    setState(() {
      rateCardItems.clear();
      rateCardItems.addAll(fetchedRateCards.map((item) => {
        'title': item.RateItemsName,
        'price': item.RateItemsPrice,
        'image': item.RateItemsImage,
      }).toList());
      _searchitems = rateCardItems; // Update search items
    });
  } catch (e) {
    print('Error fetching rate cards: $e');
  }
}


Widget _buildRateCardPickUp({required String title, required String price, required String image, required RateItemModel rateItem}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RateCardDetails(
            rateItem: rateItem, // Pass the selected rate item
          ),
        ),
      );
    },
    child: Container(
      // ... existing code ...
    ),
  );
}

class RateCardDetails extends StatelessWidget {
  final RateItemModel rateItem;

  const RateCardDetails({Key? key, required this.rateItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rateItem.RateItemsName ?? "Rate Card Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display the image, title, price, and description
            Image.network(rateItem.RateItemsImage ?? ''),
            Text(rateItem.RateItemsTitle ?? '', style: TextStyle(fontSize: 24)),
            Text(rateItem.RateItemsPrice ?? '', style: TextStyle(fontSize: 20)),
            Text(rateItem.RateItemsDesc ?? '', style: TextStyle(fontSize: 16)),
            // ... other UI elements ...
          ],
        ),
      ),
    );
  }
}
