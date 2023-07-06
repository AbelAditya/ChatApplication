import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/Screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Login extends StatefulWidget {
  static String id = "Login";

  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email = TextEditingController();
  TextEditingController _pswd = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _email.dispose();
    _pswd.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  bool spinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Hero(
                    tag: "logo",
                    child: Container(
                      child: Image.asset("images/logo.png"),
                      height: 200.0,
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _email,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: "Enter Email Address",
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter something";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _pswd,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: "Enter Password",
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter something";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(30.0),
                  elevation: 5.0,
                  child: MaterialButton(
                    height: 42.0,
                    minWidth: 200.0,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          setState(() {
                            spinner=true;
                          });
                          final user = await _auth.signInWithEmailAndPassword(
                              email: _email.text, password: _pswd.text);
                          if (user != null){
                            setState(() {
                              spinner = false;
                            });
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>ChatScreen()),(route)=>false);
                          }
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            spinner=false;
                          });
                          if (e.code == 'user-not-found') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(
                                  child: Text(
                                    "No such user found register first",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          else if(e.code=='wrong-password'){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(
                                  child: Text(
                                    "Please enter the correct password",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      } else {
                        print("Nah man try again");
                      }
                    },
                    child: Text(
                      "Log In",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
