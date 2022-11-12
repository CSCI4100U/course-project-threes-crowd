import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'EventsList.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  final formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passController = TextEditingController();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var notificationsPlugin = new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');
  //var initializationSettingsIOS = new IOSInitializationSettings();

  var initializationSettings;
  var platformChannelInfo;
  
  var androidPlatformChannelInfo = AndroidNotificationDetails(
    'Events+',
    'Events+ - Notifications',
    channelDescription:'Currently just a welcome, but soon, it\'ll contain scheduled reminders!',
    importance: Importance.max,
    priority: Priority.max,
    ticker: 'ticker'
  );

  Future login() async {
    // todo: role checking?
    var eventID = 7;
    notificationsPlugin.show(
      eventID,
      "Welcome back!",
      "Let's see what you have scheduled.",
      platformChannelInfo
    );

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EventsList()));
  }

  @override
  Widget build(BuildContext context) {
    initializationSettings = new InitializationSettings(android: initializationSettingsAndroid);

    notificationsPlugin.initialize(
      initializationSettings,
    );

    platformChannelInfo = NotificationDetails(
      android: androidPlatformChannelInfo
    );

    return Container(
      padding: const EdgeInsets.all(12.0),
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          const Text(
            "Events+ Login",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
                decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
                hintText: 'Enter your E-mail or sth'
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter your password'
              ),
            ),
          ),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(8)),
            child: TextButton(
              onPressed: login,
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          ),
          /*
          Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Username",
                  ),
                  controller: widget.userController,
                ),
                TextField(
                  // todo: look into options to change dot size?
                  // might be a bit small currently
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                  ),
                  controller: widget.passController,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: login,
                    child: const Text("Login"),
                  ),
                ),
              ],
            ),
          )*/
        ],
      ),
    );
  }
}
