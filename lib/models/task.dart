
enum TaskStatus { completed, notFulfilled, assignedToColleague, pending }

class Task {
  final String title;
  final String description;
  TaskStatus status;
 

  Task({
    required this.title,
    required this.description,
    this.status = TaskStatus.pending,
   
  });
}