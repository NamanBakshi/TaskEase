import 'package:flutter/material.dart';
import 'package:todo/pages/signup.dart';

import '../components/button.dart';
import '../components/home.dart';
import '../services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = AuthService();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late String _email = "";
  late String _password = "";

  bool _areAllInputsEntered() {
    return _email.isNotEmpty && _password.isNotEmpty;
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  goToSignup(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => const Signup()));

  goToHome(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => const Home()));

  _loginUser() async {
    final user = await _auth.loginUser(_email, _password);
    print('user = $user');
    if (user) {
      print('user loggedIn successfully');
      goToHome(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buildContent() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(children: [
          //const Spacer(),
          const SizedBox(
            height: 50,
          ),
          const Text(
            'TaskEase',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text("Login",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300)),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.lightBlueAccent,
                width: 2.0,
              )),
            ),
            onChanged: (newValue) {
              setState(() {
                _email = newValue;
              });
            },
            controller: emailController,
          ),
          const SizedBox(
            height: 50,
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.lightBlueAccent,
                width: 2.0,
              )),
            ),
            onChanged: (newValue) {
              setState(() {
                _password = newValue;
              });
            },
            controller: passwordController,
          ),
          const SizedBox(
            height: 50,
          ),
          Button(
              value: 'Login',
              isEnabled: _areAllInputsEntered(),
              pressed: () {
                _areAllInputsEntered() ? _loginUser() : null;
              }),
          const SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("Don't have an account? "),
            InkWell(
              onTap: () => goToSignup(context),
              child: const Text("Signup", style: TextStyle(color: Colors.blue)),
            )
          ]),
        ]),
      );
    }

    return Scaffold(
        body: Center(
      child: MediaQuery.of(context).size.width > 768
          ? Container(
              height: 600,
              width: 400,
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                border: Border.all(
                  color: Colors.lightBlueAccent, // Border color
                  width: 2.0, // Border width
                ),
                borderRadius:
                    BorderRadius.circular(10), // Optional: Rounded corners
              ),
              child: buildContent(),
            )
          : buildContent(),
    ));
  }
}
