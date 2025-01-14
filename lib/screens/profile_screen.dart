import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../resources/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> _filteredTasks = [];
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksToSave = _tasks.map((task) {
      return {
        ...task,
        'timeAdded': task['timeAdded'] is DateTime
            ? (task['timeAdded'] as DateTime).toIso8601String()
            : task['timeAdded'],
      };
    }).toList();
    prefs.setString('tasks', jsonEncode(tasksToSave));
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
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task deleted successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deleteButtonColor,
                foregroundColor: AppColors.textColor,
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.02,
                    horizontal: MediaQuery.of(context).size.width * 0.05),
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

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('tasks');
    print('Raw tasks data: $tasksString');

    if (tasksString != null) {
      try {
        final List<dynamic> decodedData = jsonDecode(tasksString);
        setState(() {
          _tasks = decodedData.map((task) {
            return {
              'id': task['id'] ?? '',
              'task': task['task'] ?? '',
              'description': task['description'] ?? '',
              'isCompleted': task['isCompleted'] ?? false,
              'timeAdded': task['timeAdded'] is String
                  ? DateTime.parse(task['timeAdded'])
                  : task['timeAdded'],
            };
          }).toList();
          _filteredTasks = List.from(_tasks);
        });
      } catch (e) {
        print('Error loading tasks: $e');
        setState(() {
          _tasks = [];
          _filteredTasks = [];
        });
      }
    }
  }

  void _showUpdateDialog(String id) {
    final taskIndex = _tasks.indexWhere((task) => task['id'] == id);
    if (taskIndex == -1) return;

    final task = _tasks[taskIndex];
    final TextEditingController _updateController =
        TextEditingController(text: task['task']);
    final TextEditingController _descriptionController =
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
                controller: _updateController,
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
                  contentPadding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.015,
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
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
                  contentPadding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.015,
                      horizontal: MediaQuery.of(context).size.width * 0.05),
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
                    'task': _updateController.text.isNotEmpty
                        ? _updateController.text
                        : task['task'],
                    'description': _descriptionController.text.isNotEmpty
                        ? _descriptionController.text
                        : task['description'],
                    'timeAdded': DateTime.now(),
                  };
                  _filteredTasks = List.from(_tasks);
                });
                _saveTasks();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.textColor,
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.02,
                    horizontal: MediaQuery.of(context).size.width * 0.1),
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

  void _applyFilter(String filter) {
    setState(() {
      _filter = filter;

      if (filter == 'completed') {
        _filteredTasks =
            _tasks.where((task) => task['isCompleted'] == true).toList();
      } else if (filter == 'incomplete') {
        _filteredTasks =
            _tasks.where((task) => task['isCompleted'] == false).toList();
      } else if (filter == 'recently') {
        _filteredTasks = _tasks
            .where((task) =>
                task['timeAdded'] != null &&
                (task['timeAdded'] as DateTime)
                    .isAfter(DateTime.now().subtract(const Duration(days: 7))))
            .toList();
      } else {
        _filteredTasks = List.from(_tasks);
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        child: Column(
          children: [
            // Horizontal Row for Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All Tasks', 'all'),
                  const SizedBox(width: 8.0),
                  _buildFilterChip('Completed', 'completed'),
                  const SizedBox(width: 8.0),
                  _buildFilterChip('Incomplete', 'incomplete'),
                  const SizedBox(width: 8.0),
                  _buildFilterChip('Recently Added', 'recently'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Task List
            Expanded(
              child: ListView.builder(
                itemCount: _filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = _filteredTasks[index];
                  final isCompleted = task['isCompleted'] as bool;
                  final description =
                      task['description'] ?? "No description available";
                  final timeAdded = task['timeAdded'] is DateTime
                      ? (task['timeAdded'] as DateTime).toString()
                      : "No time available";

                  return ListTile(
                    title: Text(
                      task['task'],
                      style: TextStyle(
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          description,
                          style: const TextStyle(fontSize: 14),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Added on: $timeAdded',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: _buildTaskActions(task, isCompleted),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String filter) {
    return FilterChip(
      label: Text(label),
      selected: _filter == filter,
      onSelected: (_) => _applyFilter(filter),
      selectedColor: AppColors.primaryColor,
      backgroundColor: AppColors.backgroundColor,
      labelStyle: TextStyle(
        color:
            _filter == filter ? AppColors.backgroundColor : AppColors.textColor,
      ),
    );
  }

  Row _buildTaskActions(Map<String, dynamic> task, bool isCompleted) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            isCompleted ? Icons.check_circle : Icons.check_circle_outlined,
            color: isCompleted ? AppColors.primaryColor : AppColors.borderColor,
          ),
          onPressed: () => _toggleCompleteTask(task['id']),
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: AppColors.incompleteTaskColor),
          onPressed: () => _showUpdateDialog(task['id']),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: AppColors.deleteButtonColor),
          onPressed: () => _removeTask(task['id']),
        ),
      ],
    );
  }
}
