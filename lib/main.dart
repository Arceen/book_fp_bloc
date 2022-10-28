import 'package:flutter/material.dart';
import 'bloc/todo_bloc.dart';
import 'data/todo_db.dart';
import 'data/todo.dart';
import 'screens/todo_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos BLoC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
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
  late TodoBloc todoBloc;
  List<Todo>? todos;

  @override
  void initState() {
    todoBloc = TodoBloc();

    todos = todoBloc.todoList;
    print(todos);
    super.initState();
  }

  @override
  void dispose() {
    todoBloc.dispose();
    super.dispose();
  }

  Future _testData() async {
    TodoDb db = TodoDb();
    await db.database;
    List<Todo> todos = await db.getTodos();
    print(todos);
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
    Todo todo = Todo('', '', '', 0);
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Container(
        child: StreamBuilder<List<Todo>>(
          initialData: todos,
          stream: todoBloc.todos,
          builder: ((context, snapshot) => ListView.builder(
                itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                itemBuilder: (context, index) => Dismissible(
                  key: Key(snapshot.data![index].id.toString()),
                  onDismissed: (_) =>
                      todoBloc.todoDeleteSink.add(snapshot.data![index]),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).highlightColor,
                      child: Text("${snapshot.data![index].priority}"),
                    ),
                    title: Text(snapshot.data![index].name),
                    subtitle: Text(snapshot.data![index].description),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) =>
                                TodoScreen(snapshot.data![index], false))));
                      },
                      icon: Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TodoScreen(todo, true),
              ),
            );
          }),
    );
  }
}
