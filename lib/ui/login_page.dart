import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './user_page.dart';

// typedef void BoolCallback(bool login);

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  // final BoolCallback onSuccessfulLogin;
  // LoginPage({required this.onSuccessfulLogin});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController useridController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var msg1 = '', msg2 = '', msg3 = '';
  final String usernameValidationErrorMsg =
      'Your username must be atleast 3 and atmost 11 characters long.';

  final String passwordValidationErrorMsg =
      'Your password must be atleast 3 and atmost 11 characters long.';

  bool _isLoggedIn = false;
  bool usernameValidation = false;
  bool passwordValidation = false;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadLoginDetail();
  }

  //Loading counter value on start
  void _loadLoginDetail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = (prefs.getBool('isLoggedIn') ?? false);
      _username = (prefs.getString('username') ?? '');
    });
  }

  //Incrementing counter after click
  void _loginSuccessful() async {
    int a = 2;
    int b = 3;

    List<List<String>> loginCredentialsList = List.generate(
        a, (i) => List.filled(b, '', growable: false),
        growable: false);

    loginCredentialsList[0] = ['9898989898', 'password123', 'user1'];
    loginCredentialsList[1] = ['9876543210', 'password123', 'user2'];
    print(loginCredentialsList);

    loginCredentialsList.forEach((user) {
      if (useridController.text == user[0] &&
          passwordController.text == user[1]) {
        setState(() {
          _username = user[2];
        });
      }
    });
    if (_username.length > 0) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _isLoggedIn = true;
        prefs.setBool('isLoggedIn', _isLoggedIn);
        prefs.setString('username', _username);
        this.msg3 = '';
        // widget.onSuccessfulLogin(_isLoggedIn);
      });
    } else {
      setState(() {
        this.msg3 = 'Wrong username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn == true) {
      return UserPage(_username);
    }
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: height * 0.1,
              horizontal: width * 0.15,
            ),
            child: Container(
              child: CircleAvatar(
                backgroundImage: AssetImage('logo.png'),
                // backgroundImage: NetworkImage(imageUrl),
                backgroundColor: Colors.white,
                radius: width * 0.2,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: height * 0.01,
              horizontal: width * 0.15,
            ),
            child: TextFormField(
              toolbarOptions: ToolbarOptions(
                copy: true,
                cut: true,
                paste: false,
                selectAll: false,
              ),
              controller: useridController,
              onChanged: (v) {
                useridController.text = v;
                useridController.selection =
                    TextSelection(baseOffset: v.length, extentOffset: v.length);

                if (v.length >= 3 && v.length <= 11) {
                  if (this.msg1 != '') {
                    setState(() {
                      this.msg1 = '';
                      this.usernameValidation = true;
                    });
                  }
                } else if (this.msg1 != usernameValidationErrorMsg) {
                  setState(() {
                    this.msg1 = usernameValidationErrorMsg;
                    this.usernameValidation = false;
                  });
                }
              },
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'Enter your username',
                labelText: 'Username',
              ),
            ),
          ),
          Text(
            this.msg1,
            style: TextStyle(
              color: Colors.red,
              fontSize: 10.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: height * 0.01,
              horizontal: width * 0.15,
            ),
            child: TextField(
              toolbarOptions: ToolbarOptions(
                copy: true,
                cut: true,
                paste: false,
                selectAll: false,
              ),
              controller: passwordController,
              onChanged: (v) {
                passwordController.text = v;
                passwordController.selection =
                    TextSelection(baseOffset: v.length, extentOffset: v.length);

                if (v.length >= 3 && v.length <= 11) {
                  if (this.msg2 != '') {
                    setState(() {
                      this.msg2 = '';
                      this.passwordValidation = true;
                    });
                  }
                } else if (this.msg2 != passwordValidationErrorMsg) {
                  setState(() {
                    this.msg2 = passwordValidationErrorMsg;
                    this.passwordValidation = false;
                  });
                }
              },
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.password_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Enter your password',
                  labelText: 'Password'),
            ),
          ),
          Text(
            this.msg2,
            style: TextStyle(
              color: Colors.red,
              fontSize: 10.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: height * 0.01,
              horizontal: width * 0.15,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(88, 36),
                padding: EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.black)),
              ),
              onPressed: (!passwordValidation || !usernameValidation)
                  ? null
                  : _loginSuccessful,
              child: Text("Login"),
            ),
          ),
          Text(
            this.msg3,
            style: TextStyle(
              color: Colors.red,
              fontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }
}
