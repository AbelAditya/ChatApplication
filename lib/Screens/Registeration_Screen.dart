import 'package:chat_app/Screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "Register";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _pswd = TextEditingController();

  final auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  void dispose(){
    super.dispose();
    _email.dispose();
    _pswd.dispose();
  }

  bool spinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "logo",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  controller: _email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter something";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Email Address",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      labelText: "Email"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  controller: _pswd,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter something";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "Enter Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      labelText: "Password"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Material(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          setState(() {
                            spinner=true;
                          });
                          final newUser =
                              await auth.createUserWithEmailAndPassword(
                                  email: _email.text, password: _pswd.text);
                          if (newUser != null) {
                            setState(() {
                              spinner = false;
                            });
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>ChatScreen()),(route)=>false);
                          }
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            spinner = false;
                          });
                          if (e.code == 'email-already-in-use') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(child: Text("Already registered as a user try logging in",style: TextStyle(fontSize: 18),)),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      } else {
                        print("There is some error");
                      }
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
