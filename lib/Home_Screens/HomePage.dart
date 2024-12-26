import 'package:scrapapp/models/TransactionModel.dart';

class UserWalletModel {
  int? id;
  int? userID;
  int? amount;
  List<TransactionModel>? transactions;

  UserWalletModel({
    this.id,
    this.userID,
    this.amount,
    this.transactions,
  });

  UserWalletModel.from(Map<String, dynamic> map)
      : id = map['id'],
        userID = map['user_id'],
        amount = map['amount'],
        transactions = (map['transactions'] as List?)
            ?.map((item) => TransactionModel.from(item))
            .toList();

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'user_id': userID,
      'amount': amount,
      'transactions': transactions?.map((e) => e.toMap()).toList(),
    };
  }
}

class TransactionModel {
  int? transactionId;
  String? transactionType;
  int? previousAmt;
  int? updatedAmt;
  int? finalAmt;
  String? date;

  TransactionModel({
    this.transactionId,
    this.transactionType,
    this.previousAmt,
    this.updatedAmt,
    this.finalAmt,
    this.date,
  });

  TransactionModel.from(Map<String, dynamic> map)
      : transactionId = map['transcation_id'],
        transactionType = map['transaction_type'],
        previousAmt = map['pervious_amt'],
        updatedAmt = map['updated_amt'],
        finalAmt=map['final_amt'],
        date=map['date'];

  Map<String, Object?> toMap() {
    return {
      'transcation_id': transactionId,
      'transaction_type': transactionType,
      'pervious_amt': previousAmt,
      'updated_amt': updatedAmt,
      'final_amt':finalAmt,
      'date':date,
    };
  }
}

Future<List<UserWalletModel>?> getWalletDetails(
    BuildContext context,
    String id
    ) async {
  try {
    var response = await http.get(
      Uri.parse('${constant.apiLocalName}/getWallet?id=$id'),
    );
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var walletData = responseData['wallet'];


      List<UserWalletModel> walletItemList = [
        UserWalletModel.from(walletData)
      ];

      print('API updated user $id wallet');
      print(walletData);
      return walletItemList;
    } else {
      print('API not updated user $id wallet');
      return null;
    }
  } on Exception catch (e) {
    print('error: $e ---');
    constant.showErrorDialog(
      context,
      'Error',
      'We are facing some technical issues !',
      icon: const Icon(
        Icons.error,
        color: Colors.red,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:scrapapp/Utility/global_helper.dart';
import 'package:scrapapp/models/TransactionModel.dart';
import 'package:scrapapp/models/user_Wallet_Model.dart';
import 'package:scrapapp/screens/Profie_Screens/Dashboard.dart';
import 'package:scrapapp/screens/Profie_Screens/UpdateProfile.dart';

class Myprofile extends StatefulWidget {
  // final UserModel? userProfile;
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  String? name;
  String? username;
  String? email;
  String? phone;
  String? userPic;

  List<UserWalletModel>? userWalletModel;
  List<TransactionModel>? transactionModel;
  initial() async {
    userWalletModel = await GlobalHelper()
        .getWalletDetails(context, userProfile!.userID.toString());
    setState(() {});
    print('yo');
    print(userWalletModel!.length);
    print(userWalletModel!.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();

    // print(userProfile!.userEmail);
    // print(userProfile!.uname);
    // print('This is image: ${userProfile!.userPic}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: myappbar(context, "My Profile", true),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     var getWallet = await GlobalHelper()
      //         .getWalletDetails(context, userProfile!.userID.toString());
      //     print('wallet:$getWallet');
      //   },
      // ),
      body: userWalletModel == null
          ? Container()
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
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
                          border:
                          Border.all(width: 2, color: Colors.white),
                          shape: BoxShape.circle,
                        ),
                        child: userProfile!.userPic != null
                            ? ClipOval(
                          child: Image.network(
                            '${userProfile!.userPic}',
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                            loadingBuilder:
                                (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                            errorBuilder:
                                (context, error, stackTrace) {
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
                            MaterialPageRoute(
                                builder: (context) => UpdateProfile()),
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
            Expanded(
              child: customListView(userWalletModel!,transactionModel!),
            ),
          ],
        ),
      ),
    );
  }
}

Widget customListView(List<UserWalletModel> userWalletModel,List<TransactionModel> transactionModel) {
  return ListView.builder(
    itemCount: userWalletModel.length,
    itemBuilder: (context, index) {
      return transactionDetails(
        context: context,
        userWalletSingleItemModel: userWalletModel[index],
        transactionModel: transactionModel[index],
      );
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
                        //getting null error  how to passed transactiontype
                        Text(transactionModel.transactionType.toString()),
                        Text('hello'),
                      ],
                    ),
                  ),
                  Text(userWalletSingleItemModel.amount.toString()),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}

//how to pass transaction type here i want transaction amount also

