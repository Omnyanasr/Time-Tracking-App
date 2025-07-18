import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/time_entry.dart';
import 'package:time_tracker/provider/project_task_provider.dart';
import 'package:time_tracker/screens/add_time_entry_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Time Tracker'),
          bottom: const TabBar(
            tabs: [Tab(text: 'All Entries'), Tab(text: 'By Project')],
          ),
        ),
        body: TabBarView(children: [_AllEntriesTab(), _GroupedByProjectTab()]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
            );
          },
          child: const Icon(Icons.add),
          tooltip: 'Add Time Entry',
        ),
      ),
    );
  }
}

class _AllEntriesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        final entries = provider.entries;
        if (entries.isEmpty)
          return const Center(child: Text('No entries yet.'));
        return ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return ListTile(
              title: Text('${entry.projectId} - ${entry.totalTime} hours'),
              subtitle: Text('${entry.date.toLocal()} - ${entry.notes}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => provider.deleteTimeEntry(entry.id),
              ),
            );
          },
        );
      },
    );
  }
}

class _GroupedByProjectTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        final grouped = <String, List<TimeEntry>>{};
        for (var entry in provider.entries) {
          grouped.putIfAbsent(entry.projectId, () => []).add(entry);
        }
        if (grouped.isEmpty)
          return const Center(child: Text('No entries yet.'));

        return ListView(
          children:
              grouped.entries.map((group) {
                final total = group.value.fold<double>(
                  0,
                  (sum, e) => sum + e.totalTime,
                );
                return ExpansionTile(
                  title: Text(
                    '${group.key} - Total: ${total.toStringAsFixed(1)} hrs',
                  ),
                  children:
                      group.value.map((entry) {
                        return ListTile(
                          title: Text(
                            '${entry.taskId} - ${entry.totalTime} hrs',
                          ),
                          subtitle: Text(
                            '${entry.date.toLocal()} - ${entry.notes}',
                          ),
                        );
                      }).toList(),
                );
              }).toList(),
        );
      },
    );
  }
}
