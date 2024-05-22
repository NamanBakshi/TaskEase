import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo/model/task.dart';
import 'package:uuid/uuid.dart';

class Firestore {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<bool> CreateUser(dynamic uid, String email) async {
    try {
      await _firestore.collection('users').doc(uid).set({"email": email});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addTask(String title,String dueDate) async {
    try {
      print('firestore addTask');
      print(title);
      print(dueDate);
      var uuid = const Uuid().v4();
      String dateTime = DateTime.now().toString();

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('tasks')
          .doc(uuid)
          .set({
        'id': uuid,
        'title': title,
        'isChecked': false,
        'time': dateTime,
        'taskDueDate' : dueDate,
        'createdAt' : Timestamp.fromDate(DateTime.now()),
      });
      return true;
    } catch (e) {
      print('err in addTask = $e');
      return false;
    }
  }


  Stream<QuerySnapshot> getData() {

    final String? userId = _auth.currentUser?.uid;

    // Check if the user is authenticated
    if (userId == null) {
      print('user not authenticated ');
    }

    // Return a stream of tasks collection for the authenticated user
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .snapshots();
  }

  Future<void> editTaskInDb (String id,Task taskDetails) async {

    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('tasks')
        .doc(id)
        .update(taskDetails.toJson());
  }

  Future<void> deleteTaskFromDb(String id) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('tasks')
        .doc(id)
        .delete();
  }

  Future<void> clickOnTask(String id,Task taskDetails) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('tasks')
        .doc(id)
        .update(taskDetails.toJson());
  }


}
