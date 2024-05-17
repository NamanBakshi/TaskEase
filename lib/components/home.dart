import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/components/button.dart';
import 'package:todo/components/todoTile.dart';
import 'package:todo/model/task.dart';
import 'package:todo/services/firestore.dart';
import 'package:todo/services/local_storage.dart';
import 'package:todo/utils/constants.dart';
import 'package:uuid/uuid.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  dynamic dataFromDb;
  List<Task>? updatedTaskList = [];
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _savedData();
    //final variable =_firestore.collection('tasks').doc(_auth.currentUser?.uid);
    //print('user tasks = $variable');



  }

  _savedData() async {
    var tList = await LocalStorage().getBoxData() ?? [];
    print("tList List :: ${tList}");

    setState(() {
      updatedTaskList = tList;
    });

  }

  String taskName = '';
  final TextEditingController myController = TextEditingController();

  addTask(String boxTitle, {int? index}) {
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
                          : () => onEditClick(index!)),
                  Button(value: 'Cancel', isEnabled: true ,pressed: onCancel),
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

    setState(() {
      updatedTaskList?.add(newTask);
      myController.clear();
    });

    LocalStorage().saveTask(updatedTaskList!);

    int? len = updatedTaskList?.length;
    print('total tasks = $len');
    Navigator.of(context).pop();
  }

  void onCancel() {
    myController.clear();
    Navigator.of(context).pop();
  }

  void checkBoxClicked(bool? val, int index) async {
    //print('index = $index');
    var updatedData=await LocalStorage().updateCheckbox(index);

    setState(() {
      updatedTaskList= updatedData;
    });

  }

  void onDelete(int index) async {
    var updatedData=await LocalStorage().deleteTask(index);

    setState(() {
      updatedTaskList=updatedData;
    });
  }

  void onEdit(String str, int index) async {

    setState(() {
      myController.text =  updatedTaskList![index].title;
    });

    addTask(str, index: index);
  }

  void onEditClick(int index) async {

    var tList = await LocalStorage().editTask(index, myController.text);
    setState(() {
      updatedTaskList=tList;
    });

    myController.clear();
    Navigator.of(context).pop();
  }

   _getAllTasks(dynamic snapshot) async {
     var dbList= await Firestore().getTasks(snapshot) ;
     List<Task> newList=[];

    print('data $dbList');

    for(Task t in dbList){
      newList.add(t);
    }
    setState(() {
    updatedTaskList=newList;
     });
    //return data;
  }

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
      ),
      body: updatedTaskList!.isEmpty
          ? const Center(
              child: Text(
                'No pending tasks',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
            stream: Firestore().stream(),
            builder: (context, snapshot) {
              //List<Task?> allTasks;
              if(!snapshot.hasData){
                return const CircularProgressIndicator();
              }else{
                //List<Task>? dbList =
                _getAllTasks(snapshot);
                //List<Task>? newList=[];

              }
              //var allTasks = Firestore().getTasks(snapshot);

              return ListView.builder(
                itemCount: updatedTaskList?.length,
                itemBuilder: (context, index) {
                  return TodoTile(
                    taskName: updatedTaskList![index].title,
                    checked: updatedTaskList![index].isChecked,
                    onClick: (val) => checkBoxClicked(val, index),
                    onDelete: (context) => onDelete(index),
                    onEdit: (context) => onEdit('Edit', index),
                  );
                },
              );
                // ListView.builder(
                //   //itemCount: updatedTaskList?.length,
                //   itemBuilder: (context, index) {
                //     return TodoTile(
                //       taskName: updatedTaskList![index].title,
                //       checked: updatedTaskList![index].isChecked,
                //       onClick: (val) => checkBoxClicked(val, index),
                //       onDelete: (context) => onDelete(index),
                //       onEdit: (context) => onEdit('Edit', index),
                //     );
                //   },
                // );
            }
          ),
      floatingActionButton: FloatingActionButton.extended(heroTag: const {
        // onPressed: () =>
        // {
        //   addTask(Constants().add),
        //   //getTasks()
        //   //fetchData()
        // },
        //child: const Icon(Icons.add),
      }, onPressed: () {
        addTask(
            Constants().add);
        },
        label: const Row(
          children: [
            Icon(Icons.add),
            SizedBox(width:10),
            Text('Add Task')
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
