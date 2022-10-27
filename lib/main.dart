import 'package:flutter/material.dart';
import 'data/todo_db.dart';
import 'data/todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos BLoC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future _testData() async {
    TodoDb db = TodoDb();
    await db.database;
    List<Todo> todos = await db.getTodos();
    await db.deleteAll();
    todos = await db.getTodos();
    print(todos);
    await db.insertTodo(
      Todo('Call Donald', 'And tell him about Daisy', '02/02/2020', 1),
    );
    await db.insertTodo(
      Todo('Buy Sugar', '1 kg brown', '02/02/2024', 1),
    );
    await db.insertTodo(
      Todo('Go Running', '@7AM', '02/02/2022', 1),
    );
    todos = await db.getTodos();
    debugPrint('First insert');
    todos.forEach((Todo todo) {
      debugPrint(todo.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    _testData();
    return Container();
  }
}
