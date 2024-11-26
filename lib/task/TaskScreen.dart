import 'package:flutter/material.dart';
import 'package:retali/main_layout.dart';

// Enum for task status
enum TaskStatus { completed, notFulfilled, assignedToColleague, pending }

// Task category model
class TaskCategory {
  final String title;
  final IconData icon;
  final List<Task> tasks;
  final Color color;

  TaskCategory({
    required this.title,
    required this.icon,
    required this.tasks,
    required this.color,
  });
}

// Task model
class Task {
  final String title;
  final String description;
  TaskStatus status;
  final DateTime deadline;

  Task({
    required this.title,
    required this.description,
    this.status = TaskStatus.pending,
    required this.deadline,
  });
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  // Sample task categories
  final List<TaskCategory> taskCategories = [
    TaskCategory(
      title: 'Persiapan Keberangkatan',
      icon: Icons.flight_takeoff,
      color: Colors.blue,
      tasks: [
        Task(
          title: 'Verifikasi Dokumen Jamaah',
          description: 'Periksa passport dan visa semua jamaah',
          deadline: DateTime.now().add(const Duration(days: 2)),
        ),
        Task(
          title: 'Briefing Jamaah',
          description: 'Persiapan briefing keberangkatan dengan jamaah',
          deadline: DateTime.now().add(const Duration(days: 1)),
        ),
      ],
    ),
    TaskCategory(
      title: 'Manasik',
      icon: Icons.mosque,
      color: Colors.green,
      tasks: [
        Task(
          title: 'Materi Tawaf',
          description: 'Persiapkan materi panduan tawaf',
          deadline: DateTime.now().add(const Duration(days: 3)),
        ),
        Task(
          title: 'Materi Sai',
          description: 'Persiapkan materi panduan sai',
          deadline: DateTime.now().add(const Duration(days: 3)),
        ),
      ],
    ),
    TaskCategory(
      title: 'Akomodasi',
      icon: Icons.hotel,
      color: Colors.orange,
      tasks: [
        Task(
          title: 'Cek Hotel Mekkah',
          description: 'Konfirmasi reservasi hotel di Mekkah',
          deadline: DateTime.now().add(const Duration(days: 5)),
        ),
        Task(
          title: 'Cek Hotel Madinah',
          description: 'Konfirmasi reservasi hotel di Madinah',
          deadline: DateTime.now().add(const Duration(days: 7)),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 1, // Index for Tasks
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Daftar Tugas',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.black87),
              onPressed: () {
                // Implement filter functionality
              },
            ),
          ],
        ),
        body: ListView.builder(
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
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Deadline: ${_formatDate(task.deadline)}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
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