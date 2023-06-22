import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_nmr/ui/Home.dart';
import 'package:test_nmr/ui/Login.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // goToLogin();
    userlogin();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
            ),
            Icon(
              Icons.account_circle,size: 130,
              color: Colors.red,
            ),
            SizedBox(
              height: 200,
            ),
            Text(
              "Users",
              style: TextStyle( fontFamily: 'MyCustomFont',
                fontSize: 24.0,
                fontWeight: FontWeight.bold,),
            )
          ],
        ),
      ),
    ));
  }

  Future<void> goToLogin() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => Login()));
  }
  Future<void>userlogin()async{
    final prefs = await SharedPreferences.getInstance();
    final userlogin= prefs.getBool("savekeyname");
    if(userlogin==null||userlogin==false){
      goToLogin();
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>Home()));
    }
  }
}
