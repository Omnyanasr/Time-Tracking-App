import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/project.dart';
import 'package:time_tracker/models/task.dart';
import 'package:time_tracker/provider/project_task_provider.dart';
import 'package:uuid/uuid.dart';

class ProjectTaskManagementScreen extends StatelessWidget {
  const ProjectTaskManagementScreen({super.key});

  void _showAddDialog(BuildContext context, bool isProject) {
    final TextEditingController controller = TextEditingController();
    final uuid = Uuid();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(isProject ? 'Add Project' : 'Add Task'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: isProject ? 'Project name' : 'Task name',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = controller.text.trim();
                  if (name.isNotEmpty) {
                    final provider = Provider.of<TimeEntryProvider>(
                      context,
                      listen: false,
                    );
                    final id = uuid.v4();

                    if (isProject) {
                      provider.addProject(Project(id: id, name: name));
                    } else {
                      provider.addTask(
                        Task(id: id, name: name, projectId: ''),
                      ); // For now use empty projectId
                    }
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Projects and Tasks'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Projects'), Tab(text: 'Tasks')],
          ),
        ),
        body: Consumer<TimeEntryProvider>(
          builder: (context, provider, child) {
            return TabBarView(
              children: [
                // Projects tab
                ListView.builder(
                  itemCount: provider.projects.length,
                  itemBuilder: (context, index) {
                    final project = provider.projects[index];
                    return ListTile(
                      title: Text(project.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          provider.removeProject(project);
                        },
                      ),
                    );
                  },
                ),
                // Tasks tab
                ListView.builder(
                  itemCount: provider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = provider.tasks[index];
                    return ListTile(
                      title: Text(task.name),
                      subtitle: Text('Project ID: ${task.projectId}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          provider.removeTask(task);
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder:
                  (_) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.folder),
                        title: const Text('Add Project'),
                        onTap: () {
                          Navigator.pop(context);
                          _showAddDialog(context, true);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.task),
                        title: const Text('Add Task'),
                        onTap: () {
                          Navigator.pop(context);
                          _showAddDialog(context, false);
                        },
                      ),
                    ],
                  ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
