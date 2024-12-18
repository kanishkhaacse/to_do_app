import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      home: TaskPage(),
      routes: {
        '/home': (context) => HomePage(),
      },
    );
  }
}

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Illustration or Image
            Image.asset(
              'assets/icon.png', // Make sure you add the image in the assets folder
              height: 250,
            ),
            SizedBox(height: 20),

            // Text "Tasks made simple..."
            Text(
              'Tasks made simple...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 30),

            // Get Started Button
            ElevatedButton(
              onPressed: () {
                // Navigate to another page
                Navigator.pushNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent, // Button color
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'GET STARTED',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> tasks = []; // List to store tasks

  void _addTask(String task) {
    setState(() {
      tasks.add(task);
    });
    Navigator.pop(context); // Close the dialog after adding the task
  }

  void _removeTask(int index) {
    setState(() {
      tasks.removeAt(index); // Remove task by index
    });
  }

  void _showAddTaskDialog() {
    TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add New Task',
            style: TextStyle(color: Color(0xFF38CDDD)), // Set color for title
          ),
          content: SingleChildScrollView( // Wrap content in a SingleChildScrollView
            child: Column(
              children: [
                TextField(
                  controller: taskController,
                  decoration: InputDecoration(hintText: 'Enter task...'),
                ),
              ],
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF38CDDD)), // Set cancel text color
              ),
            ),
            // Create Button
            TextButton(
              onPressed: () {
                String task = taskController.text.trim();
                if (task.isNotEmpty) {
                  _addTask(task); // Add task if not empty
                }
              },
              child: Text(
                'Create',
                style: TextStyle(color: Color(0xFF38CDDD)), // Set create text color
              ),
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
        title: Text(
          'To-do',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Your existing content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hide the image and text if there are tasks
              if (tasks.isEmpty)
                Column(
                  children: [
                    Image.asset(
                      'assets/todo.png', 
                      height: 600,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No to-do',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              // Display tasks if they are present
              if (tasks.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return TaskItem(
                        task: tasks[index],
                        onDelete: () => _removeTask(index),
                      );
                    },
                  ),
                ),
            ],
          ),
          // Circle with a plus icon at the bottom right
          Positioned(
            right: 20,
            bottom: 20,
            child: GestureDetector(
              onTap: _showAddTaskDialog, // Show dialog on tap
              child: Container(
                width: 60, // Width of the circle
                height: 60, // Height of the circle
                decoration: BoxDecoration(
                  color: Color(0xFF38CDDD), // Circle color
                  shape: BoxShape.circle, // Makes the container circular
                ),
                child: Icon(
                  Icons.add, // Plus icon
                  color: Colors.black, // Color of the plus sign
                  size: 30, // Size of the plus icon
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  final String task;
  final VoidCallback onDelete;

  const TaskItem({super.key, required this.task, required this.onDelete});

  @override
  // ignore: library_private_types_in_public_api
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isChecked = false; // To keep track of checkbox state

  void _toggleCheckBox(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: isChecked,
        onChanged: _toggleCheckBox,
      ),
      title: Text(
        widget.task,
        style: TextStyle(
          decoration:
              isChecked ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: widget.onDelete, // Call the onDelete function
      ),
    );
  }
}
