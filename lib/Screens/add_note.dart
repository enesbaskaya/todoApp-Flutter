import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/Screens/my_notes.dart';
import 'package:todo_app/extension.dart';
import 'package:todo_app/model/note.dart';
import 'package:intl/intl.dart';

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
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Enter Title'),
          ),
          TextFormField(
            controller: contentController,
            decoration: InputDecoration(labelText: 'Enter Content'),
          ),
          Container(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                final notesRef = FirebaseFirestore.instance
                    .collection('notes')
                    .withConverter<Note>(
                        fromFirestore: (snapshot, _) =>
                            Note.fromJson(snapshot.data()!),
                        toFirestore: (note, _) => note.toJson());
                notesRef.add(
                  Note(
                      title: titleController.text,
                      content: contentController.text,
                      uid: uid,
                      isCompleted: false,
                      timeEpoch: timeEpoch),
                );
                Fluttertoast.showToast(
                    msg: 'Note Added Success',
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MyNotes()),
                    (route) => false);
              },
              child: Text(
                'Added Note',
                style: TextStyle(color: context.whiteColor),
              ),
              style: OutlinedButton.styleFrom(
                  backgroundColor: context.orangeColor),
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
