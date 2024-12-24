// Inside your HomePage class

@override
void initState() {
  super.initState();
  initial();
  checkInternet(); // Call checkInternet to monitor internet connection
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    // ... other parts of your Scaffold
    body: isNetConnected == false
        ? Container()
        : SingleChildScrollView(
            child: Column(
              children: [
                // ... other widgets

                // Category Section
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: MyBigText(title: "Products By Category", isBold: true, color: Colors.black,),
                      ),
                    ),
                    TextButton(onPressed: () {}, child: const MySmallText(title: "See All", isBold: true,))
                  ],
                ),
                
                // Horizontal ListView for Categories
                Container(
                  height: 100, // Set a fixed height for the category list
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) {
                      final category = categoryList[index];
                      return _buildCategoryCard(category['name'], RecycleProduct());
                    },
                  ),
                ),

                // ... other widgets
              ],
            ),
          ),
    // ... other parts of your Scaffold
  );
}

Widget _buildCategoryCard(String category, Widget destination) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
    },
    child: Container(
      width: 80, // Set a fixed width for each category card
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
            child: Text(category[0], style: TextStyle(fontSize: 24)), // Display the first letter of the category
          ),
          const SizedBox(height: 8.0),
          MyExtraSmallText(title: category, isBold: true),
        ],
      ),
    ),
  );
}
