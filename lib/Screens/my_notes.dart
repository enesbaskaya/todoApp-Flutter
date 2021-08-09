import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/Screens/add_note.dart';
import 'package:todo_app/Screens/home_page.dart';
import 'package:todo_app/extension.dart';

class MyNotes extends StatefulWidget {
  @override
  _MyNotesState createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference noteColRef =
      FirebaseFirestore.instance.collection('notes');
  Stream<QuerySnapshot> _snapshotNotes = FirebaseFirestore.instance
      .collection('notes')
      .where('uid',
          isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(context),
      appBar: buildAppBar(context),
      body: StreamBuilder<QuerySnapshot>(
        stream: _snapshotNotes,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('hata oldu');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading');
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return new ListTile(
                onTap: () {
                  setState(() {
                    noteColRef
                        .doc(document.id)
                        .update({'isCompleted': !(data['isCompleted'])})
                        .then((value) => print('Completed Success'))
                        .catchError((er) => print('Error'));
                  });
                },
                onLongPress: () {
                  noteColRef.doc(document.id).delete();
                },
                title: Text(data['title']),
                subtitle: Text(data['content']),
                trailing: data['isCompleted']
                    ? Tooltip(
                        message: 'Completed',
                        child: Icon(
                          Icons.check,
                          color: context.greenColor,
                        ),
                      )
                    : Icon(
                        Icons.close,
                        color: context.redColor,
                      ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.orange,
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddNote()));
      },
      child: Icon(
        Icons.add,
        color: context.whiteColor,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () async {
              _auth.signOut();
              if (await GoogleSignIn().isSignedIn()) {
                await GoogleSignIn().disconnect();
                await GoogleSignIn().signOut();
              }
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            icon: Icon(Icons.exit_to_app_rounded))
      ],
      iconTheme: IconThemeData(color: context.whiteColor),
      title: Column(
        children: [
          Text(
            'My Notes',
            style: TextStyle(color: context.whiteColor, fontSize: 25),
          ),
          SizedBox(height: 3),
          if (user?.email.toString() != null)
            Text(
              user!.email.toString(),
              style: TextStyle(color: context.greyColor, fontSize: 11),
            ),
        ],
      ),
    );
  }
}
