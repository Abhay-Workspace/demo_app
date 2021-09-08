import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController useridController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextField(
              // Tell your textfield which controller it owns
              controller: useridController,
              // Every single time the text changes in a
              // TextField, this onChanged callback is called
              // and it passes in the value.
              //
              // Set the text of your controller to
              // to the next value.
              onChanged: (v) {
                useridController.text = v;
                useridController.selection =
                    TextSelection(baseOffset: v.length, extentOffset: v.length);
              },
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
          ),
          useridController.text.length >= 3 ? Text('Good') : Text('Bad')
        ],
      ),
    );
  }
}
