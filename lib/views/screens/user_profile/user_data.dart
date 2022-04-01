class UserData {
  final String dataAttribute;
  final String value;

  const UserData({this.dataAttribute, this.value});
}

const List<UserData> storeItems = [
  UserData(dataAttribute: "Username", value: "Thiwanka"),
  UserData(
    dataAttribute: "Active Status",
    value: "Active",
  ),
  UserData(dataAttribute: "Last Seen", value: 'Thu Mar 31 2022 09:08'),
];
