import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String studentName, studentId, studentProgramme, docIdOfSelectedName;
  double studentGpa;
  String selectedNameDoc;

  //controller

  var updateName = TextEditingController();
  var updateId = TextEditingController();
  var updateProgramme = TextEditingController();
  var updateGpa = TextEditingController();

  //clearning the text in input file
  clearTextInput() {
    updateGpa.clear();
    updateProgramme.clear();
    updateName.clear();
    updateId.clear();
  }

  //helper functions(getter function)
  getStudentName(name) {
    this.studentName = name;
  }

  getStudentId(id) {
    this.studentId = id;
  }

  getStudentProgramme(prog) {
    this.studentProgramme = prog;
  }

  getStudentGpa(gpa) {
    this.studentGpa = double.parse(gpa);
  }

  //creating data
  createData() {
    print('created');
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection('MyStudents').doc();

    //creating a map
    Map<String, dynamic> studentInfo = {
      "studentName": studentName,
      "studentID": studentId,
      "studentProgramme": studentProgramme,
      "studentGpa": studentGpa
    };
    documentReference
        .set(studentInfo)
        .whenComplete(() => print("$studentName created"));
  }

  //getting the doc id of the users

  Future<DocumentReference> getUserDoc() async {
    final userRef = FirebaseFirestore.instance.collection("MyStudents");
    userRef.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        print(doc.data()['studentName']);
        if (selectedNameDoc == doc.data()['studentName']) {
           docIdOfSelectedName = doc.id;
           // print(docIdOfSelectedName);
        }
      });
    });
  }



  CollectionReference documentReference =
  FirebaseFirestore.instance.collection("MyStudents");

  //updating data
  updateData1() {
    documentReference
        .doc(docIdOfSelectedName)
        .update({
      "studentName": updateName.text,
      "studentID": updateId.text,
      "studentProgramme": updateProgramme.text,
      "studentGpa": updateGpa.text
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //deleting data

  Future<DocumentReference> deleteUser() async {
    final userRef = FirebaseFirestore.instance.collection("MyStudents");
    userRef.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        print(doc.data()['studentName']);
        if (selectedNameDoc == doc.data()['studentName']) {
          userRef.doc(doc.id)
              .delete()
              .then((value) => print("User Deleted"))
              .catchError((error) => print("Failed to delete user: $error"));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD System'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: updateName,
                decoration: InputDecoration(
                    labelText: 'Name',
                    fillColor: Colors.white70,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.blue, width: 2.0))),
                onChanged: (String name) {
                  getStudentName(name);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: updateId,
                decoration: InputDecoration(
                    labelText: 'Student ID',
                    fillColor: Colors.white70,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.blue, width: 2.0))),
                onChanged: (String id) {
                  getStudentId(id);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: updateProgramme,
                decoration: InputDecoration(
                    labelText: 'Study Programme',
                    fillColor: Colors.white70,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.blue, width: 2.0))),
                onChanged: (String prog) {
                  getStudentProgramme(prog);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: updateGpa,
                decoration: InputDecoration(
                    labelText: 'GPA',
                    fillColor: Colors.white70,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.blue, width: 2.0))),
                onChanged: (String gpa) {
                  getStudentGpa(gpa);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text(
                    'Create',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(10),
                      textStyle: TextStyle(
                        fontSize: 10,
                      )),
                  onPressed: () {
                    clearTextInput();
                    createData();
                  },
                ),
                ElevatedButton(
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      onPrimary: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(10),
                      textStyle: TextStyle(
                        fontSize: 10,
                      )),
                  onPressed: () {
                    updateData1();
                    clearTextInput();
                  },
                ),
              ],
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("MyStudents")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  else if (!snapshot.hasData) {
                    return Container(
                      child: Text('No data'),
                    );
                  }
                  // return CircularProgressIndicator();
                  else {
                    return ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: snapshot.data.docs
                          .map<Widget>((DocumentSnapshot document) {
                        var name = document.data()['studentName'];
                        var programme = document.data()['studentProgramme'];
                        var cgpa = document.data()['studentGpa'];
                        var id = document.data()['studentID'];

                        return Table(
                          children: [
                            TableRow(
                              children: [
                                Text("$name"),
                                Text("$id"),
                                Text("$programme"),
                                Text("$cgpa"),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                      setState(() {
                                        selectedNameDoc = name;
                                        // getUserDoc();
                                        deleteUser();
                                      });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    updateName.text = name;
                                    updateId.text = id;
                                    updateProgramme.text = programme;
                                    updateGpa.text = cgpa.toString();
                                    selectedNameDoc = name;
                                    // print(newName);
                                    // updateData(name);
                                    getUserDoc();
                                  },
                                )
                              ],
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
