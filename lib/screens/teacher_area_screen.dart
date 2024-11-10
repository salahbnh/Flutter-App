import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Import for PDF viewing
import 'package:moodle_app/screens/ImageViewerScreen.dart';

import 'ImageViewerScreen.dart';

class TeacherAreaScreen extends StatefulWidget {
  final String subject;
  final String teacher;

  const TeacherAreaScreen({Key? key, required this.subject, required this.teacher}) : super(key: key);

  @override
  _TeacherAreaScreenState createState() => _TeacherAreaScreenState();
}

class _TeacherAreaScreenState extends State<TeacherAreaScreen> {
  String? selectedFilePath;
  List<Map<String, String>> uploadedFiles = [];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUploadedFiles();
    _loadSavedImage();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  Future<void> _loadUploadedFiles() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.116:5000/files'));

      if (response.statusCode == 200) {
        List<dynamic> files = jsonDecode(response.body);

        setState(() {
          uploadedFiles = files.map((file) {
            return {
              'name': file['name'].toString(),
              'path': file['path'].toString(),
            };
          }).toList();
        });
      } else {
        print('Failed to load files: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching files: $e');
    }
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedFilePath = prefs.getString('uploaded_image_path');
    });
  }

  Future<void> _uploadFile(File file) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.116:5000/upload'),
    );

    request.files.add(
      http.MultipartFile(
        'file',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: file.path.split('/').last,
      ),
    );

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          uploadedFiles.add({
            'name': file.path.split('/').last,
            'path': file.path,
          });
        });
        print('File uploaded successfully');
      } else {
        print('Failed to upload file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  Future<void> deleteFile(String fileName) async {
    final response = await http.delete(
      Uri.parse('http://your-server.com/delete/$fileName'),
    );

    if (response.statusCode == 200) {
      print('File deleted successfully');
    } else {
      print('Failed to delete file: ${response.statusCode}');
    }
  }

  Future<void> _downloadFile(String filePath) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.116:5000/download/$filePath'));

      if (response.statusCode == 200) {
        final directory = Directory('C:/Users/saaafiiiihaaaaa/Desktop/back/down');

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final localPath = '${directory.path}/$filePath';
        final file = File(localPath);

        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          selectedFilePath = localPath;
        });
        print('File downloaded and saved successfully at: $localPath');
      } else {
        print('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  List<Map<String, String>> get filteredFiles {
    return uploadedFiles.where((file) {
      return file['name']!.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  String _getFileType(String fileName) {
    String extension = fileName.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
      return 'image';
    } else if (['pdf'].contains(extension)) {
      return 'pdf';
    } else {
      return 'other';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subject} - ${widget.teacher}'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  File file = File(result.files.single.path!);
                  setState(() {
                    selectedFilePath = file.path;
                  });

                  await _uploadFile(file);

                  final prefs = await SharedPreferences.getInstance();
                  prefs.setString('uploaded_image_path', file.path);
                }
              },
              child: const Text('Upload File'),
            ),
            const SizedBox(height: 20),
            selectedFilePath != null
                ? Image.file(
              File(selectedFilePath!),
              height: 200,
            )
                : const Text('No image selected'),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredFiles.length,
                itemBuilder: (context, index) {
                  final file = filteredFiles[index];
                  String fileName = file['name']!;
                  String filePath = file['path']!;
                  String fileType = _getFileType(fileName);

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        fileName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: fileType == 'image'
                          ? Icon(Icons.image, color: Colors.blue)
                          : fileType == 'pdf'
                          ? Icon(Icons.picture_as_pdf, color: Colors.red)
                          : Icon(Icons.file_copy, color: Colors.grey),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                            onPressed: () {
                              if (fileType == 'image') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImageViewerScreen(imagePath: filePath),
                                  ),
                                );
                              } else if (fileType == 'pdf') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PDFViewPage(pdfPath: filePath),
                                  ),
                                );
                              } else {
                                _viewFile(filePath);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.download, color: Colors.blue),
                            onPressed: () => _downloadFile(filePath),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              deleteFile(fileName);
                            },
                          ),
                        ],
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

  void _viewFile(String path) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('File Path'),
          content: Text(path),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class PDFViewPage extends StatelessWidget {
  final String pdfPath;

  const PDFViewPage({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: PDFView(
        filePath: pdfPath,
      ),
    );
  }
}
