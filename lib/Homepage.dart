import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/categories/edit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_application_1/note/view.dart';

class Homepage extends StatefulWidget {

  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<QueryDocumentSnapshot> data = [];
  bool loading=true;
  getdata() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("categories").where("id",isEqualTo: FirebaseAuth.instance.currentUser!.uid ).get();
           loading=false;
    data.addAll(querySnapshot.docs);
 
  setState(() {
    
  });

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
            Navigator.of(context).pushNamed("addcategory");
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text("Homepage"),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  googleSignIn.disconnect();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("login", (route) => false);
                },
                icon: Icon(Icons.exit_to_app_outlined))
          ],
        ),
        body:loading==true?Center(child: CircularProgressIndicator()): GridView.builder(
          itemCount: data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisExtent: 220),
          itemBuilder: (context, index) {
            return InkWell(
               onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Noteview(categoryid:data[index].id),));
                    },
              onLongPress: () {
                 AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          btnCancelText: "Delete",
           btnOkOnPress: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditCategory(docid: data[index].id, oldname: data[index]["name"]),));
           },
          btnOkText: "Edit",
         btnCancelOnPress: () async{
            await FirebaseFirestore.instance.collection("categories").doc(data[index].id).delete();
            Navigator.of(context).pushNamedAndRemoveUntil("homepage",(route) => false,);
          },
       
        ).show();
              },
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Image.asset(
                        'images/folder.png',
                        height: 150,
                      ),
                      Text(
                        "${data[index]['name']}",
                        style:
                            TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
