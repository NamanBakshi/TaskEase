import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:todo/components/button.dart';
import 'package:todo/components/date_picker.dart';
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
  String dueDate=DateTime.now().toString().split(' ')[0];
  bool enable=false;

  @override
  void initState() {
    super.initState();
    _getUserDataOnLoad();
  }

  _getUserDataOnLoad() {
    userData = Firestore().getData();
    if (userData == null) {
      //show popup saying unauthorized user
    }
    print('usersss === $userData');

  }

  String taskName = '';
  final TextEditingController myController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  bool _areAllInputsEntered() {
    print(' result = ');
    print(taskName.isNotEmpty);
    return taskName.isNotEmpty;
  }

  addTask(String boxTitle, {Task? taskDetails, String? id}) {
    //print('addtASK after edit index = $index , id = $id');
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          '$boxTitle Task',
          textAlign: TextAlign.center,
        ),
        content: Container(
          height: 220,
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.lightBlueAccent,
                    width: 2.0,
                  )),
                ),
                controller: myController,
                onChanged: (newValue) {
                  print('new taskname = $newValue');
                  setState(() {
                    taskName = newValue;
                    enable= taskName.isNotEmpty;
                  });
                },
              ),
              //DatePicker( dueDate: dueDate,),
              TextFormField(
                controller: dateController,
                readOnly: true,
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  //print('type');
                  //print(selectedDate.runtimeType);
                    var splitDate = selectedDate.toString().split(' ')[0];
                    setState(() {
                      dateController.text = splitDate;
                      dueDate = splitDate;
                    });
                    print('duedate = $dueDate');

                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Due date',
                  suffixIcon: Icon(Icons.calendar_month_rounded),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.lightBlueAccent,
                    width: 2.0,
                  )),
                ),
                //controller: myController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                      value: boxTitle == Constants().add
                          ? Constants().add
                          : 'Edit',
                      //isEnabled: enable,
                      isEnabled: true,
                      pressed: boxTitle == Constants().add
                          ? onAdd
                          : () => onEditClick(id!, taskDetails!)),
                  Button(value: 'Cancel',
                      isEnabled: true,
                      pressed: onCancel),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  onAdd() async {

    Firestore().addTask(myController.text, dateController.text).then((res) =>
        Fluttertoast.showToast(
            msg: "Task added successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            webPosition: "center",
            fontSize: 16.0));

    myController.clear();
    dateController.clear();
    Navigator.of(context).pop();
  }

  void onCancel() {
    myController.clear();
    dateController.clear();
    Navigator.of(context).pop();
  }

  void checkBoxClicked(
      bool? val, int index, String id, Task taskDetails) async {

    taskDetails.isChecked = !taskDetails.isChecked;
    Firestore()
        .clickOnTask(id, taskDetails)
        .then((value) => print('checkbox having id = $id is clicked '));
  }

  void onDelete(int index, String id) async {

    await Firestore().deleteTaskFromDb(id).then((value) =>
        Fluttertoast.showToast(
            msg: "Task deleted successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            webPosition: "center",
            fontSize: 16.0));
  }

  void onEdit(String str, int index, Task taskDetails) async {
    setState(() {
      myController.text = taskDetails.title;
      dateController.text = taskDetails.taskDueDate;
    });

    addTask(str, taskDetails: taskDetails, id: taskDetails.id);
  }

  onEditClick(String id, Task taskDetails) async {
    //print('onedit cliecked call ');
    try {
      //var tList = await LocalStorage().editTask(index, myController.text);
      // setState(() {
      //   updatedTaskList = tList;
      // });
      taskDetails.title = myController.text;
      taskDetails.taskDueDate = dateController.text;

      await Firestore().editTaskInDb(id, taskDetails).then((value) => {
            Fluttertoast.showToast(
                msg: "Task edited successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                webPosition: "center",
                fontSize: 16.0),
            myController.clear(),
            dateController.clear(),
            Navigator.of(context).pop(),
          });
    } catch (err) {
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
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: const Text('TaskEase'),
          elevation: 10,
          automaticallyImplyLeading: false,
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.blue,
                  size: 50,
                ),
              );
            }

            //snapshot.data!.docs.isEmpty is important
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No tasks pending.'));
            }

            var tasks;
            //List<String> taskDate = [];
            tasks = snapshot.data!.docs.map((DocumentSnapshot document) {
              // var task = document.data() as Map<String, dynamic>;
              // List<String> dateTimeParts = task['time'].split(' ');
              // taskDate.add(dateTimeParts[0]);
              return Task.fromJson(document.data() as Map<String, dynamic>);
            }).toList();


            //tasks.sort((a, b) => DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch));
            tasks.sort((a, b) => DateTime.parse(a.taskDueDate).millisecondsSinceEpoch.compareTo(DateTime.parse(b.taskDueDate).millisecondsSinceEpoch));


            return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  Task task = tasks[index];
                  return TodoTile(
                    taskName: task.title,
                    checked: task.isChecked,
                    createdDate: task.createdAt,
                    date: task.taskDueDate,
                    onClick: (val) =>
                        checkBoxClicked(val, index, task.id, task),
                        onDelete: (context) => onDelete(index, task.id),
                        onEdit: (context) => onEdit('Edit', index, task),
                  );
                });
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

// Widget datePicker() {
//   return (
//
//   );
// }
