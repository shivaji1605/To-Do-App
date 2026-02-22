import 'package:flutter/material.dart';
import 'package:todoapp/TodoUI.dart';
void main(){
  runApp(mainApp());
}

class mainApp extends StatelessWidget{
    mainApp({super.key});
    @override

    Widget build(BuildContext){
      return MaterialApp(
        home: ToDoUiScreen(),
      );
    }
}