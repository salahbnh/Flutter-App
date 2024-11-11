import 'package:flutter/material.dart';
import '../services/exam_services.dart';

class ExamDetailScreen extends StatelessWidget {
  final String examId;
  final bool isStudent;

  ExamDetailScreen({required this.examId, required this.isStudent});

  final ExamService examService = ExamService();
  final TextEditingController responseController = TextEditingController();

  Future<void> _submitResponse() async {
    try {
      await examService.addResponse(examId, 'userId', responseController.text);
    } catch (e) {
      print('Error submitting response: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exam Details')),
      body: isStudent
          ? Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: responseController,
              decoration: InputDecoration(labelText: 'Enter your response'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitResponse,
              child: Text('Submit Response'),
            ),
          ],
        ),
      )
          : Center(child: Text('List of Student Responses')),
    );
  }
}
