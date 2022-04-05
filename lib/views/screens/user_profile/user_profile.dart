import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:squadchat/colors.dart';
import 'package:squadchat/composition_root.dart';
import 'package:squadchat/data/factories/db_factory.dart';
import 'package:squadchat/theme.dart';
import 'package:squadchat/views/screens/intro/intro.dart';
import 'package:squadchat/views/widgets/chat_home/user_online_indicator.dart';
import 'package:squadchat/views/widgets/common/custom_confirmation_dialog.dart';
import 'package:squadchat/views/widgets/login/logo.dart';
import 'package:squadchat/models/user_data.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  User _user;
  String photoUrl;
  List<UserData> userDetails;
  UserService userService;
  LocalDatabase _localDatabase;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            userDetails == null || photoUrl == null
                ? const Center(
                    child: Text('Loading...'),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back,
                              color: primary,
                              size: 30,
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  scale: 5,
                                ),
                              ),
                              Text(
                                "Squadchat",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isLightTheme(context)
                                            ? Colors.black
                                            : Colors.white),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.logout_rounded,
                            color: primary,
                            size: 30,
                          ),
                        ]),
                  ),
            const Spacer(flex: 2),
            SizedBox(
              height: 126,
              width: 126,
              child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(126),
                          child: Image.network(photoUrl,
                              width: 126, height: 126, fit: BoxFit.cover)),
                      const Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: UserOnlineIndicator(),
                          ))
                    ],
                  )),
            ),
            const Spacer(flex: 1),
            userDetails == null || photoUrl == null
                ? const Center(
                    child: Text('Loading...'),
                  )
                : Flexible(
                    flex: 8,
                    child: ListView.builder(
                        itemCount: userDetails.length,
                        itemBuilder: (context, index) {
                          UserData item = userDetails.elementAt(index);

                          return ListTile(
                            title: Text(
                              item.dataAttribute,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      color: isLightTheme(context)
                                          ? Colors.black
                                          : Colors.white),
                            ),
                            trailing: Text(
                              item.value,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                      color: isLightTheme(context)
                                          ? Colors.black
                                          : Colors.white),
                            ),
                          );
                        }),
                  ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  var alert = CustomConfirmationDialog(
                    title: 'Delete Account',
                    content: 'Do you want to delete your account ?',
                    okFunction: _confirmationOk,
                  );

                  showDialog(
                      context: context,
                      builder: (BuildContext context) => alert);
                },
                child: const Icon(Icons.delete_forever),
                style: ElevatedButton.styleFrom(
                    primary: primary,
                    fixedSize: const Size(60, 60),
                    shape: const CircleBorder(),
                    elevation: 0),
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  Widget _logo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Logo(),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          'Squadchat',
          style: Theme.of(context).textTheme.headline4.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  _confirmationOk() async {
    await CompositionRoot.deleteUser();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Intro()));
  }

  void _fetchUser() async {
    _user = await CompositionRoot.fetchUser();

    setState(() {
      userDetails = [
        UserData(dataAttribute: "Username", value: _user.username),
        UserData(
          dataAttribute: "Active Status",
          value: _user.active ? "Active" : "Inactive",
        ),
        UserData(
            dataAttribute: "Last Seen",
            value: DateFormat.yMd().add_jm().format(DateTime.now())),
      ];
      photoUrl = _user.photoUrl;
    });
  }
}
