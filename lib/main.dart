import 'package:flutter/material.dart';
import 'package:hackingwithflutterprojectapp/models/todo_model.dart';

void main() {
  runApp(TodoList());
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _controller = TextEditingController();
  final List<TodoModel> todos = [];
  bool isloading = false;
  String? error;

  Future<void> addTodo() async {
    if (_controller.text.isEmpty) {
      setState(() => error = 'Please enter a title for the todo item.');
      return;
    }
    setState(() {
      isloading = true;
      error = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        todos.add(
          TodoModel(
            title: _controller.text,
            id: DateTime.now().toString(),
            completed: false,
          ),
        );
        _controller.clear();
        isloading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to add todo item. Please try again.';
        isloading = false;
      });
    }
  }

  void _toggleTodoCompletion(String id) {
    setState(() {
      final todo = todos.firstWhere((todo) => todo.id == id);
      todo.completed = !todo.completed!;
    });
  }

  void _deleteTodo(String id) {
    setState(() {
      todos.removeWhere((todo) => todo.id == id);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: 'Enter a new todo item',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isloading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: addTodo,
                        child: const Text('Add'),
                      ),
                  ],
                ),
              ),
          
          
              Expanded(
                child: ListView.builder(
                
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return ListTile(
                      title: Text(todo.title ?? ''),
                      leading: Checkbox(
                        value: todo.completed,
                        onChanged: (bool? value) {
                          _toggleTodoCompletion(todo.id ?? '');
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTodo(todo.id ?? ''),
                      ),
                    );
                  },
                ),
              ),
              
            ],
          ),
        ),
        
      ),
    );
  }
}


