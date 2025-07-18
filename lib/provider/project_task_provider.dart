import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../models/time_entry.dart';
import '../models/project.dart';
import '../models/task.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;

  List<TimeEntry> _entries = [];
  List<Project> _projects = [];
  List<Task> _tasks = [];

  List<TimeEntry> get entries => _entries;
  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;

  TimeEntryProvider(this.storage);

  Future<void> loadEntries() async {
    await Future.delayed(
      Duration(milliseconds: 100),
    ); // Ensure storage is ready
    final data = storage.getItem('data');
    if (data != null) {
      final decoded = json.decode(data);
      _entries =
          (decoded['entries'] as List)
              .map((e) => TimeEntry.fromJson(e))
              .toList();
      _projects =
          (decoded['projects'] as List)
              .map((e) => Project.fromJson(e))
              .toList();
      _tasks = (decoded['tasks'] as List).map((e) => Task.fromJson(e)).toList();
      notifyListeners();
    }
  }

  void _saveAll() {
    final data = {
      'entries': _entries.map((e) => e.toJson()).toList(),
      'projects': _projects.map((e) => e.toJson()).toList(),
      'tasks': _tasks.map((e) => e.toJson()).toList(),
    };
    storage.setItem('data', json.encode(data));
  }

  // CRUD for Time Entries
  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveAll();
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((e) => e.id == id);
    _saveAll();
    notifyListeners();
  }

  // CRUD for Projects
  void addProject(Project project) {
    _projects.add(project);
    _saveAll();
    notifyListeners();
  }

  void removeProject(Project project) {
    _projects.remove(project);
    _saveAll();
    notifyListeners();
  }

  // CRUD for Tasks
  void addTask(Task task) {
    _tasks.add(task);
    _saveAll();
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    _saveAll();
    notifyListeners();
  }
}
