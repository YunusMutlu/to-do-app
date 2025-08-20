import 'package:flutter/material.dart';
import 'package:to_do/to_do_attributes.dart';
import 'package:to_do/to_do_lists.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, List<ToDoAttributes>> _toDoLists = {};
  final TextEditingController _listNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _createNewToDoList() {
    listsAddDialog();
  }

  void listsAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New To-Do List'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _listNameController,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a list name' : null,
              decoration: const InputDecoration(hintText: 'Enter list name'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _toDoLists[_listNameController.text] = [];
                  });
                  _formKey.currentState!.reset();
                  _listNameController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('To-Do Lists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _createNewToDoList();
            },
          ),
        ],
      ),
      body: Center(child: ToDoLists(_toDoLists)),
    );
  }
}
