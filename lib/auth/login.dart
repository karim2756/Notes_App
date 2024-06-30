import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/textformfiled.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  bool loading = false;

//function to login with google account
  Future signInWithGoogle() async {
    loading = true;
    setState(() {});
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    loading = false;
    setState(() {});
    Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading == true
            ? Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.only(left: 20, right: 20),
                children: [
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
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 40),
                          ),
                          Container(
                            height: 10,
                          ),
                          Text(
                            "Login to continue using the app",
                            style: TextStyle(fontSize: 17, color: Colors.grey),
                          ),
                          Container(
                            height: 40,
                          ),
                          Text(
                            "Email",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                              }),
                          Container(
                            height: 40,
                          ),
                          Text(
                            "Password",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                              }),
                          Container(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (email.text == "") {
                          return;
                        }
                        try {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email.text);
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.rightSlide,
                            title: 'Password Reset',
                            desc: 'Reset link was sent to your email.',
                            btnOkOnPress: () {},
                          )..show();
                        } catch (e) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'Please Enter a valid email.',
                            btnCancelOnPress: () {},
                          )..show();
                        }
                      },
                      child: Text(
                        "forgot password?",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 15, 124, 213)),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Container(
                      height: 15,
                    ),
                    MaterialButton(
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Color.fromARGB(255, 10, 104, 211),
                      textColor: Colors.white,
                      onPressed: () async {
                        if (formstate.currentState!.validate()) {
                          try {
                            loading = true;
                            setState(() {});
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email.text, password: password.text);
                            loading = false;
                            setState(() {});
                            if (credential.user!.emailVerified) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "homepage", (route) => false);
                            } else {
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.info,
                                  animType: AnimType.rightSlide,
                                  title: 'Verification failed',
                                  desc:
                                      'Please verify your email by the link that was sent to you then login again.')
                                ..show();
                              await FirebaseAuth.instance.signOut();
                            }
                          } on FirebaseAuthException catch (e) {
                            loading=false;
                              setState(() {
                                
                              });
                            if (e.code == 'user-not-found') {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'No user found for that email.',
                              ).show();
                              print('No user found for that email.');
                              
                            } else if (e.code == 'wrong-password') {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'Wrong password provided for that user.',
                              ).show();
                              print('Wrong password provided for that user.');
                             
                            }
                          }
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      height: 30,
                    ),
                    MaterialButton(
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Color.fromARGB(255, 166, 205, 237),
                      textColor: Colors.grey[700],
                      onPressed: () {
                        signInWithGoogle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Login with Google ",
                            style: TextStyle(fontSize: 18),
                          ),
                          Image.asset(
                            "images/google.png",
                            width: 40,
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't Have An Account ? ",
                          style: TextStyle(fontSize: 18),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed("signup");
                          },
                          child: Text(
                            "Register",
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
