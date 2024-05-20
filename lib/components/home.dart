import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:todo/components/button.dart';
import 'package:todo/components/todoTile.dart';
import 'package:todo/model/task.dart';
import 'package:todo/services/auth_service.dart';
import 'package:todo/services/firestore.dart';
import 'package:todo/services/local_storage.dart';
import 'package:todo/utils/constants.dart';

import '../pages/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic dataFromDb;
  List<Task>? updatedTaskList = [];
  late Stream<QuerySnapshot>? userData;
  final _auth = FirebaseAuth.instance;
  final _userAuth = AuthService();

  @override
  void initState() {
    super.initState();
    _savedData();
    _getUserDataOnLoad();
  }

  _getUserDataOnLoad() async {
    userData = Firestore().getData();
    if(userData == null){
      //show popup saying unauthorized user
    }
    print('usersss === $userData');

    setState(() {

    });
  }

  _savedData() async {
    //var tList = await LocalStorage().getBoxData() ?? [];
    //print("tList List :: ${tList}");

    // setState(() {
    //   updatedTaskList = tList;
    // });
  }

  String taskName = '';
  final TextEditingController myController = TextEditingController();

  addTask(String boxTitle ,{Task? taskDetails,int? index,String? id}) {
    //print('addtASK after edit index = $index , id = $id');
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          '$boxTitle Task',
          textAlign: TextAlign.center,
        ),
        content: Container(
          height: 120,
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
                controller: myController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                      value: boxTitle == Constants().add
                          ? Constants().add
                          : 'Edit',
                      isEnabled: true,
                      pressed: boxTitle == Constants().add
                          ? onAdd
                          : () => onEditClick(index!,id!,taskDetails!)),
                  Button(value: 'Cancel', isEnabled: true, pressed: onCancel),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  onAdd() async {
    var length = updatedTaskList?.length ?? 0;

    Task newTask = Task(
        id: (length + 1).toString(),
        title: myController.text,
        isChecked: false);

    Firestore().addTask(myController.text);

    // setState(() {
    //   updatedTaskList?.add(newTask);
    //   myController.clear();
    // });

    LocalStorage().saveTask(updatedTaskList!);
    myController.clear();
    Navigator.of(context).pop();
  }

  void onCancel() {
    myController.clear();
    Navigator.of(context).pop();
  }

  void checkBoxClicked(bool? val, int index,String id,Task taskDetails) async {
    //print('index = $index');
    //var updatedData = await LocalStorage().updateCheckbox(index);

    // setState(() {
    //   updatedTaskList = updatedData;
    // });
    taskDetails.isChecked = !taskDetails.isChecked;
    Firestore().clickOnTask(id, taskDetails).then((value) =>
      print('checkbox having id = $id is clicked ')
    );
  }

  void onDelete(int index,String id) async {
    //var updatedData = await LocalStorage().deleteTask(index);

    // setState(() {
    //   updatedTaskList = updatedData;
    // });

    await Firestore().deleteTaskFromDb(id)
        .then((value) =>
        Fluttertoast.showToast(
            msg: "Task deleted successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0
        )
    );
  }

  void onEdit(String str, int index,String id,String title,Task taskDetails) async {
    setState(() {
      //myController.text = updatedTaskList![index].title;
      myController.text = title;
    });

    addTask(str,taskDetails:taskDetails ,index: index,id:id);
  }

  onEditClick(int index,String id,Task taskDetails) async {
      print('onedit cliecked call ');
    try {
      //var tList = await LocalStorage().editTask(index, myController.text);
      // setState(() {
      //   updatedTaskList = tList;
      // });
      taskDetails.title = myController.text;
      await Firestore().editTaskInDb(id, taskDetails).then((value) => {
          myController.clear(),
          Navigator.of(context).pop(),
      });

    }catch(err){
      print('error while updating task = $err');
    }
  }

  goToLogin(BuildContext context) async => {

        if (await _userAuth.logoutUser())
          {
            print(' user there? =  $_auth.currentUser?.uid'),
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Login())),
          },
      };

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: const Text('TaskEase'),
          elevation: 10,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.person),
                onSelected: (String result) {
                  // Handle the selected menu item
                  switch (result) {
                    case 'Profile':
                      print('profile clicked');
                      break;
                    case 'Settings':
                      print('settings clicked');
                      break;
                    case 'Logout':
                      goToLogin(context);
                      break;
                    default:
                  }
                  //print(result);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Profile',
                    child: Text('Profile'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Settings',
                    child: Text('Settings'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Logout',
                    child: Text('Logout'),
                  ),
                ],
              ),
            ),
          ]),
      body: StreamBuilder(
          stream: userData,
          builder: (context, AsyncSnapshot snapshot) {

            var tasks;
            if(snapshot.hasData) {
              tasks=snapshot.data!.docs.map((DocumentSnapshot document) {
                // var data =snapshot.data.docs;
                // print('snapshot data = $data');
              return Task.fromJson(document.data() as Map<String,dynamic>) ;
              //return document.data() as Task;
            }).toList();
            }

            return snapshot.hasData
            //return tasks.length>0
                ?
            ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              Task task = tasks[index];
              //print('task values - $task');
              return TodoTile(
                taskName: task.title,
                checked: task.isChecked,
                onClick: (val) => checkBoxClicked(val, index,task.id,task),
                onDelete: (context) => onDelete(index,task.id),
                onEdit: (context) => onEdit('Edit', index,task.id,task.title,task),
              );
            }
            )

            // ListView.builder(
            //         itemCount: snapshot.data.docs.length,
            //         itemBuilder: (context, index) {
            //           DocumentSnapshot ds = snapshot.data.docs[index];
            //           return TodoTile(
            //             taskName: ds['title'],
            //             checked: ds['isChecked'],
            //             onClick: (val) => checkBoxClicked(val, index),
            //             onDelete: (context) => onDelete(index),
            //             onEdit: (context) => onEdit('Edit', index,ds['id']),
            //           );
            //         },
            //       )
                : const Text('no data found');
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addTask(Constants().add);
        },
        label: const Row(
          children: [Icon(Icons.add), SizedBox(width: 10), Text('Add Task')],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
