@override
Widget build(BuildContext context) {
  // Determine the effective communication ID
  String effectiveCommunicationId = (widget.communicationId.isEmpty || widget.communicationId == null)
      ? payload['communication_id']
      : widget.communicationId;

  if (effectiveCommunicationId.isEmpty) {
    final data = ModalRoute.of(context)!.settings.arguments;
    if (data is RemoteMessage) {
      payload = data.data;
    }
    if (data is NotificationResponse) {
      payload = jsonDecode(data.payload!);
    }
    print('yes');
    print(payload);
    print(payload['communication_id']);
    if (studentId != null) {
      GlobalHelper().isRead(studentId!, otherNotificationId: payload['communication_id']);
    }
  }

  return GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: Scaffold(
      backgroundColor: constants.backgroundColor,
      appBar: appbar(context, 'Communication', 'Parent Communication',
          widgetList: [
            closedChat == '1' ? Container() : PopupMenuButton(
              iconColor: Colors.white,
              color: Colors.white,
              itemBuilder: (context) => [
                PopupMenuItem(child: InkWell(onTap: () {
                  if (widget.closeChat != '1') {
                    GlobalHelper().closeChat(widget.communicationId);
                    setState(() {
                      closedChat = '1';
                    });
                  } else {
                    constants.showCustomSnackBar(context, 'Already chat is Closed ', color: Colors.black);
                  }
                  Navigator.pop(context);
                  Navigator.pop(context, 'isClosed');
                }, child: Text('Close Chat'))),
              ],
            ),
            Gap(15),
          ]
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            Container(),
            Padding(
              padding: EdgeInsets.only(bottom: redboxSize == null ? 20 : redboxSize!.height),
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification) {
                    print(_scrollController.position.pixels);
                  }
                  return true;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: conversationsModel.length,
                  itemBuilder: (context, index) {
                    return ByPatent(
                      conversationsModel[index].createdAt,
                      conversationsModel[index].sendBy,
                      conversationsModel[index].message,
                    );
                  },
                ),
              ),
            ),
            Positioned(
              right: 5,
              left: 5,
              bottom: 5,
              child: closedChat == '1'
                  ? Container(
                      key: key,
                      child: const Center(child: Text('This chat Closed')))
                  : Container(
                      key: key,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: constants.hexColorBgRecipientMsgAndMsgField,
                          border: Border.all()),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  setState(() {
                                    redboxSize = getRedBoxSize(key.currentContext!);
                                  });
                                });
                              },
                              maxLines: 6,
                              minLines: 1,
                              controller: replyController,
                              focusNode: msgFocus,
                              style: const TextStyle(),
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                isDense: true,
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                hintText: 'Enter Message',
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  GlobalHelper().parentViewAllMsg(effectiveCommunicationId);
                                  bool isInternet = await ConnectivityWrapper.instance.isConnected;
                                  if (isInternet) {
                                    if (replyController.text != '') {
                                      GlobalHelper().parentReply(
                                        widget.standardId,
                                        effectiveCommunicationId,
                                        replyController.text,
                                      );

                                      Future.delayed(const Duration(seconds: 1), () {
                                        parentCommunication();
                                        replyController.clear();
                                      });
                                    }
                                  } else {
                                    constants.showCustomSnackBarOffline(context);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.all(6),
                                  margin: const EdgeInsets.only(right: 10, bottom: 9),
                                  child: const Icon(
                                    size: 20,
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))
          ],
        ),
      ),
    ),
  );
} ```dart
}
