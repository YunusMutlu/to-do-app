import 'package:flutter/material.dart';
import 'package:to_do/to_do_attributes.dart';
import 'package:to_do/to_do_lists.dart';
import 'settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cardTheme: CardThemeData(
          color: _isDarkMode ? Colors.grey[850] : Colors.white,
          shadowColor: _isDarkMode ? Colors.black54 : Colors.grey[300],
        ),
        listTileTheme: ListTileThemeData(
          tileColor: _isDarkMode ? Colors.grey[800] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: _isDarkMode
              ? Colors.grey[900]
              : const Color(0xFFE0FFFF),
          selectedItemColor: _isDarkMode
              ? const Color(0xFF6C63FF)
              : Colors.cyan,
          unselectedItemColor: _isDarkMode ? Colors.white70 : Colors.black54,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: _isDarkMode ? Colors.blueGrey : Colors.cyan,
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        ),
        primaryColor: _isDarkMode
            ? const Color.fromARGB(255, 5, 7, 8)
            : const Color(0xFF00FFFF),
        scaffoldBackgroundColor: _isDarkMode
            ? Colors.black
            : const Color(0xFFE0FFFF),
        appBarTheme: AppBarTheme(
          backgroundColor: _isDarkMode
              ? const Color.fromARGB(255, 6, 9, 10)
              : const Color.fromARGB(136, 0, 206, 209),
        ),
      ),
      title: 'Flutter Demo',
      home: HomePage(isDarkMode: _isDarkMode, onThemeChanged: _toggleTheme),
    );
  }
}

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final void Function(bool)? onThemeChanged;
  const HomePage({super.key, this.isDarkMode = false, this.onThemeChanged});

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
              decoration: const InputDecoration(
                hintText: 'Enter list name',
                border: OutlineInputBorder(),
                label: Text('List Name'),
              ),
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
        onTap: (value) {
          switch (value) {
            case 0:
              break;
            case 1:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Settings(
                    isDarkMode: widget.isDarkMode,
                    onThemeChanged: widget.onThemeChanged,
                  ),
                ),
              );
              break;
          }
        },
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
