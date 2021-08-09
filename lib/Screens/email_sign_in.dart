import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../extension.dart';
import 'my_notes.dart';

class EmailSignIn extends StatefulWidget {
  const EmailSignIn({Key? key}) : super(key: key);

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

  Padding buildSignInEmailPassForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.05), vertical: context.dynamicHeight(0.03)),
      child: Column(
        children: [
          Text('BSK TODO', style: GoogleFonts.pacifico(fontSize: 35)),
          const SizedBox(height: 10),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Enter Email'),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Enter Password'),
          ),
          registerButton(context)
        ],
      ),
    );
  }

  Container registerButton(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 10),
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
      await auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyNotes()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The account already exists for that email.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        'Email Sign In',
        style: TextStyle(color: context.whiteColor),
      ),
    );
  }
}
