import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Homepage.dart';
import 'package:flutter_application_1/components/textformfiled.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            ListView(padding: EdgeInsets.only(left: 20, right: 20), children: [
      Column(
        children: [
          Container(
            height: 50,
          ),
          Container(
              width: 90,
              height: 90,
              alignment: Alignment.center,
              // padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(90)),
              child: Image.asset(
                "images/logo2.png",
                width: 60,
              )),
        ],
      ),
      Container(
        height: 20,
      ),
      Form(
        key: formstate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SignUp",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            Container(
              height: 10,
            ),
            Text(
              "SignUp to continue using the app",
              style: TextStyle(fontSize: 17, color: Colors.grey),
            ),
            Container(
              height: 40,
            ),
            Text(
              "Username",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 10,
            ),
            CustomTextForm(
              hinttext: "Enter your name",
              mycontroller: username,
              validator: (val) {
                if (val == "") {
                  return "This field is required";
                }
                return null;
              },
            ),
            Container(
              height: 40,
            ),
            Text(
              "Email",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 10,
            ),
            CustomTextForm(
              hinttext: "Enter your email",
              mycontroller: email,
              validator: (val) {
                if (val == "") {
                  return "This field is required";
                }
                return null;
              },
            ),
            Container(
              height: 40,
            ),
            Text(
              "Password",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 10,
            ),
            CustomTextForm(
              hinttext: "Enter your password",
              mycontroller: password,
              validator: (val) {
                if (val == "") {
                  return "This field is required";
                }
                return null;
              },
            ),
          ],
        ),
      ),
      Container(
        height: 30,
      ),
      MaterialButton(
        height: 50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Color.fromARGB(255, 10, 104, 211),
        textColor: Colors.white,
        onPressed: () async {
          if (formstate.currentState!.validate()) {
            try {
              // final credential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email.text, password: password.text);
              FirebaseAuth.instance.currentUser!.sendEmailVerification();
              AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.rightSlide,
                title: 'Verification',
                desc: 'Click the link that was sent to your email to continue and login',
                
                
              )..show();
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
                print('The password provided is too weak.');
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'Error',
                  desc: 'The password provided is too weak.',
                )..show();
              } else if (e.code == 'email-already-in-use') {
                print('The account already exists for that email.');
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'Error',
                  desc: 'The account already exists for that email.',
                )..show();
              }
            } catch (e) {
              print(e);
            }
          }
        },
        child: Text(
          "SignUp",
          style: TextStyle(fontSize: 20),
        ),
      ),
      Container(
        height: 30,
      ),
      Container(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already Have An Account ? ",
            style: TextStyle(fontSize: 18),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed("login");
            },
            child: Text(
              "Login",
              style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 15, 124, 213),
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      )
    ]));
  }
}
