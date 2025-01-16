@override
void initState() {
  super.initState();
  initial();
  print('Testing');

  // Initialize SelectedItems based on existingScheduleMap
  if (widget.existingScheduleMap['schedule_items'] != null) {
    for (var item in widget.existingScheduleMap['schedule_items']) {
      RateItemModel? foundItem = rateItemModel?.firstWhere(
        (rateItem) => rateItem.rateItemsName == item['product_name'],
        orElse: () => null,
      );
      if (foundItem != null) {
        SelectedItems.add(foundItem);
      }
    }
  }
}


@override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 2 / 3,
      ),
      itemCount: widget.rateItemModel.length,
      itemBuilder: (context, index) {
        bool isSelected = widget.selectedlist.contains(widget.rateItemModel[index]);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                widget.selectedlist.remove(widget.rateItemModel[index]);
              } else {
                widget.selectedlist.add(widget.rateItemModel[index]);
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: widget.rateItemModel[index].rateItemsImage == null
                      ? Container(color: Colors.white)
                      : Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage('${widget.rateItemModel[index].rateItemsImage}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SizedBox(
                          height: 40,
                          child: Text(
                            widget.rateItemModel[index].rateItemsName ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              widget.selectedlist.remove(widget.rateItemModel[index]);
                            } else {
                              widget.selectedlist.add(widget.rateItemModel[index]);
                            }
                          });
                        },
                        child: isSelected
                            ? Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              )
                            : Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
