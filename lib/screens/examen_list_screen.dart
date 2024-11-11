import 'package:flutter/material.dart';
import '../services/exam_services.dart';
import '../widgets/AddExamModal.dart';
import 'exam_details_screen.dart'; // Screen for submitting/viewing responses

class ExamListScreen extends StatefulWidget {
  final String courseId;
  final String subjectName;
  final bool isStudent;
  final String userId;

  ExamListScreen({required this.courseId, required this.subjectName, required this.isStudent, required this.userId});

  @override
  _ExamListScreenState createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  final ExamService examService = ExamService();
  late Future<List<Map<String, dynamic>>> exams;

  @override
  void initState() {
    super.initState();
    print('Is student: ${widget.isStudent}');  // Log to verify if instructor sees this
    exams = _fetchExams();
  }

  Future<List<Map<String, dynamic>>> _fetchExams() async {
    try {
      return await examService.getExamByCourseId(widget.courseId) as List<Map<String, dynamic>>;
    } catch (e) {
      print(e);
      return [];
    }
  }

  void _addExam() {
    showModalBottomSheet(
      context: context,
      builder: (_) => AddExamModal(courseId: widget.courseId, instructorId:  widget.userId,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subjectName)),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: exams,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching exams'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No exams available'));
          }

          return ListView(
            children: snapshot.data!.map((exam) {
              return Card(
                child: ListTile(
                  title: Text(exam['title']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExamDetailScreen(
                          examId: exam['id'],
                          isStudent: widget.isStudent,
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: widget.isStudent
          ? null
          : FloatingActionButton(
        onPressed: _addExam,
        child: Icon(Icons.add),
      ),
    );
  }
}
