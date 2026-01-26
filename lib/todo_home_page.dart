import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isolapp/todo_model.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  static Future<void> main() async {
    return Future<void>(() async {
      await Hive.initFlutter();
      Hive.registerAdapter(TodoAdapter());
      await Hive.openBox<Todo>('todos');      
    },);
  }

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  late Box<Todo> todosBox;
  List<Todo> todosList = [];
  bool isLoading = true;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    todosBox = Hive.box<Todo>('todos');
    loadTodos();
  }

  /// Loads todos from the Hive box and stores it in todosList.
  Future<void> loadTodos() async {
    setState(() {
      isLoading = true;
    });
    todosList = todosBox.values.toList();
    setState(() {
      isLoading = false;
    });
  }

  /// Adds a new todo to the Hive box and updates the todosList.
  Future<void> addTodo({required Todo todo}) async {
    try {
      await todosBox.add(todo);
      setState(() {
        todosList.add(todo);
      });
      debugPrint('${todo.title} added successfully');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  /// Deletes a todo from the Hive box and updates the todosList.
  Future<void> deleteTodo(int index) async {
    try {
      await todosBox.deleteAt(index);
      setState(() {
        todosList.removeAt(index);
      });

      debugPrint('Todo Removed Successfully');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  /// Changes the completion status of a todo and updates the todosList.
  Future<void> changeCompletionStatus(int index, {required bool value}) async {
    try {
      Todo todo = todosBox.getAt(index)!;
      todo.isDone = value;
      await todosBox.putAt(index, todo);
      setState(() {
        todosList[index] = todo;
      });
      debugPrint('${todo.title} marked ${value ? 'complete' : 'incomplete'}');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : todosList.isEmpty
          ? const Center(child: Text("No Todos Created"))
          : ListView.builder(
              shrinkWrap: true,
              itemCount: todosList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    todosList[index].title,
                    style: TextStyle(
                      decoration: todosList[index].isDone
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Text(
                    todosList[index].description,
                    style: TextStyle(
                      decoration: todosList[index].isDone
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  leading: Checkbox(
                    value: todosList[index].isDone,
                    onChanged: (value) {
                      changeCompletionStatus(
                        index,
                        value: !todosList[index].isDone,
                      );
                    },
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      await deleteTodo(index);
                    },
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.redAccent,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: const Text("Create a Todo"),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                children: [
                  Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Title"),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Description"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(widget);
                        },
                        child: const Text("CANCEL"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_titleController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(milliseconds: 200),
                                content: Text("Title cannot be empty"),
                              ),
                            );
                          } else {
                            addTodo(
                              todo: Todo(
                                title: _titleController.text,
                                description: _descriptionController.text,
                              ),
                            ).then((_) {
                              _titleController.clear();
                              _descriptionController.clear();
                            });
                          }
                          Navigator.of(context).pop();
                        },
                        child: const Text("ADD"),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
