Widget customListView(List<UserWalletModel> userWalletModel) {
  return ListView.builder(
    itemCount: userWalletModel.length,
    itemBuilder: (context, index) {
      // Get the current UserWalletModel
      UserWalletModel walletModel = userWalletModel[index];
      
      // Check if there are transactions
      if (walletModel.transactions != null && walletModel.transactions!.isNotEmpty) {
        return Column(
          children: walletModel.transactions!.map((transaction) {
            return transactionDetails(
              context: context,
              userWalletSingleItemModel: walletModel,
              transactionModel: transaction,
            );
          }).toList(),
        );
      } else {
        return Container(); // or some placeholder for no transactions
      }
    },
  );
}

Widget transactionDetails({
  required BuildContext context,
  required UserWalletModel userWalletSingleItemModel,
  required TransactionModel transactionModel,
}) {
  return GestureDetector(
    onTap: () {},
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.arrow_downward_outlined),
                  Gap(20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the transaction type
                        Text(transactionModel.transactionType ?? 'Unknown Transaction'),
                        // Display the transaction amount
                        Text('Amount: ₹${transactionModel.finalAmt ?? 0}'),
                      ],
                    ),
                  ),
                  // Display the wallet amount if needed
                  Text('Wallet Amount: ₹${userWalletSingleItemModel.amount ?? 0}'),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
