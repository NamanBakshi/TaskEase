import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/components/button.dart';
import 'package:todo/components/todoTile.dart';
import 'package:todo/model/task.dart';
import 'package:todo/services/local_storage.dart';
import 'package:todo/utils/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  dynamic dataFromDb;
  List<Task>? updatedTaskList = [];

  @override
  void initState() {
    super.initState();
    _savedData();
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
                      pressed: boxTitle == Constants().add
                          ? onAdd
                          : () => onEditClick(index!)),
                  Button(value: 'Cancel', pressed: onCancel),
                ],
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(() => {myController.clear()});
  }

  onAdd() async {

    var length = updatedTaskList?.length ?? 0;

    Task newTask = Task(
        id: (length + 1).toString(),
        title: myController.text,
        isChecked: false);

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

  @override
  void dispose() {
    // TODO: implement dispose
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
          : ListView.builder(
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          addTask(Constants().add),
          //getTasks()
          //fetchData()
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
