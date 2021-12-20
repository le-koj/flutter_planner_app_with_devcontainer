import 'package:flutter/material.dart';
import 'package:planner_app/custom_widgets/horizontal_day_list.dart';
import 'package:planner_app/custom_widgets/todo_grid_view.dart';
import 'package:planner_app/custom_widgets/todo_information_popup.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<String> dayDependentTodos = [];

  List<String> todoInformation = [
    "MON, TEST1, TEST1",
    "WED, TEST2, TEST2",
    "SUN, TEST3, TEST3",
    "WED, TEST4, TEST4",
    "FRI, TEST5, TEST5",
    "THU, TEST6, TEST6",
    "MON, TEST7, TEST7"
  ];

  String weekday = "";

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      value,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.redAccent),
    )));
  }

  void changeWeekday(String newDay) {
    setState(() {
      weekday = newDay;
    });
    print("changed, $weekday");
    updateList();
  }

  void updateList() {
    dayDependentTodos.clear();
    for (int i = 0; i < todoInformation.length; i++) {
      if (todoInformation[i].split(",")[0] == weekday) {
        dayDependentTodos.add(todoInformation[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0.0,
        title: const Text("MY TODOS"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          HorizontalDayList(
            dayUpdateFunction: changeWeekday,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [BoxShadow(blurRadius: 10.0)]),
              child: TodoGridView(
                todoList: dayDependentTodos,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return TodoInformationPopup(
                  titleController: titleController,
                  descriptionController: descriptionController,
                );
              }).then((value) {
            setState(() {
              if (descriptionController.text == "" ||
                  titleController.text == "") {
                showInSnackBar("Title or description can't be empty!");
              } else {
                todoInformation.add(
                    "$weekday,${titleController.text},${descriptionController.text}");
                updateList();
                titleController.clear();
                descriptionController.clear();
              }
            });
          });
        },
        splashColor: Colors.deepPurple,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(
          Icons.add,
          size: 50,
        ),
      ),
    );
  }
}
