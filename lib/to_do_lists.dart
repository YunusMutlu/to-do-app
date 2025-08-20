import 'package:flutter/material.dart';
import 'package:to_do/to_do_attributes.dart';
import 'package:to_do/to_do_listdetailpage.dart';

class ToDoLists extends StatefulWidget {
  final Map<String, List<ToDoAttributes>> toDoLists;

  const ToDoLists(this.toDoLists, {super.key});

  @override
  State<ToDoLists> createState() => _ToDoListsState();
}

class _ToDoListsState extends State<ToDoLists> {
  final TextEditingController _positionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void _goSelectedList(String listName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ToDoListDetailPage(
          listName: listName,
          tasks: widget.toDoLists[listName]!,
        ),
      ),
    );
  }

  void _adjustListOrder(String listName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adjust List name'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a new name';
                } else if (widget.toDoLists.containsKey(value)) {
                  return 'List name already exists choose different name';
                }
                return null;
              },
              controller: _positionController,
              decoration: InputDecoration(
                labelText: 'New name for $listName',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  setState(() {
                    String newName = _positionController.text;
                    List<ToDoAttributes> tasks = widget.toDoLists[listName]!;
                    widget.toDoLists.remove(listName);
                    widget.toDoLists[newName] = tasks;
                  });
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.toDoLists.length,
      itemBuilder: (context, index) {
        String listName = widget.toDoLists.keys.elementAt(index);
        return Dismissible(
          key: Key(listName),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          background: Container(
            color: Colors.amber,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20.0),
            child: const Icon(Icons.edit, color: Colors.white),
          ),
          onDismissed: (direction) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$listName dismissed')));
          },
          confirmDismiss: (direction) {
            if (direction == DismissDirection.endToStart) {
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: Text('Are you sure you want to delete $listName?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            widget.toDoLists.remove(listName);
                          });
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            } else if (direction == DismissDirection.startToEnd) {
              _adjustListOrder(listName);
            }
            return Future.value(false);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),

            child: ListTile(
              leading: const Icon(Icons.list),
              title: Text(listName),
              onTap: () {
                _goSelectedList(listName);
              },
            ),
          ),
        );
      },
    );
  }
}
