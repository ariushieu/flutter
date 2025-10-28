import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import gói phông chữ

// BƯỚC 1: TẠO MỘT LỚP (MODEL) ĐỂ BIỂU DIỄN MỘT CÔNG VIỆC
// Điều này giúp quản lý dễ dàng hơn là chỉ dùng một String.
class Todo {
  String task;
  bool isCompleted;

  Todo({
    required this.task,
    this.isCompleted = false,
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      // BƯỚC 2: NÂNG CẤP THEME
      theme: ThemeData(
        // Sử dụng Material 3 để có giao diện hiện đại
        useMaterial3: true,
        // Tạo một bảng màu hài hòa từ một màu gốc
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // Sử dụng phông chữ từ Google Fonts cho toàn bộ ứng dụng
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: Colors.grey[100], // Nền hơi xám
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _textFieldController = TextEditingController();
  // BƯỚC 3: SỬ DỤNG DANH SÁCH ĐỐI TƯỢNG Todo
  final List<Todo> _todos = [];

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  void _addTodoItem() {
    if (_textFieldController.text.isNotEmpty) {
      setState(() {
        _todos.add(Todo(task: _textFieldController.text));
        _textFieldController.clear();
      });
    }
  }

  void _deleteTodoItem(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  // Phương thức để thay đổi trạng thái hoàn thành
  void _toggleTodoStatus(int index) {
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
  }

  Future<void> _showEditDialog(int index) async {
    final TextEditingController editController =
        TextEditingController(text: _todos[index].task);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sửa công việc'),
          content: TextField(
            controller: editController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Nhập nội dung mới'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Lưu'),
              onPressed: () {
                if (editController.text.isNotEmpty) {
                  setState(() {
                    _todos[index].task = editController.text;
                  });
                  Navigator.of(context).pop();
                }
              },
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
        title: const Text('Todo App'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          // BƯỚC 4: ĐẶT PHẦN NHẬP LIỆU VÀO MỘT CARD
          Card(
            margin: const EdgeInsets.all(12.0),
            elevation: 4.0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textFieldController,
                      decoration: const InputDecoration(
                        hintText: 'Thêm một công việc mới...',
                        border: InputBorder.none, // Bỏ đường viền
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Nút bấm có icon thay vì text
                  IconButton.filled(
                    icon: const Icon(Icons.add),
                    onPressed: _addTodoItem,
                    tooltip: 'Thêm công việc',
                  ),
                ],
              ),
            ),
          ),
          // BƯỚC 5: HIỂN THỊ DANH SÁCH HOẶC THÔNG BÁO TRẠNG THÁI TRỐNG
          Expanded(
            child: _todos.isEmpty
                // Nếu danh sách trống, hiển thị thông báo
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tất cả công việc đã hoàn tất!',
                          style: TextStyle(
                              fontSize: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                // Nếu không, hiển thị ListView
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final todo = _todos[index];
                      // BƯỚC 6: DÙNG CARD CHO MỖI CÔNG VIỆC
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 4.0),
                        elevation: 2.0,
                        child: ListTile(
                          // Checkbox ở đầu dòng
                          leading: Checkbox(
                            value: todo.isCompleted,
                            onChanged: (bool? value) {
                              _toggleTodoStatus(index);
                            },
                          ),
                          // Nội dung công việc
                          title: Text(
                            todo.task,
                            // Thêm hiệu ứng gạch ngang nếu đã hoàn thành
                            style: TextStyle(
                              decoration: todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: todo.isCompleted ? Colors.grey : null,
                            ),
                          ),
                          // Các nút hành động
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: Colors.blue.shade600),
                                onPressed: () => _showEditDialog(index),
                                tooltip: 'Sửa',
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.red.shade600),
                                onPressed: () => _deleteTodoItem(index),
                                tooltip: 'Xóa',
                              ),
                            ],
                          ),
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
