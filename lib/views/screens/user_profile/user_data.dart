class UserData {
  final String dataAttribute;

  const UserData({
    this.dataAttribute,
  });
}

const List<UserData> storeItems = [
  UserData(
    dataAttribute: "Username",
  ),
  UserData(
    dataAttribute: "Active Status",
  ),
  UserData(
    dataAttribute: "Last Seen",
  ),
];
