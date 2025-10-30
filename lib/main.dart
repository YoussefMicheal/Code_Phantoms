import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Image.asset(
                  'assets/images/first.jpg',
                  fit: kIsWeb ? BoxFit.contain : BoxFit.cover,
                ),
              ),
            ),
            
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                children: [
                  const Text(
                    'Task Management &\nTo-Do List',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'This productive tool is designed to help\nyou better manage your task\nproject-wise conveniently!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0EA5FF), Color(0xFF0077FF)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.25),
                            offset: const Offset(0, 8),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Let's Start",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  String title;
  String priority;
  List<String> tags;
  bool isCompleted;

  Task({
    required this.title,
    this.priority = 'Low',
    this.tags = const [],
    this.isCompleted = false,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> _tasks = [
    Task(title: 'Design New UI For Dashboard', isCompleted: false),
    Task(title: 'Create a new feature', isCompleted: true),
  ];

  int _selectedIndex = 0;

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AddTaskSheet(onAddTask: (newTask) {
            setState(() {
              _tasks.add(newTask);
            });
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int completedTasks = _tasks.where((t) => t.isCompleted).length;
    int totalTasks = _tasks.length;
    double progress = totalTasks == 0 ? 0 : completedTasks / totalTasks;

    List<Task> filteredTasks = _selectedIndex == 0 ? _tasks : _tasks.where((t) => t.isCompleted).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Good Morning, Ali',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Monday, July 14', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              const SizedBox(height: 20),
              const Text('My Day Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.blue,
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 8),
              Text('$completedTasks/$totalTasks Tasks Completed', style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 24),
              const Text('Tasks', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                  child: ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return ListTile(
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (bool? value) {
                            setState(() {
                              task.isCompleted = value!;
                            });
                          },
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                            color: task.isCompleted ? Colors.grey : Colors.black87,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Text(task.priority, style: TextStyle(color: task.priority == 'High' ? Colors.red : task.priority == 'Medium' ? Colors.orange : Colors.green)),
                            const SizedBox(width: 10),
                            ...task.tags.map((t) => Container(
                                  margin: const EdgeInsets.only(right: 6),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                                  child: Text(t, style: const TextStyle(fontSize: 12)),
                                )).toList(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Completed'),
        ],
      ),
    );
  }
}

class AddTaskSheet extends StatefulWidget {
  final Function(Task) onAddTask;
  const AddTaskSheet({super.key, required this.onAddTask});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  String _selectedPriority = 'Low';
  final _taskController = TextEditingController();
  final List<String> _tags = [];

  void _showAddTagDialog() {
    final TextEditingController tagController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Tag'),
          content: TextField(
            controller: tagController,
            decoration: const InputDecoration(hintText: 'tag name'),
            autofocus: true,
            onSubmitted: (_) {
              if (tagController.text.trim().isNotEmpty) {
                setState(() {
                  _tags.add(tagController.text.trim());
                });
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (tagController.text.trim().isNotEmpty) {
                  setState(() {
                    _tags.add(tagController.text.trim());
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriorityButton(String title) {
    bool isSelected = _selectedPriority == title;
    Color color = Colors.grey.shade200;
    Color textColor = Colors.black87;

    if (isSelected) {
      if (title == 'Low') {
        color = Colors.green.shade100;
        textColor = Colors.green.shade800;
      }
      if (title == 'Medium') {
        color = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
      }
      if (title == 'High') {
        color = Colors.red.shade100;
        textColor = Colors.red.shade800;
      }
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPriority = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: textColor))),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add Task', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text('What do you want to do ?', style: TextStyle(fontSize: 14, color: Colors.grey)),
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(hintText: 'e.g. Finish Design system'),
            ),
            const SizedBox(height: 20),
            const Text('Date', style: TextStyle(fontSize: 14, color: Colors.grey)),
            TextField(
              readOnly: true,
              decoration: const InputDecoration(hintText: 'mm/dd/yyyy', suffixIcon: Icon(Icons.calendar_today_outlined)),
              onTap: () {},
            ),
            const SizedBox(height: 20),
            const Text('Priority', style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildPriorityButton('Low'),
                const SizedBox(width: 10),
                _buildPriorityButton('Medium'),
                const SizedBox(width: 10),
                _buildPriorityButton('High'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Tags', style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ..._tags.map((t) => Chip(
                      label: Text(t),
                      backgroundColor: Colors.green.shade50,
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        setState(() {
                          _tags.remove(t);
                        });
                      },
                    )),
                InkWell(
                  onTap: _showAddTagDialog,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.add, size: 16, color: Colors.black54),
                        SizedBox(width: 6),
                        Text('+ Add Tags', style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_taskController.text.trim().isEmpty) return;
                widget.onAddTask(Task(title: _taskController.text.trim(), priority: _selectedPriority, tags: List.from(_tags)));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Add Task', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}