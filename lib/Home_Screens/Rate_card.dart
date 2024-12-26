body: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white),
                  shape: BoxShape.circle,
                ),
                child: userProfile!.userPic != null
                    ? ClipOval(
                        child: Image.network(
                          '${userProfile!.userPic}',
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey,
                      ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyExtraSmallText(
                      title: greeting(),
                      color: Colors.white,
                    ),
                    MyMediumText(
                      title: userProfile!.uname ?? '',
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateProfile()),
                  );
                },
                icon: Image.asset("assets/update.png"),
              ),
            ],
          ),
          SizedBox(height: 20),
          MySmallText(
            title: "Available Balance",
            color: Colors.white,
          ),
          MyMediumText(
            title: "₹ 0",
            color: Colors.white,
          ),
        ],
      ),
    ),
    SizedBox(height: 20),
    Text(
      'My Transactions',
      style: TextStyle(fontSize: 20, color: Colors.black),
    ),
    SizedBox(height: 10),
    Expanded( // Use Expanded to allow the ListView to take the remaining space
      child: customListView(userWalletModel!),
    ),
  ],
),

Widget customListView(List<UserWalletModel> userWalletModel) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: ListView.builder(
      itemCount: userWalletModel.length,
      itemBuilder: (context, index) {
        return transactionDetails(
          context: context,
          userWalletSingleItemModel: userWalletModel[index],
        );
      },
    ),
  );
}

Widget transactionDetails({
  required BuildContext context,
  required UserWalletModel userWalletSingleItemModel,
}) {
  return GestureDetector(
    onTap: () {
      // Handle tap
    },
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Transaction ID: ${userWalletSingleItemModel.userID.toString()}'),
              // Add more details as needed
            ],
          ),
        ),
      ),
    ),
  );
}
