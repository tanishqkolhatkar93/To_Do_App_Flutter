
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const DoDeckApp());

class DoDeckApp extends StatelessWidget {
  const DoDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoDeck - Smart To-Do',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const HomeScreen(),
    );
  }
}

class Task {
  String title;
  String description;
  DateTime? dueDate;

  Task({required this.title, required this.description, this.dueDate});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  List<Task> todoList = [];
  DateTime? selectedDate;
  int updateIndex = -1;

  void _addOrUpdateTask() {
    if (_titleController.text.trim().isEmpty) return;
    if (updateIndex == -1) {
      setState(() {
        todoList.add(Task(
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          dueDate: selectedDate,
        ));
      });
    } else {
      setState(() {
        todoList[updateIndex].title = _titleController.text.trim();
        todoList[updateIndex].description = _descController.text.trim();
        todoList[updateIndex].dueDate = selectedDate;
        updateIndex = -1;
      });
    }
    _titleController.clear();
    _descController.clear();
    selectedDate = null;
  }

  void _deleteTask(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  void _editTask(int index) {
    final task = todoList[index];
    setState(() {
      _titleController.text = task.title;
      _descController.text = task.description;
      selectedDate = task.dueDate;
      updateIndex = index;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff6A5AE0), Color(0xff8E8AFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "DoDeck Tasks",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // TASK LIST SECTION
          Expanded(
            child: todoList.isEmpty
                ? const Center(
              child: Text(
                "✨ No tasks yet — Add one below!",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                final task = todoList[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff6A5AE0), Color(0xff8E8AFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (task.description.isNotEmpty)
                                Text(
                                  task.description,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              if (task.dueDate != null)
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 16, color: Colors.white),
                                    const SizedBox(width: 5),
                                    Text(
                                      DateFormat('dd MMM yyyy')
                                          .format(task.dueDate!),
                                      style: const TextStyle(
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () => _editTask(index),
                              icon: const Icon(Icons.edit,
                                  color: Colors.white),
                            ),
                            IconButton(
                              onPressed: () => _deleteTask(index),
                              icon: const Icon(Icons.delete,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ADD TASK SECTION (Fixed bottom panel)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, -2))
              ],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Task Title',
                    prefixIcon:
                    const Icon(Icons.title, color: Color(0xff6A5AE0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon:
                    const Icon(Icons.description, color: Color(0xff6A5AE0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? 'No date selected'
                            : '📅 ${DateFormat('dd MMM yyyy').format(selectedDate!)}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.calendar_month,
                          color: Color(0xff6A5AE0)),
                      label: const Text('Pick Date'),
                      onPressed: _pickDate,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      updateIndex == -1 ? Icons.add : Icons.save,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff6A5AE0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    label: Text(
                      updateIndex == -1 ? "Add Task" : "Update Task",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    onPressed: _addOrUpdateTask,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
