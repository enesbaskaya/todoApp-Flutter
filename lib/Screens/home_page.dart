import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_button/sign_button.dart';
import 'package:todo_app/extension.dart';

import 'email_sign_in.dart';
import 'my_notes.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isUnValidEmail = false;
  String emailErrorText = 'Invalid Email';

  bool isUnValidPassword = false;
  String passwordErrorText = 'Invalid Password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: SingleChildScrollView(
          child: Container(
              child: Column(
            children: [
              buildLoginForm(context),
              buildSignInButtons(context),
            ],
          )),
        ));
  }

  Column buildSignInButtons(BuildContext context) {
    return Column(
      children: [
        SignInButton(
            buttonType: ButtonType.mail,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmailSignIn(),
                ),
              );
            }),
        SignInButton(
            buttonType: ButtonType.google,
            onPressed: () => _signInWithGoogle()),
        SignInButton(buttonType: ButtonType.apple, onPressed: () {}),
        SignInButton(buttonType: ButtonType.linkedin, onPressed: () {}),
      ],
    );
  }

  Column buildLoginForm(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          decoration: InputDecoration(
              labelText: 'Enter Email',
              errorText: isUnValidEmail ? emailErrorText : null),
        ),
        TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
              labelText: 'Enter Password',
              errorText: isUnValidPassword ? passwordErrorText : null),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () async {
              await loginButtonOnPressed(context);
            },
            child: Text(
              'Login',
              style: TextStyle(color: context.whiteColor),
            ),
            style: OutlinedButton.styleFrom(backgroundColor: Colors.orange),
          ),
        ),
      ],
    );
  }

  Future<void> loginButtonOnPressed(BuildContext context) async {
    emailAndPasswordControl();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyNotes()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user found for that email.')));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Wrong password provided for that user.')));
        print('Wrong password provided for that user.');
      }
    }
  }

  ///
  ///KONTROL EDİLECEK
  ///
  void emailAndPasswordControl() {
    if (emailController.text.length <= 0 &&
        passwordController.text.length > 0) {
      setState(() {
        isUnValidEmail = true;
        isUnValidPassword = false;
        passwordErrorText = '';
        emailErrorText = 'object';
      });
    }
    if (passwordController.text.length <= 0 &&
        emailController.text.length > 0) {
      print('ss');
      setState(() {
        isUnValidEmail = false;

        isUnValidPassword = true;
        emailErrorText = '';
        passwordErrorText = 'data';
      });
    }
  }

  _signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuthentication =
          await googleUser.authentication;
      var credential = GoogleAuthProvider.credential(
        accessToken: googleAuthentication.accessToken,
        idToken: googleAuthentication.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Hoşgeldiniz, ${user?.displayName ?? 'dede'}')));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyNotes()));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code.toString())));
    } catch (e) {
      print(e.toString());
    }
  }
}
