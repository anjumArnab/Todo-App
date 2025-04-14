import 'package:dbapp/widgets/button.dart';
import 'package:dbapp/widgets/custom_text_field.dart';
import 'package:dbapp/widgets/priority_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 12 , minute: 0);
  String _priority = 'Medium';
  bool _reminderEnabled = true;
  final List<TextEditingController> _subtaskControllers = [
    TextEditingController()
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (var controller in _subtaskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addNewSubtaskField() {
    setState(() {
      _subtaskControllers.add(TextEditingController());
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TASK TITLE',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _titleController,
                hintText: 'Enter task title',
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              const Text(
                'DESCRIPTION (OPTIONAL)',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _descriptionController,
                hintText: 'Add details about your task',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DUE DATE',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('MMM d, yyyy')
                                      .format(_selectedDate),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DUE TIME',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectTime(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedTime.format(context),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'PRIORITY',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  PriorityButton(
                    label: 'Low',
                    selectedPriority: _priority,
                    onPrioritySelected: (value) {
                      setState(() {
                        _priority = value;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  PriorityButton(
                    label: 'Medium',
                    selectedPriority: _priority,
                    onPrioritySelected: (value) {
                      setState(() {
                        _priority = value;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  PriorityButton(
                    label: 'High',
                    selectedPriority: _priority,
                    onPrioritySelected: (value) {
                      setState(() {
                        _priority = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Set Reminder',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Switch(
                    value: _reminderEnabled,
                    onChanged: (value) {
                      setState(() {
                        _reminderEnabled = value;
                      });
                    },
                    activeColor: Colors.deepPurple,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'SUBTASKS',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _subtaskControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _subtaskControllers[index],
                            hintText: 'Enter subtask',
                            maxLines: 1,
                            suffixIcon: index == _subtaskControllers.length - 1
                                ? IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: _addNewSubtaskField,
                                  )
                                : null,
                            onChanged: (value) {
                              if (index == _subtaskControllers.length - 1 &&
                                  value.isNotEmpty) {
                                _addNewSubtaskField();
                              }
                            },
                          ),
                        ),
                        if (index < _subtaskControllers.length - 1 ||
                            _subtaskControllers[index].text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              setState(() {
                                _subtaskControllers.removeAt(index);
                                if (_subtaskControllers.isEmpty) {
                                  _subtaskControllers
                                      .add(TextEditingController());
                                }
                              });
                            },
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              ActionButton(
                label: 'SAVE TASK',
                onPressed: () {
                  // Save task logic
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
