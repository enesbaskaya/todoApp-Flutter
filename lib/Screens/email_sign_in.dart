import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/extension.dart';

import 'my_notes.dart';

class EmailSignIn extends StatefulWidget {
  EmailSignIn({Key? key}) : super(key: key);

  @override
  _EmailSignInState createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildSignInEmailPassForm(context),
    );
  }

  Column buildSignInEmailPassForm(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: 'Enter Email'),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(labelText: 'Enter Password'),
        ),
        registerButton(context)
      ],
    );
  }

  Container registerButton(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 10),
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () async {
            await createSignInEmailPass(context);
          },
          child: Text(
            'Register',
            style: TextStyle(color: context.whiteColor),
          ),
          style: OutlinedButton.styleFrom(backgroundColor: Colors.orange),
        ));
  }

  Future<void> createSignInEmailPass(BuildContext context) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyNotes()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        'Email Sign In',
        style: TextStyle(color: context.whiteColor),
      ),
    );
  }
}
