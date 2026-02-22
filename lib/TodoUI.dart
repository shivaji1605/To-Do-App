import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/todomodel.dart';
import 'package:todoapp/todo_db.dart';
import 'dart:developer';

class ToDoUiScreen extends StatefulWidget {
  const ToDoUiScreen({super.key});

  @override
  State createState() => _ToDoUiScreenState();
}

class _ToDoUiScreenState extends State<ToDoUiScreen> {
  
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  
  void clearController() {
    titleController.clear();
    descController.clear();
    dateController.clear();
  }

  List<Color> colorList = [
    const Color.fromRGBO(239, 209, 209, 1),
    const Color.fromRGBO(231, 231, 187, 1),
    const Color.fromRGBO(131, 204, 138, 1),
    const Color.fromRGBO(171, 159, 237, 1),
  ];

  List<ToDoModel> ToDoCards = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    List<Map> cardList = await ToDoDatabase().getTodoItems();
    log("CARD LIST:$cardList");
    for (var element in cardList) {
      ToDoCards.add(
        ToDoModel(
          title: element['title'],
          description: element['description'],
          date: element['date'],
          id: element['id'],
        ),
      );
    }
    setState(() {});
  }


  void submit(bool doEdit, [ToDoModel? obj]) {
    if (titleController.text.isNotEmpty &&
        descController.text.isNotEmpty &&
        dateController.text.isNotEmpty) {
      if (doEdit) {
        obj!.title = titleController.text;
        obj.description = descController.text;
        obj.date = dateController.text;

        Map<String, dynamic> mapObj = {
          'title': obj.title,
          'description': obj.description,
          'date': obj.date,
          'id': obj.id,
        };
        ToDoDatabase().updateTodoItem(mapObj);
      } else {
        ToDoCards.add(
          ToDoModel(
            title: titleController.text,
            description: descController.text,
            date: dateController.text,
          ),
        );

        Map<String, dynamic> datamap = {
          'title': titleController.text,
          'description': descController.text,
          'date': dateController.text,
        };

        ToDoDatabase().insertTodoItem(datamap);
      }
      clearController();
      Navigator.of(context).pop(); 
      setState(() {});
    }
  }

  showBottomSheet(bool doEdit, [ToDoModel? obj]) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add ToDo Task:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Title:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  focusColor: Colors.red,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "Enter Title",
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Description:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "Enter Description",
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Date:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              TextField(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2026),
                    initialDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    String strDate = DateFormat.yMMMd().format(pickedDate);
                    dateController.text = strDate;
                  }
                },
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "Select Date",
                  suffixIcon: const Icon(Icons.calendar_month_outlined),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (doEdit) {
                    submit(true, obj);
                  } else {
                    submit(false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 2, 167, 177),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "To-Do App",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 2, 167, 177),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: ToDoCards.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: colorList[index % colorList.length],
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            "assets/images/todoicon.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ToDoCards[index].title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              ToDoCards[index].description,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        ToDoCards[index].date,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          titleController.text = ToDoCards[index].title;
                          descController.text = ToDoCards[index].description;
                          dateController.text = ToDoCards[index].date;
                          showBottomSheet(true, ToDoCards[index]);
                        },
                        child: const Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 2, 167, 177),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          int id = ToDoCards[index].id;
                          ToDoCards.removeAt(index);
                          ToDoDatabase().deleteTodoItem(id);
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 2, 167, 177),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(false);
        },
        backgroundColor: const Color.fromARGB(255, 2, 167, 177),
        child: const Icon(Icons.add, color: Colors.white, size: 40),
      ),
    );
  }
}
