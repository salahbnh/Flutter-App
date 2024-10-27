import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Ensure you have this package added in pubspec.yaml
import '../models/Resume.dart'; // Import your Resume model

class AddResumeScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onResumeAdded; // Expecting Map<String, dynamic>

  AddResumeScreen({required this.onResumeAdded});

  @override
  _AddResumeScreenState createState() => _AddResumeScreenState();
}

class _AddResumeScreenState extends State<AddResumeScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Fields
  String selectedReference = 'Math'; // Default selected reference
  List<String> references = ['Math', 'Physics', 'Biology', 'Chemistry'];
  String selectedLevel = 'Beginner'; // Default selected level
  List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];
  String? resumeTitle;
  double? resumePrice;
  String resumeContentOption = 'Write'; // Default content option
  String? resumeTextContent;
  String? pdfFilePath;

  // Dropdown for selecting reference
  Widget _buildReferenceDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedReference,
      decoration: InputDecoration(labelText: 'Reference'),
      items: references.map((reference) {
        return DropdownMenuItem(
          value: reference,
          child: Text(reference),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedReference = newValue!;
        });
      },
      validator: (value) => value == null ? 'Please select a reference' : null,
    );
  }

  // Dropdown for selecting level
  Widget _buildLevelDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedLevel,
      decoration: InputDecoration(labelText: 'Level'),
      items: levels.map((level) {
        return DropdownMenuItem(
          value: level,
          child: Text(level),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedLevel = newValue!;
        });
      },
      validator: (value) => value == null ? 'Please select a level' : null,
    );
  }

  // Resume content input widget
  Widget _buildResumeContentInput() {
    if (resumeContentOption == 'Write') {
      return TextFormField(
        maxLines: 5,
        decoration: InputDecoration(labelText: 'Resume Content (Text)'),
        onSaved: (value) {
          resumeTextContent = value;
        },
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'],
              );

              if (result != null) {
                setState(() {
                  pdfFilePath = result.files.single.path;
                });
                print("Selected file path: $pdfFilePath");
              }
            },
            child: Text('Upload PDF'),
          ),
          if (pdfFilePath != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Selected File: ${pdfFilePath!.split('/').last}'),
            ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Resume'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) {
                  resumeTitle = value;
                },
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a title' : null,
              ),
              SizedBox(height: 16),
              _buildReferenceDropdown(),
              SizedBox(height: 16),
              _buildLevelDropdown(), // Add the level dropdown here
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  resumePrice = double.tryParse(value!);
                },
                validator: (value) =>
                value == null || double.tryParse(value) == null
                    ? 'Please enter a valid price'
                    : null,
              ),
              SizedBox(height: 16),
              Text('Resume Content:'),
              ListTile(
                title: Text('Write'),
                leading: Radio<String>(
                  value: 'Write',
                  groupValue: resumeContentOption,
                  onChanged: (value) {
                    setState(() {
                      resumeContentOption = value!;
                      pdfFilePath = null; // Reset pdf path if switching to text
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Upload PDF'),
                leading: Radio<String>(
                  value: 'Upload',
                  groupValue: resumeContentOption,
                  onChanged: (value) {
                    setState(() {
                      resumeContentOption = value!;
                      resumeTextContent = null; // Reset text if switching to PDF
                    });
                  },
                ),
              ),
              _buildResumeContentInput(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Map<String, dynamic> newResume = {
                      "title": resumeTitle!,
                      "reference": selectedReference,
                      "level": selectedLevel, // Add level to the resume
                      "price": resumePrice!,
                      "owner": 'YourName', // Replace with the actual username
                      "description": resumeTextContent ?? 'No description available.',
                    };
                    widget.onResumeAdded(newResume); // Call the callback to add resume
                    Navigator.pop(context); // Go back to store screen
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Updated button color
                  foregroundColor: Colors.white, // Updated text color
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
