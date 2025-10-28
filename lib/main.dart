import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Ẩn banner "Debug"
      debugShowCheckedModeBanner: false,
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoListScreen(),
    );
  }
}

// Đây sẽ là màn hình chính của ứng dụng To-Do
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<String> _todos = [];

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  void _addTodoItem() {
    setState(() {
      if (_textFieldController.text.isNotEmpty) {
        _todos.add(_textFieldController.text);
        _textFieldController.clear();
      }
    });
  }

  // 1. TẠO PHƯƠNG THỨC XÓA MỚI
  // Phương thức này nhận vào `index` của công việc cần xóa.
  void _deleteTodoItem(int index) {
    setState(() {
      // Xóa công việc khỏi danh sách tại vị trí index
      _todos.removeAt(index);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Công Việc'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textFieldController,
                    decoration: const InputDecoration(
                      labelText: 'Thêm công việc mới...',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _addTodoItem,
                  child: const Text('Thêm'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                // 2. CẬP NHẬT Lại ListTile
                return ListTile(
                  title: Text(_todos[index]),
                  // Thêm một IconButton vào cuối mỗi dòng
                  trailing: IconButton(
                    // Biểu tượng thùng rác
                    icon: const Icon(Icons.delete),
                    // Khi nhấn vào, gọi hàm xóa và truyền vào index hiện tại
                    onPressed: () => _deleteTodoItem(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
