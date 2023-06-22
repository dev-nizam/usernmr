import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Userlist extends StatefulWidget {
  const Userlist({Key? key}) : super(key: key);

  @override
  State<Userlist> createState() => _UserlistState();
}

class _UserlistState extends State<Userlist> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.reference().child("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<DatabaseEvent>(
        future: ref.once(),
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While loading data, show a circular progress indicator
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            // Data has been loaded successfully
            return FirebaseAnimatedList(
              query: ref,
              itemBuilder: (context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                      NetworkImage(snapshot.child("image").value.toString()),
                    ),
                    title: Text(snapshot.child("name").value.toString()),
                    subtitle: Text(snapshot.child("age").value.toString()),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            // Error occurred while loading data
            return Center(
              child: Text('Error loading data'),
            );
          } else {
            // No data available
            return Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }
}
