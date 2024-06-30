import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/textfieldadd.dart';
import 'package:flutter_application_1/note/view.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({super.key, required this.docid});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  bool loading = false;

  addnote() async {
    CollectionReference collectionnote = FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.docid)
        .collection("note");
    if (formstate.currentState!.validate()) {
      try {
        loading = true;
        setState(() {});
        DocumentReference response = await collectionnote.add({
          "note": note.text,
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Noteview(categoryid: widget.docid),));
      } catch (e) {
        loading = false;
        setState(() {});
        print(e);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: "Error",
          desc: 'Couldn\'t add the note ',
          btnCancelOnPress: () {},
        ).show();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
        
      ),
      body: loading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Form(
                  key: formstate,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: CustomTextFromAdd(
                          hinttext: "Enter note",
                          mycontroller: note,
                          validator: (val) {
                            if (val == "") return "Name is required";
                          },
                        ),
                      ),
                      MaterialButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          addnote();
                        },
                        child: Text(
                          "Add",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
