import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'EventsList.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  final formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passController = TextEditingController();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  final initializationSettingsAndroid =
      const AndroidInitializationSettings('mipmap/ic_launcher');
  //var initializationSettingsIOS = new IOSInitializationSettings();

  InitializationSettings? initializationSettings;
  NotificationDetails? platformChannelInfo;

  Future login(BuildContext context) async {
    // todo: role checking?
    int eventID = 7;
    notificationsPlugin.show(eventID, AppLocalizations.of(context)!.welcome,
        AppLocalizations.of(context)!.schedule, platformChannelInfo);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EventsList()));
  }

  @override
  Widget build(BuildContext context) {
    AndroidNotificationDetails androidPlatformChannelInfo =
        AndroidNotificationDetails(AppLocalizations.of(context)!.title,
            '${AppLocalizations.of(context)!.title} - ${AppLocalizations.of(context)!.notifications}',
            channelDescription: AppLocalizations.of(context)!.channelDesc,
            importance: Importance.max,
            priority: Priority.max,
            ticker: 'ticker');

    initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    notificationsPlugin.initialize(
      initializationSettings!,
    );

    platformChannelInfo =
        NotificationDetails(android: androidPlatformChannelInfo);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.appLogin,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.userName,
                    hintText: AppLocalizations.of(context)!.enterUser),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.password,
                  hintText: AppLocalizations.of(context)!.enterPass,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                print('register');
              },
              style: TextButton.styleFrom(
                primary: Colors.black,
                textStyle: const TextStyle(
                  fontSize: 20,
                ),
              ),
              child: Text(AppLocalizations.of(context)!.register),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(8)),
              child: TextButton(
                onPressed: () => login(context),
                child: Text(
                  AppLocalizations.of(context)!.login,
                  style: const TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  showAbout(context);
                },
                child: Text(AppLocalizations.of(context)!.about),
              ),
            ),
            /*
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: ElevatedButton(
                onPressed: (){
                  showAbout(context);
                },
                child: Text("About"),
              ),
          )*/
          ],
        ),
      ),
    );
  }

  showAbout(context) {
    showAboutDialog(
        context: context,
        applicationName: AppLocalizations.of(context)!.title,
        applicationVersion: "1.0",
        applicationLegalese: "xxx",
        children: [
          Text(AppLocalizations.of(context)!.appDesc),
        ]);
  }
}
