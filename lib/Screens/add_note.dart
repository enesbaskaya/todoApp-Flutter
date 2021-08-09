import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../extension.dart';
import '../model/note.dart';
import 'my_notes.dart';

// ignore: use_key_in_widget_constructors
class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid.toString();

  int timeEpoch = DateTime.now().millisecondsSinceEpoch; //DateTime

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  Container buildBody(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Enter Title'),
          ),
          TextFormField(
            controller: contentController,
            decoration: const InputDecoration(labelText: 'Enter Content'),
          ),
          // ignore: sized_box_for_whitespace
          Container(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                final notesRef = FirebaseFirestore.instance
                    .collection('notes')
                    .withConverter<Note>(fromFirestore: (snapshot, _) => Note.fromJson(snapshot.data()!), toFirestore: (note, _) => note.toJson());
                notesRef.add(
                  Note(title: titleController.text, content: contentController.text, uid: uid, isCompleted: false, timeEpoch: timeEpoch),
                );
                Fluttertoast.showToast(
                    msg: 'Note Added Success', timeInSecForIosWeb: 1, backgroundColor: Colors.green, textColor: Colors.white, fontSize: 16.0);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyNotes()), (route) => false);
              },
              child: Text(
                'Added Note',
                style: TextStyle(color: context.whiteColor),
              ),
              style: OutlinedButton.styleFrom(backgroundColor: context.orangeColor),
            ),
          )
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: context.whiteColor),
      title: Text(
        'Add New Note',
        style: TextStyle(color: context.whiteColor),
      ),
    );
  }
}
