import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/textfieldadd.dart';
import 'package:flutter_application_1/note/view.dart';

class EditNote extends StatefulWidget {
  final String notedocid;
  final String categoryid;
    final String notevalue;


  const EditNote({super.key, required this.notedocid, required this.categoryid, required this.notevalue});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  bool loading = false;

  EditNote() async {
    CollectionReference collectionnote = FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryid)
        .collection("note");
    if (formstate.currentState!.validate()) {
      try {
        loading = true;
        setState(() {});
      await collectionnote.doc(widget.notedocid).update({
          "note": note.text,
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Noteview(categoryid: widget.categoryid),));
      } catch (e) {
        loading = false;
        setState(() {});
        print(e);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: "Error",
          desc: 'Couldn\'t edit the note ',
          btnCancelOnPress: () {},
        ).show();
      }
    }
  }
@override
  void initState() {
    note.text=widget.notevalue;
    // TODO: implement initState
    super.initState();
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
        title: Text("Edit Note"),
        
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
                          hinttext: "Edit note",
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
                          EditNote();
                        },
                        child: Text(
                          "Save",
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
