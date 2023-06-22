import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_nmr/ui/Home.dart';

class Verification extends StatefulWidget {
  Verification({super.key, required this.verificationid});
  final verificationid;
  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  bool loading = false;
  final mobcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final Mheight = MediaQuery.of(context).size.height;
    final Mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: Mheight * 0.3,
        ),
        Center(
          child: Container(
            height: Mheight * 0.06,
            width: Mwidth * 0.8,
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
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'otp',
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
            ? CircularProgressIndicator() :
        ElevatedButton(
          onPressed: ()async {
            setState(() {
              loading = true;
            });
            final credential = PhoneAuthProvider.credential(
                verificationId: widget.verificationid,
                smsCode: mobcontroller.text.toString());
            try{
              await auth.signInWithCredential(credential);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (ctx) => Home()));
            }catch(e){
              setState(() {
                loading = false;
              });
            }
          },
          child: Text(
            "Submit",
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all<Size>(Size(300, 50)),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          ),
        ),
      ],
    ));
  }
}
