import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_nmr/ui/verify.dart';

class Mobauth extends StatefulWidget {
  const Mobauth({super.key});

  @override
  State<Mobauth> createState() => _MobauthState();
}

class _MobauthState extends State<Mobauth> {
  bool loading =false;
  final mobcontroller = TextEditingController();
  final auth =FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final Mheight = MediaQuery.of(context).size.height;
    final Mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body:Column(
        children: [
          SizedBox(
            height: Mheight * 0.1,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 120),
            child: Text(
              "Enter your\nmobile number",
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
          height: Mheight*0.06,
          width: Mwidth*0.8,
          child: Text(
            "we have to send the code verification to your mobile number",
            style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.w600),
          ),
        ),
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
                  controller: mobcontroller,
                  keyboardType:TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '+91 type number',
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
            height: Mheight * 0.05,
          ),
          loading
              ? CircularProgressIndicator() :  ElevatedButton(
            onPressed: () {
              setState(() {
                loading = true;
              });
              auth.verifyPhoneNumber(
                phoneNumber: mobcontroller.text,
                  verificationCompleted: (_){
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (e){
                    setState(() {
                      loading = false;
                    });
                  },
                  codeSent: (String verificationid ,int? token){
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (ctx) => Verification(verificationid: verificationid)));

                  },
                  codeAutoRetrievalTimeout: (e){
                    setState(() {
                      loading = false;
                    });
                  });


            },
            child: Text(
              "Send code",
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(Size(300, 50)),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
