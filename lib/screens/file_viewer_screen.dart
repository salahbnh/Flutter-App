import 'package:flutter/material.dart';
import 'dart:io';

class FileViewerScreen extends StatelessWidget {
  final File file;

  const FileViewerScreen({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    String extension = file.path.split('.').last.toLowerCase();

    if (extension == 'txt') {
      return Scaffold(
        appBar: AppBar(
          title: Text(file.path.split('/').last),
        ),
        body: FutureBuilder<String>(
          future: file.readAsString(), // Read the file content
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(snapshot.data ?? 'No content'),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      );
    } else if (['jpg', 'jpeg', 'png'].contains(extension)) {
      return Scaffold(
        appBar: AppBar(
          title: Text(file.path.split('/').last),
        ),
        body: Center(
          child: Image.file(file), // Display the image file
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Unsupported File Type'),
        ),
        body: Center(
          child: Text('Cannot view this file type.'),
        ),
      );
    }
  }
}
