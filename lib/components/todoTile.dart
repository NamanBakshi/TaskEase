import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../model/task.dart';

class TodoTile extends StatelessWidget {
  final String taskName;
  final bool checked;
  final String createdDate;
  Function(bool?)? onClick;
  Function(BuildContext)? onDelete;
  Function(BuildContext)? onEdit;

  //const TodoTile({super.key, required this.taskName, required this.checked});
  TodoTile({
    super.key,
    required this.taskName,
    required this.checked,
    required this.onClick,
    required this.onEdit,
    required this.onDelete,
    required this.createdDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: onEdit,
              backgroundColor: Colors.grey.shade400,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: onDelete,
              backgroundColor: Colors.red.shade300,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child:
          Row(children: [
            Checkbox(
              value: checked,
              onChanged: onClick,
              activeColor: Colors.black,
              splashRadius: 0,
            ),
            const SizedBox(width: 30),
            Text(
              taskName,
              style: TextStyle(
                fontSize: 16,
                decoration:
                    checked ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
            const Spacer(),
            Column(
              children: [
                const Text('Created at :',
                    style: TextStyle(
                      fontSize: 14,
                    )),
                Text(
                  createdDate,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
