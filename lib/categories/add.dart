import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Homepage.dart';
import 'package:flutter_application_1/components/textfieldadd.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection("categories");
  bool loading = false;

  addcategory() async {
    if (formstate.currentState!.validate()) {
      try {
        loading = true;
        setState(() {
          
        });
        DocumentReference response = await categories.add(
            {"name": name.text, "id": FirebaseAuth.instance.currentUser!.uid});
        Navigator.of(context).pushNamedAndRemoveUntil("homepage",(route) => false,);
      } catch (e) {
        loading=false;
        setState(() {
          
        });
        print(e);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: "Error",
          desc: 'Couldn\'t add the category ',
          btnCancelOnPress: () {},
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
       
      ),
      body:loading==true?Center(child: CircularProgressIndicator(),): ListView(
        children: [
          Form(
            key: formstate,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: CustomTextFromAdd(
                    hinttext: "Enter category name",
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
                    addcategory();
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
