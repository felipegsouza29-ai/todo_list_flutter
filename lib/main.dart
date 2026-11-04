import 'package:flutter/material.dart';
import 'package:todo_list_flutter/widgets/task_input.dart';
import 'widgets/task_filter.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Tarefas'),
        ),
        body: const Center(
          child: Text('Minhas tarefas apareceção aqui !!!'),
          ),
          bottomNavigationBar: TaskInput(
            selectedDate: DateTime.now(),
            onAdd: (title, date){
              debugPrint('tarefa: $title');
              debugPrint('Data: $date');
            }
            ),
      ),
    );
  }
}