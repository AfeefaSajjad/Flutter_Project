import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/colors.dart';
import 'task_detail_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _searchController.addListener(_filterTasks);
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', jsonEncode(_tasks));
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('tasks');

    if (tasksString != null) {
      try {
        final decoded = jsonDecode(tasksString);
        if (decoded is List) {
          setState(() {
            _tasks.addAll(decoded.map((task) {
              return {
                'id': task['id'] ?? DateTime.now().toString(),
                'task': task['task'] ?? '',
                'description': task['description'] ?? '',
                'isCompleted': task['isCompleted'] ?? false,
                'timeAdded':
                    task['timeAdded'] ?? DateTime.now().toIso8601String(),
              };
            }).toList());
            _filteredTasks = List.from(_tasks);
          });
        }
      } catch (e) {
        debugPrint('Error decoding tasks: $e');
      }
    }
  }

  void _addTask(String title, String description) {
    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Both fields are required!')),
      );
      return;
    }

    setState(() {
      final newTask = {
        'id': DateTime.now().toString(),
        'task': title,
        'description': description,
        'isCompleted': false,
        'timeAdded': DateTime.now().toIso8601String(),
      };
      _tasks.add(newTask);
      _filteredTasks = List.from(_tasks);
    });
    _saveTasks();
  }

  void _showAddTaskDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String errorText = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: const TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14,
                      ),
                      hintText: 'Enter task title',
                      hintStyle: const TextStyle(
                          color: AppColors.borderColor, fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: AppColors.borderColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.primaryColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: const TextStyle(
                          color: AppColors.textColor, fontSize: 14),
                      hintText: 'Enter task description',
                      hintStyle: const TextStyle(
                          color: AppColors.borderColor, fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: AppColors.borderColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.primaryColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                  ),
                  if (errorText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        errorText,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isEmpty ||
                        descriptionController.text.isEmpty) {
                      setState(() {
                        errorText = 'Both fields are required!';
                      });
                    } else {
                      _addTask(
                          titleController.text, descriptionController.text);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.textColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Add Task',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _removeTask(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tasks.removeWhere((task) => task['id'] == id);
                  _filteredTasks = List.from(_tasks);
                });
                _saveTasks();
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task deleted successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deleteButtonColor,
                foregroundColor: AppColors.textColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _toggleCompleteTask(String id) {
    setState(() {
      final index = _tasks.indexWhere((task) => task['id'] == id);
      if (index != -1) {
        _tasks[index]['isCompleted'] = !_tasks[index]['isCompleted'];
      }
      _filteredTasks = List.from(_tasks);
    });
    _saveTasks();
  }

  void _filterTasks() {
    String searchQuery = _searchController.text.toLowerCase();
    setState(() {
      if (searchQuery.isEmpty) {
        _filteredTasks = List.from(_tasks);
      } else {
        _filteredTasks = _tasks
            .where((task) =>
                task['task'].toLowerCase().contains(searchQuery) ||
                task['description'].toLowerCase().contains(searchQuery))
            .toList();
      }
    });
  }

  void _showUpdateDialog(String id) {
    final taskIndex = _tasks.indexWhere((task) => task['id'] == id);
    if (taskIndex == -1) return; // Task not found

    final task = _tasks[taskIndex];
    final TextEditingController updateController =
        TextEditingController(text: task['task']);
    final TextEditingController descriptionController =
        TextEditingController(text: task['description']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: updateController,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  labelText: 'Task',
                  labelStyle:
                      const TextStyle(color: AppColors.textColor, fontSize: 14),
                  hintText: 'Enter updated task',
                  hintStyle: const TextStyle(
                      color: AppColors.borderColor, fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: AppColors.borderColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle:
                      const TextStyle(color: AppColors.textColor, fontSize: 14),
                  hintText: 'Enter updated description',
                  hintStyle: const TextStyle(
                      color: AppColors.borderColor, fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: AppColors.borderColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tasks[taskIndex] = {
                    ...task,
                    'task': updateController.text.isNotEmpty
                        ? updateController.text
                        : task['task'],
                    'description': descriptionController.text.isNotEmpty
                        ? descriptionController.text
                        : task['description'],
                    'timeAdded': DateTime.now().toIso8601String(),
                  };
                  _filteredTasks = List.from(_tasks);
                });
                _saveTasks();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.textColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Update Task',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    double fontSize = width * 0.045;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search tasks',
                labelStyle:
                    TextStyle(color: AppColors.textColor, fontSize: fontSize),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppColors.borderColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                final task = _filteredTasks[index];
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(task: task),
                          ),
                        );
                      },
                      title: Text(
                        task['task'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          decoration: task['isCompleted']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          fontSize: fontSize,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['description'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: fontSize * 0.8),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _formatTime(task['timeAdded']),
                            style: TextStyle(
                                fontSize: fontSize * 0.7,
                                color: AppColors.textColor.withOpacity(0.7)),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              task['isCompleted']
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: AppColors.primaryColor,
                            ),
                            onPressed: () => _toggleCompleteTask(task['id']),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: AppColors.incompleteTaskColor,
                            ),
                            onPressed: () => _showUpdateDialog(task['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: AppColors.deleteButtonColor),
                            onPressed: () => _removeTask(task['id']),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: AppColors.borderColor,
                      thickness: 1.5,
                      indent: 10,
                      endIndent: 10,
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatTime(String timeAdded) {
    final date = DateTime.tryParse(timeAdded) ?? DateTime.now();
    return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
