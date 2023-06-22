import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_nmr/ui/Login.dart';
import 'package:test_nmr/ui/Userlist.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool loading = false;
  File? _image;
  final DatabaseReference _database =
  FirebaseDatabase.instance.reference().child('users');

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
                    "Enter User\nDetails!",
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: Mheight * 0.06),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 100,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : AssetImage("asset/img/user1.png")
                            as ImageProvider<Object>?,
                          ),
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: GestureDetector(
                              onTap: () {
                                _pickImage(ImageSource.gallery);
                              },
                              child: CircleAvatar(
                                radius: 23,
                                child: Icon(
                                  Icons.camera,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Mheight * 0.02),
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
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter Name',
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
                SizedBox(height: Mheight * 0.02),
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
                        controller: ageController,
                        decoration: InputDecoration(
                          hintText: 'Enter Age',
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
                SizedBox(height: Mheight * 0.04),
                loading
                    ? CircularProgressIndicator()  // Show the indicator if loading is true
                    :ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });

                    String name = nameController.text;
                    int age = int.tryParse(ageController.text) ?? 0;

                    if (_image != null) {
                      // Upload the image to Firebase Storage
                      String fileName =
                      DateTime.now().millisecondsSinceEpoch.toString();
                      Reference storageRef = FirebaseStorage.instance
                          .ref()
                          .child('images/$fileName.jpg');
                      UploadTask uploadTask = storageRef.putFile(_image!);
                      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

                      // Get the download URL of the uploaded image
                      String imageUrl = await snapshot.ref.getDownloadURL();

                      // Save the image URL along with other data to the Realtime Database
                      _database.push().set({
                        "name": name,
                        "age": age,
                        "image": imageUrl,
                      }).then((_) {
                        // Image and data saved successfully
                        setState(() {
                          loading = true;
                          nameController.clear();
                          ageController.clear();
                          _image = null;
                          loading = false;
                        });
                      }).catchError((error) {
                        // Error occurred while saving
                        setState(() {
                          loading = false;
                        });
                      });
                    } else {
                      // No image selected
                      // Save only the text data to the Realtime Database
                      _database.push().set({
                        "name": name,
                        "age": age,
                      }).then((_) {
                        // Data saved successfully
                        setState(() {
                          loading = false;
                          nameController.clear();
                          ageController.clear();
                        });
                      }).catchError((error) {
                        // Error occurred while saving
                        setState(() {
                          loading = false;
                        });
                      });
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    primary: Colors.red,
                  ),
                ),
                SizedBox(height: Mheight * 0.02),
                Row(
                  children: [
                    SizedBox(width: Mheight * 0.02),
                    ElevatedButton(
                      onPressed: () {
                        signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (ctx) => Login()),
                              (route) => false,
                        );
                      },
                      child: Text(
                        "Sign Out",
                        style: TextStyle(color: Colors.red),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: Mheight * 0.01),
                Row(
                  children: [
                    SizedBox(width: Mheight * 0.34),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (ctx) => Userlist()),
                        );
                      },
                      child: Container(
                        height: Mheight * 0.1,
                        width: Mwidth * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }
}