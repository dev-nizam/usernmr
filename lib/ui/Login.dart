import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_nmr/ui/Home.dart';
import 'package:test_nmr/ui/Mobile.dart';
import 'package:test_nmr/ui/SignUp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                  padding: const EdgeInsets.only(right: 80),
                  child: Text(
                    "Hello!\nWelcome back",
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: Mheight * 0.1),
                buildInputField(
                  controller: emailController,
                  hintText: 'Email',
                  isObscure: false,
                ),
                SizedBox(height: Mheight * 0.02),
                buildInputField(
                  controller: passwordController,
                  hintText: 'Password',
                  isObscure: true,
                ),
                SizedBox(height: Mheight * 0.01),
                buildForgotPasswordLink(),
                SizedBox(height: Mheight * 0.03),
                buildSignInButton(),
                SizedBox(height: Mheight * 0.02),
                buildSignUpSection(),
                SizedBox(height: Mheight * 0.1),
                buildSocialButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String hintText,
    required bool isObscure,
  }) {
    return Center(
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
            controller: controller,
            obscureText: isObscure,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForgotPasswordLink() {
    return Row(
      children: [
        SizedBox(width: 240),
        Text(
          "Forgot password?",
          style: TextStyle(color: Colors.red),
        ),
      ],
    );
  }

  Widget buildSignInButton() {
    return ElevatedButton(
      onPressed: () => signInAndSaveStatus(context),
      child: Text(
        "Sign In",
        style: TextStyle(color: Colors.white),
      ),
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(Size(300, 50)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
      ),
    );
  }

  Widget buildSignUpSection() {
    return Row(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.3),
        Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.grey),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => SignUp()),
            );
          },
          child: Text(
            "SignUp",
            style: TextStyle(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: signInWithGoogle,
          child: CircleAvatar(
            backgroundImage: AssetImage("asset/img/google.png"),
          ),
        ),
        GestureDetector(onTap:(){
          Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Mobauth()));
        },
          child: CircleAvatar(
            backgroundImage: AssetImage("asset/img/ph.jpg"),
          ),
        ),
      ],
    );
  }

  Future<void> signInAndSaveStatus(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // User sign-in successful, navigate to Home screen
      await saveLoginStatus(true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (ctx) => Home()),
      );
    } catch (e) {
      final errorMessage = "An error occurred during sign-in.";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
          );
        },
      );
    }
  }

  Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("savekeyname", isLoggedIn);
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
      await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      // User authentication successful
      User? user = userCredential.user;
      await saveLoginStatus(true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (ctx) => Home()),
      );
      // Do something with the user object
    } catch (e) {
      print('Error: $e');
    }
  }


}
