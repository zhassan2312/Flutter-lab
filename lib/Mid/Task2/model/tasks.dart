class Task {
  final String title;
  final String description;
  final bool isCompleted;

  const Task({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  Task copyWith({String? title, String? description, bool? isCompleted}) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  static const List<Task> defaultTasks = [
    Task(title: 'Brush Teeth', description: 'Brush teeth before breakfast.'),
    Task(
      title: 'Study Flutter',
      description: 'Complete async and navigation practice.',
    ),
  ];
}
