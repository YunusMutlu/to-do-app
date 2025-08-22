import 'package:flutter/material.dart';
import 'package:to_do/to_do_attributes.dart';

class ToDoListDetailPage extends StatefulWidget {
  const ToDoListDetailPage({
    required this.listName,
    required this.tasks,
    super.key,
  });
  final String listName;
  final List<ToDoAttributes> tasks;
  @override
  State<ToDoListDetailPage> createState() => _ToDoListDetailPageState();
}

class _ToDoListDetailPageState extends State<ToDoListDetailPage> {
  final TextEditingController _taskController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a task name';
                } else if (widget.tasks.any((task) => task.title == value)) {
                  return 'Task already exists';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _taskController,
              decoration: const InputDecoration(
                hintText: 'Enter task name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    widget.tasks.add(
                      ToDoAttributes(title: _taskController.text),
                    );
                    _taskController.clear();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _adjustTask(ToDoAttributes task) {
    _taskController.text = task.title;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a task name';
                } else if (widget.tasks.any((task) => task.title == value)) {
                  return 'Task already exists';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _taskController,
              decoration: const InputDecoration(
                hintText: 'Edit task name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    task.title = _taskController.text;
                  });
                  _taskController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listName),
        actions: [
          IconButton(
            onPressed: () {
              _addTask();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(widget.tasks[index].title),
            onDismissed: (direction) {
              setState(() {
                widget.tasks.removeAt(index);
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Task dismissed')));
            },
            confirmDismiss: (direction) {
              if (direction == DismissDirection.endToStart) {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: Text(
                        'Are you sure you want to delete "${widget.tasks[index].title}"?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              } else if (direction == DismissDirection.startToEnd) {
                _adjustTask(widget.tasks[index]);
              }
              return Future.value(false);
            },
            background: Container(
              color: Colors.amber,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20.0),
              child: const Icon(Icons.edit, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),

              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                tileColor: widget.tasks[index].isDone
                    ? Colors.green.withAlpha(128)
                    : null,
                title: widget.tasks[index].isDone
                    ? Text(
                        widget.tasks[index].title,
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      )
                    : Text(widget.tasks[index].title),
                leading: Checkbox(
                  value: widget.tasks[index].isDone,
                  onChanged: (value) {
                    setState(() {
                      widget.tasks[index].isDone = value!;
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
