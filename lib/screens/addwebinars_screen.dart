import 'package:flutter/material.dart';

class AddWebinarScreen extends StatefulWidget {
  const AddWebinarScreen({Key? key}) : super(key: key);

  @override
  State<AddWebinarScreen> createState() => _AddWebinarScreenState();
}

class _AddWebinarScreenState extends State<AddWebinarScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  DateTime date = DateTime.now();
  int duration = 0;
  int maxParticipants = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Webinar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  title = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  description = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Date & Time'),
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDateTimePicker(context);
                  if (picked != null && picked != date) {
                    setState(() {
                      date = picked;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date and time';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the duration';
                  }
                  return null;
                },
                onSaved: (value) {
                  duration = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Max Participants'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the max number of participants';
                  }
                  return null;
                },
                onSaved: (value) {
                  maxParticipants = int.parse(value!);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Handle the addition of the webinar here (e.g., send to backend)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Webinar Added: $title')),
                    );
                  }
                },
                child: const Text('Add Webinar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> showDateTimePicker(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(date),
      );

      if (selectedTime != null) {
        return DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    }

    return null;
  }
}
