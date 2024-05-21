import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  String dueDate;
  DatePicker({super.key,required this.dueDate});


  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {

  final TextEditingController dateController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateController,
      readOnly: true,
      onTap: ()async{
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2024),
          lastDate: DateTime(2100),
        );
        var splitDate=selectedDate.toString().split(' ')[0];
        setState(() {
         dateController.text=selectedDate as String;
          widget.dueDate=splitDate;
        });

      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Due date',
        suffixIcon: Icon(Icons.calendar_month_rounded),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.lightBlueAccent,
              width: 2.0,
            )
        ),
      ),
      //controller: myController,
    );
  }
}



// class DatePicker extends StatelessWidget {
//   const DatePicker({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       readOnly: true,
//       onTap: ()async{
//         final selectedDate = await showDatePicker(
//             context: context,
//             initialDate: DateTime.now(),
//             firstDate: DateTime(2024),
//             lastDate: DateTime(2100),
//         );
//         var splitDate=selectedDate.toString().split(' ')[0];
//         print('datee = $splitDate');
//       },
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(),
//         labelText: 'Due date',
//         suffixIcon: Icon(Icons.calendar_month_rounded),
//         focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.lightBlueAccent,
//               width: 2.0,
//             )
//         ),
//       ),
//       //controller: myController,
//     );
//   }
// }
