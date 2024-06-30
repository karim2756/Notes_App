import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Homepage.dart';
import 'package:flutter_application_1/components/textfieldadd.dart';

class EditCategory extends StatefulWidget {
  final String docid;

  final String oldname;
  const EditCategory({super.key, required this.docid, required this.oldname});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection("categories");
  bool loading = false;

  EditCategory() async {
    if (formstate.currentState!.validate()) {
      try {
        loading = true;
        setState(() {});
        await categories.doc(widget.docid).update({"name": name.text});
        Navigator.of(context).pushNamedAndRemoveUntil("homepage",(route) => false,);
      } catch (e) {
        loading = false;
        setState(() {});
        print(e);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: "Error",
          desc: 'Couldn\'t edit the category ',
          btnCancelOnPress: () {},
        ).show();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = widget.oldname;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
      }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Category"),
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
                          hinttext: "Edit category name",
                          mycontroller: name,
                          validator: (val) {
                            if (val == "") return "Name is required";
                          },
                        ),
                      ),
                      MaterialButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          EditCategory();
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
