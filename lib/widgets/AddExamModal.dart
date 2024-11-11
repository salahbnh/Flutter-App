import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../services/exam_services.dart';

class AddExamModal extends StatefulWidget {
  final String courseId;
  final String instructorId;

  AddExamModal({required this.courseId, required this.instructorId});

  @override
  _AddExamModalState createState() => _AddExamModalState();
}

class _AddExamModalState extends State<AddExamModal> {
  final ExamService examService = ExamService();
  final TextEditingController titleController = TextEditingController();
  bool isLoading = false;
  Uint8List? selectedFile;
  String? fileMimeType;

  Future<void> _createExam() async {
    setState(() => isLoading = true);

    try {
      await examService.createExam(
        widget.courseId,
        widget.instructorId,
        selectedFile,
        fileMimeType,
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create exam: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'], // Limit to image types
    );
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        selectedFile = result.files.single.bytes;
        fileMimeType = result.files.single.extension; // Set file MIME type
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Exam Title'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickFile,
            child: Text(selectedFile != null ? 'Image Selected' : 'Pick Image'),
          ),
          SizedBox(height: 20),
          isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
            onPressed: _createExam,
            child: Text('Create Exam'),
          ),
        ],
      ),
    );
  }
}
