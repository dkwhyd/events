import 'package:events/shared/authentication.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  String? _userId;
  String? _password;
  String? _email;
  String? _message;

  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  Authentication auth = Authentication();
  String email = 'test@serenitylink.live';
  String password = 'test1234';

  @override
  void initState() {
    // auth.login(email, password).then((value) => value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
              child: Column(
            children: [
              emailInput(),
              passwordInput(),
              mainButton(),
              secondaryButton(),
              validationMessage(),
            ],
          )),
        ),
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: EdgeInsets.only(top: 120),
      child: TextFormField(
        controller: txtEmail,
        onChanged: (text) {
          setState(() {
            _email = text.toString();
          });
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(hintText: 'Email', icon: Icon(Icons.mail)),
        validator: (text) => text!.isEmpty ? 'Email is required' : '',
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: TextFormField(
          controller: txtPassword,
          onChanged: (text) {
            setState(() {
              _password = text.toString();
            });
          },
          keyboardType: TextInputType.emailAddress,
          
          obscureText: true,
          decoration: InputDecoration(
              hintText: 'Password', icon: Icon(Icons.enhanced_encryption)),
          validator: (text) => text!.isEmpty ? 'Password is required' : '',
        ));
  }

  Widget mainButton() {
    String buttonText = _isLogin ? 'Login' : 'Sign up';
    return Padding(
        padding: EdgeInsets.only(top: 40),
        child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 10,
            child: ElevatedButton(
              child: Text(buttonText),
              onPressed: () async {
                auth
                    .login(_email!, _password!)
                    .then((value) => print('uid: $value'));
              },
            )));
  }

  Widget secondaryButton() {
    String buttonText = !_isLogin ? 'Login' : 'Sign up';
    return ElevatedButton(
      child: Text(buttonText),
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
    );
  }

  Widget validationMessage() {
    return Text(
      _message ?? '',
      style: TextStyle(
          fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
    );
  }
}
