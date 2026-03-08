import 'package:flutter/material.dart';
import 'model/tasks.dart';

void main() {
  runApp(const TaskManager());
}

// TaskList is StatefulWidget to hold the theme mode state
class TaskManager extends StatefulWidget {
  const TaskManager({super.key});

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  bool _isDarkMode = false; // State variable to track current theme mode

  // Callback to toggle between light and dark themes
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.deepOrange,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Task Manager',
      theme: base.copyWith(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F8FA),
      ),
      darkTheme: base.copyWith(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121315),
      ),
      themeMode: _isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light, // Controlled by state
      home: MyHomePage(
        title: 'My Task Manager',
        onToggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.onToggleTheme, // Callback to toggle theme
    required this.isDarkMode, // Current theme mode flag
  });

  final String title;
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> _tasks = <Task>[];
  bool _isLoading = true;

  int get _completedCount =>
      _tasks.where((Task task) => task.isCompleted).length;

  int get _pendingCount => _tasks.length - _completedCount;

  @override
  void initState() {
    super.initState();
    _loadDefaultTasks();
  }

  Future<void> _loadDefaultTasks() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return;
    }

    setState(() {
      _tasks = List<Task>.from(Task.defaultTasks);
      _isLoading = false;
    });
  }

  Future<void> _openAddTaskScreen() async {
    final Task? newTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute<Task>(
        builder: (BuildContext context) => const AddTaskScreen(),
      ),
    );

    if (newTask == null || !mounted) {
      return;
    }

    setState(() {
      _tasks.add(newTask);
    });
  }

  Future<void> _openEditTaskScreen(int index) async {
    final Task currentTask = _tasks[index];
    final Task? updatedTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute<Task>(
        builder: (BuildContext context) => AddTaskScreen(
          existingTask: currentTask,
          screenTitle: 'Edit Task',
          buttonLabel: 'Update',
        ),
      ),
    );

    if (updatedTask == null || !mounted) {
      return;
    }

    setState(() {
      _tasks[index] = updatedTask.copyWith(
        isCompleted: currentTask.isCompleted,
      );
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _toggleTask(int index, bool? value) {
    setState(() {
      _tasks[index] = _tasks[index].copyWith(isCompleted: value ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: colors.onSurface,
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
        ),
        actions: [
          IconButton(
            tooltip: widget.isDarkMode
                ? 'Switch to Light Mode'
                : 'Switch to Dark Mode',
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary.withValues(alpha: widget.isDarkMode ? 0.20 : 0.12),
              colors.secondary.withValues(
                alpha: widget.isDarkMode ? 0.14 : 0.08,
              ),
              colors.tertiary.withValues(
                alpha: widget.isDarkMode ? 0.08 : 0.05,
              ),
            ],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _tasks.isEmpty
            ? const Center(child: Text('No tasks found. Add one using +'))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Total',
                            value: _tasks.length.toString(),
                            icon: Icons.list_alt_outlined,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatCard(
                            title: 'Done',
                            value: _completedCount.toString(),
                            icon: Icons.task_alt,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatCard(
                            title: 'Pending',
                            value: _pendingCount.toString(),
                            icon: Icons.schedule,
                            color: colors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                      itemCount: _tasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildTaskCard(_tasks[index], index);
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskScreen,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildTaskCard(Task task, int index) {
    final TextStyle titleStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: task.isCompleted
          ? Colors.grey
          : Theme.of(context).colorScheme.primary,
      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
    );

    final TextStyle descriptionStyle = TextStyle(
      fontSize: 14,
      color: task.isCompleted ? Colors.grey : Theme.of(context).hintColor,
      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: task.isCompleted
              ? Theme.of(context).colorScheme.surfaceContainerHigh
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.shadow.withValues(alpha: 0.18),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (bool? value) => _toggleTask(index, value),
          ),
          title: Text(task.title, style: titleStyle),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(task.description, style: descriptionStyle),
          ),
          trailing: SizedBox(
            width: 96,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  tooltip: 'Edit task',
                  onPressed: () => _openEditTaskScreen(index),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Delete task',
                  onPressed: () => _deleteTask(index),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({
    super.key,
    this.existingTask,
    this.screenTitle = 'Add Task',
    this.buttonLabel = 'Save',
  });

  final Task? existingTask;
  final String screenTitle;
  final String buttonLabel;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.existingTask?.title ?? '';
    _descriptionController.text = widget.existingTask?.description ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and description are required.')),
      );
      return;
    }

    final Task task = Task(
      title: title,
      description: description,
      isCompleted: widget.existingTask?.isCompleted ?? false,
    );
    Navigator.pop(context, task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.screenTitle)),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveTask,
                      icon: const Icon(Icons.save_outlined),
                      label: Text(widget.buttonLabel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
