
import 'package:flutter/material.dart';
import 'package:test_nmr/ui/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

final Emailcontroller = TextEditingController();
final Passwordcontroller = TextEditingController();
final CPasswordcontroller = TextEditingController();
bool _passwordsMatch = true;
final FirebaseAuth _auth = FirebaseAuth.instance;

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final Mheight = MediaQuery.of(context).size.height;
    final Mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 120),
                  child: Text(
                    "Signup to\nget started",
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.red,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: Mheight * 0.1,
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: Emailcontroller,
                        decoration: InputDecoration(
                          hintText: 'email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.all(15.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Mheight * 0.02,
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: Passwordcontroller,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Pasword',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.all(15.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Mheight * 0.02,
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        obscureText: true,
                        controller: CPasswordcontroller,
                        decoration: InputDecoration(
                          errorText:
                              _passwordsMatch ? null : 'Passwords do not match',
                          hintText: 'Conform Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.all(15.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Mheight * 0.03,
                ),
                ElevatedButton(
                  onPressed: () {
                    _submitForm();

                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(Size(300, 50)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  ),
                ),
                SizedBox(
                  height: Mheight * 0.02,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: Mwidth * 0.3,
                    ),
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) => Login()));
                        },
                        child: Text(
                          "SignIn",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    String password = Passwordcontroller.text;
    String confirmPassword = CPasswordcontroller.text;

    if (password == confirmPassword) {
      // Passwords match, proceed with signup logic
      setState(() {
        _passwordsMatch = true;
      });
      signUp(Emailcontroller.text,Passwordcontroller.text);
      Navigator.push(context,
          MaterialPageRoute(builder: (ctx) => Login()));
      // ...
    } else {
      // Passwords don't match, show an error message
      setState(() {
        _passwordsMatch = false;
      });
    }
  }
  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: Emailcontroller.text,
        password: Passwordcontroller.text,
      );
      // User sign-up successful, you can do something here
    } catch (e) {
      // Error occurred during sign-up, handle the error
    }
  }
}
