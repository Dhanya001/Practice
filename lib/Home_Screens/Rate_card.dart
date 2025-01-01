ListView.builder(
  itemCount: ApiGlbData.parentCommunicationGlbData.length,
  itemBuilder: (context, index) {
    return NotificationTile(
      title: ApiGlbData.parentCommunicationGlbData[index].title,
      dateTime: ApiGlbData.parentCommunicationGlbData[index].createdAt,
      notificationId: ApiGlbData.parentCommunicationGlbData[index].id,
      notificationIdList: perfectCommunicationId,
    );
  },
),
