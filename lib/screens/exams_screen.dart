import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'file_viewer_screen.dart'; // Import your FileViewerScreen

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({Key? key}) : super(key: key);

  @override
  _ExamsScreenState createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  List<File> _uploadedFiles = [];

  void _uploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final path = result.files.single.path;
      if (path != null) {
        setState(() {
          _uploadedFiles.add(File(path));
        });
      }
    }
  }

  void _viewFile(File file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select an option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('View File'),
                onTap: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FileViewerScreen(file: file),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Type your answer'),
                onTap: () {
                  Navigator.pop(context); // Close dialog
                  _showAnswerInputDialog(file);
                },
              ),
              ListTile(
                title: Text('Upload a file as answer'),
                onTap: () {
                  Navigator.pop(context); // Close dialog
                  _uploadFileForAnswer(file);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _showAnswerInputDialog(File file) {
    String answer = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Answer for ${file.path.split('/').last}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.teal, // Title color
            ),
          ),
          content: Container(
            width: double.maxFinite, // Make the dialog content wider
            child: TextField(
              onChanged: (value) {
                answer = value;
              },
              maxLines: 5, // Allow multiple lines
              decoration: InputDecoration(
                labelText: 'Enter your answer here',
                labelStyle: const TextStyle(color: Colors.teal), // Label color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  borderSide: const BorderSide(color: Colors.teal), // Border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.tealAccent), // Focused border color
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.teal), // Button text color
              ),
              onPressed: () {
                // Handle the submitted answer here
                print('Answer submitted: $answer for file ${file.path}');
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _uploadFileForAnswer(File file) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final answerPath = result.files.single.path;
      if (answerPath != null) {
        // Handle the uploaded answer file
        print('Uploaded answer file: $answerPath for file ${file.path}');
        // Show a success dialog or snackbar
        _showSuccessDialog(file.path);
      }
    }
  }

  void _showSuccessDialog(String fileName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('File Uploaded Successfully'),
          content: Text('Your answer file has been uploaded for $fileName.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }


  void _deleteFile(int index) {
    setState(() {
      _uploadedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exams'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _uploadFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Updated from 'primary' to 'backgroundColor'
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Rounded button
                ),
              ),
              child: const Text(
                'Upload File',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16), // Spacing between button and list
            Expanded(
              child: ListView.builder(
                itemCount: _uploadedFiles.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4, // Shadow effect
                    margin: const EdgeInsets.symmetric(vertical: 8.0), // Card spacing
                    child: ListTile(
                      title: Text(
                        _uploadedFiles[index].path.split('/').last,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () => _viewFile(_uploadedFiles[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteFile(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
