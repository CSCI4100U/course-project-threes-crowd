import 'package:flutter/material.dart';
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
  Future login() async {
    // todo: role checking?
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EventsList()));
  }

  @override
  Widget build(BuildContext context) {
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
