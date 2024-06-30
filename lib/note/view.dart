import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/note/addnote.dart';
import 'package:flutter_application_1/note/editnote.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Noteview extends StatefulWidget {
  final String categoryid;
  const Noteview({super.key, required this.categoryid});

  @override
  State<Noteview> createState() => _NoteviewState();
}

class _NoteviewState extends State<Noteview> {
  List<QueryDocumentSnapshot> data = [];
  bool loading = true;
  getdata() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryid)
        .collection("note")
        .get();
    loading = false;
    data.addAll(querySnapshot.docs);

    setState(() {});
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNote(docid: widget.categoryid),
            ));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text("Notes"),
        ),
        body: WillPopScope(
            child: loading == true
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    itemCount: data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, mainAxisExtent: 220),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditNote(notedocid: data[index].id, categoryid: widget.categoryid, notevalue: data[index]['note']),));
                        },
                              onLongPress: () {
                                 AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: "Warning",
                          desc: 'Are you sure you want to delete this note ? ',
                          btnCancelOnPress: () {},
                          btnOkText: "Yes",
                          btnOkOnPress: () async{
                            await FirebaseFirestore.instance.collection("categories").doc(widget.categoryid).collection("note").doc(data[index].id).delete();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) =>  Noteview(categoryid: widget.categoryid)));
                          },

                        ).show();
                              },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  "${data[index]['note']}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            onWillPop: () {
              Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);
              return Future.value(false);
            }));
  }
}
