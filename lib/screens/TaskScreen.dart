
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:retali/models/task.dart';
import 'package:retali/models/task_category.dart';
import 'package:retali/widgets/main_layout.dart';


class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<TaskCategory> taskCategories = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadTaskData();
  }

  Future<void> _loadTaskData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final String response = await rootBundle.loadString('assets/task.json');
      final data = await json.decode(response);

      setState(() {
        taskCategories = (data['soal_soal'] as List).map((categoryData) {
          final tasks = (categoryData['tasks'] as List<dynamic>).map((taskData) {
            return Task(
              title: taskData.toString(),
              description: '',
            
            );
          }).toList();

          return TaskCategory(
            title: categoryData['title'],
            icon: _getCategoryIcon(categoryData['title']),
            color: _getCategoryColor(categoryData['title']),
            tasks: tasks,
          );
        }).toList();
        
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error loading tasks: $e';
        isLoading = false;
      });
    }
  }

  IconData _getCategoryIcon(String title) {
    if (title.contains('Bandara')) {
      return Icons.flight;
    } else if (title.contains('Pesawat')) {
      return Icons.airplane_ticket;
    } else if (title.contains('Transit')) {
      return Icons.transfer_within_a_station;
    } else if (title.contains('Mekkah')) {
      return Icons.mosque;
    } else if (title.contains('Madinah')) {
      return Icons.location_city;
    }
    return Icons.task;
  }

  Color _getCategoryColor(String title) {
    if (title.contains('Bandara')) {
      return Colors.blue;
    } else if (title.contains('Pesawat')) {
      return Colors.green;
    } else if (title.contains('Transit')) {
      return Colors.orange;
    } else if (title.contains('Mekkah')) {
      return Colors.purple;
    } else if (title.contains('Madinah')) {
      return Colors.teal;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Daftar Tugas',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            ],
        ),
        body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : error != null
            ? Center(child: Text(error!, style: TextStyle(color: Colors.red)))
            : ListView.builder(
                itemCount: taskCategories.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return _buildTaskCategory(taskCategories[index]);
                },
              ),
      ),
    );
  }

  Widget _buildTaskCategory(TaskCategory category) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(category.icon, color: category.color),
          ),
          title: Text(
            category.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          children: category.tasks.map((task) => _buildTaskItem(task)).toList(),
        ),
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                       ],
                ),
              ),
              PopupMenuButton<TaskStatus>(
                icon: _getStatusIcon(task.status),
                onSelected: (TaskStatus result) {
                  setState(() {
                    task.status = result;
                  });
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: TaskStatus.completed,
                    child: Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Sudah'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: TaskStatus.notFulfilled,
                    child: Row(
                      children: const [
                        Icon(Icons.cancel, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Tidak Terpenuhi'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: TaskStatus.assignedToColleague,
                    child: Row(
                      children: const [
                        Icon(Icons.person_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Dikerjakan Rekan'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  Icon _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return const Icon(Icons.check_circle, color: Colors.green);
      case TaskStatus.notFulfilled:
        return const Icon(Icons.cancel, color: Colors.red);
      case TaskStatus.assignedToColleague:
        return const Icon(Icons.person_outline, color: Colors.blue);
      case TaskStatus.pending:
        return const Icon(Icons.pending_outlined, color: Colors.grey);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
