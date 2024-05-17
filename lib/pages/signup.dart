import 'package:flutter/material.dart';
import 'package:todo/components/home.dart';
import 'package:todo/components/input_field.dart';
import 'package:todo/pages/login.dart';
import 'package:todo/services/auth_service.dart';

import '../components/button.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final _auth = AuthService();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late String _name = "";
  late String _email = "";
  late String _password = "";

  bool _areAllInputsEntered() {
    return _name.isNotEmpty && _email.isNotEmpty && _password.isNotEmpty;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  goToHome(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context)=> const Home())
  );

  goToLogin(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const Login() )
  );

  _signupUser() async {
      final user = await _auth.signupUser(_email, _password);
      print('res after signup = $user');
      if(user){
        print('user created successfully');
        goToHome(context);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
          //MediaQuery.of(context).size.width > 768
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
        const Text("Signup",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300)),
        const SizedBox(
          height: 30,
        ),
        //CustomTextField(inputName: _name, controller: nameController, labelText: 'Name',),
        TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Name',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.lightBlueAccent,
                width: 2.0,
              )
            ),

          ),
          onChanged: (newValue) {
            setState(() {
              _name = newValue;
            });
          },
          controller: nameController,
        ),
        const SizedBox(
          height: 50,
        ),
        TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Email',
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.lightBlueAccent,
                  width: 2.0,
                )
            ),
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
                )
            ),
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
            value: 'Submit',
            isEnabled: _areAllInputsEntered(),
            pressed: () {
              _areAllInputsEntered()
                  ? //print('name= $_name \n email= $_email \n password= $_password')
                    _signupUser()
                  : null;
            }),
        const SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Already have an account? "),
          InkWell(
            onTap: () => goToLogin(context),
            child: const Text("Login", style: TextStyle(color: Colors.blue)),
          )
        ]),
      ]),
    ),
    );
  }
}
