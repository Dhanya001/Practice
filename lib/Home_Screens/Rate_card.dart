class _RateCardState extends State<RateCard> {
  int _currentIndex = 0;
  final TextEditingController _searchcontroller = TextEditingController();
  List<RateItemModel> _searchitems = [];
  bool isSearchClicked = false;
  List<RateItemModel>? rateItemModel;
  bool noItemsInCategory = false; // New variable to track no items

  initial() async {
    rateItemModel = await GlobalHelper().getRateCards();
    if (rateItemModel != null) {
      if (widget.categoryId != null) {
        rateItemModel = rateItemModel!.where((item) =>
            item.categoryId.toString() == widget.categoryId.toString()).toList();
        // Check if the filtered list is empty
        noItemsInCategory = rateItemModel!.isEmpty;
      } else {
        rateItemModel = await GlobalHelper().getRateCards();
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: isSearchClicked
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextFormField(
                  controller: _searchcontroller,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    border: InputBorder.none,
                    hintText: "Search",
                  ),
                  onChanged: (value) => _runFilter(value),
                ),
              )
            : const Text(
                "Rate Card",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearchClicked = !isSearchClicked;
                  if (!isSearchClicked) {
                    _searchcontroller.clear();
                  }
                });
              },
              icon: Icon(isSearchClicked ? Icons.close : Icons.search_sharp))
        ],
      ),
      body: _searchcontroller.text == ''
          ? noItemsInCategory // Check if there are no items in the category
              ? Center(
                  child: const Text(
                    "No items in this category!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : rateItemModel == null
                  ? Container()
                  : customgridview(rateItemModel!)
          : _searchitems.isEmpty
              ? Container(
                  child: const Center(
                      child: Text(
                    "No result Found",
                    style: TextStyle(color: Colors.black),
                  )),
                )
              : customgridview(_searchitems),
    );
  }
}
