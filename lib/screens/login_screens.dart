import 'package:events/screens/launch_screen.dart';
import 'package:events/shared/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool? _isLogin = false;
  String? _userId;
  String? _password;
  String? _email;
  String? _message;

  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  Authentication auth = Authentication();
  @override
  void initState() {
    auth.getUser().then((user) => {
          if (user == null) {_isLogin = false} else {_isLogin = true}
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
              child: Column(
            children: [
              emailInput(),
              passwordInput(),
              validationMessage(),
              mainButton(),
              secondaryButton(),
            ],
          )),
        ),
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 120),
      child: TextFormField(
        controller: txtEmail,
        onChanged: (text) {
          setState(() {
            _email = text.toString();
          });
        },
        keyboardType: TextInputType.emailAddress,
        decoration:
            const InputDecoration(hintText: 'Email', icon: Icon(Icons.mail)),
        validator: (text) => text!.isEmpty ? 'Email is required' : '',
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextFormField(
          controller: txtPassword,
          onChanged: (text) {
            setState(() {
              _password = text.toString();
            });
          },
          keyboardType: TextInputType.emailAddress,
          obscureText: true,
          decoration: const InputDecoration(
              hintText: 'Password', icon: Icon(Icons.lock)),
          validator: (text) => text!.isEmpty ? 'Password is required' : '',
        ));
  }

  Widget mainButton() {
    String buttonText = _isLogin! ? 'Sign up' : 'Login';
    return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width - 10,
            child: ElevatedButton(
              child: Text(buttonText),
              onPressed: () async {
                submit();
              },
            )));
  }

  Widget secondaryButton() {
    String buttonText = !_isLogin! ? 'Login' : 'Sign up';
    return ElevatedButton(
      child: Text(buttonText),
      onPressed: () async {
        await auth.signUp(_email!, _password!).then((value) => setState(() {
              _message = value;
            }));
        setState(() {
          _isLogin = !_isLogin!;
        });
      },
    );
  }

  Widget validationMessage() {
    return Text(
      _message ?? '',
      style: const TextStyle(
          fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
    );
  }

  Future submit() async {
    try {
      if (_email == null || _password == null) {
        setState(() {
          _message = 'Email or Password empty';
        });
      } else {
        setState(() {
          _message = '';
        });
        await auth.login(_email!, _password!).then((value) => {
              _userId = value,
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Login success'),
                duration: Duration(milliseconds: 2000),
              ))
            });

        if (_userId != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LaunchScreen()),
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        setState(() {
          _message = e.message;
        });
      }
    }
  }
}
