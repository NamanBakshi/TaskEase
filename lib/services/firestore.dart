import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo/model/task.dart';
import 'package:uuid/uuid.dart';

class Firestore{

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<bool> CreateUser(dynamic uid,String email) async {
    try {
      await _firestore
          .collection('users')
          //.doc(_auth.currentUser!.uid)
          .doc(uid)
          .set({"email": email});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addTask(String title) async {
    try {
      var uuid = const Uuid().v4();
      DateTime dateTime = DateTime.now();

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

      });
      return true;
    } catch (e) {
      print('err in addTask = $e');
      return false;
    }
  }

  List<Task> getTasks(AsyncSnapshot snapshot) {
    try {
      // check for null todos
      var tasksList = snapshot.data.docs.map((doc) {
        final task = doc.data() as Map<String, dynamic>;
        return Task(
            id: task['id'],
            title: task['title'],
            isChecked: task['isChecked']);
      }).toList();
      print('all task list = $tasksList');
      return tasksList;
    }catch(err){
      print('err while getting tasks = $err');
      return [];
    }
  }


  Stream<QuerySnapshot> stream() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('tasks')
        //.where('isDon', isEqualTo: isDone)
        .snapshots();
  }

}