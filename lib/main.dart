import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// in firestore create project
// add project name copy it from android/app/src/debug/AndroidManifest.xml from package="com.example.onepage"
// add dependencies in onepage/android/build.gradle
// add things in onepage/android/app/build.gradle
// also in onepage/android/app/build.gradle multiDexEnabled true in defaultconfig file and increase minSdkVersion to 19
// create collection in your firestore databse as i create students
//run bottom commands in terminal of project
//flutter pub add cloud_firestore
//flutter pub add firebase_core
// use and understand the boottom code

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Stream<QuerySnapshot> studentsSteam =
      FirebaseFirestore.instance.collection('students').snapshots();
  CollectionReference students =
      FirebaseFirestore.instance.collection('students');
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: studentsSteam,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('wrong going');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List storedocs = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            //print(document.id);
            a['id'] = document.id;
          }).toList();

          return Container(
            color: Colors.green,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var i = 0; i < storedocs.length; i++)
                    Card(
                      child: Text(
                        storedocs[i]['name'],
                        textDirection: TextDirection.ltr,
                      ),
                    )
                ],
              ),
            ),
          );
        });
  }
}
