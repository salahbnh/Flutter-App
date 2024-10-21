// import 'package:flutter/material.dart';
//
// class CourseDetailsScreen extends StatelessWidget {
//   final String title;
//   final String description;
//
//   const CourseDetailsScreen({
//     super.key,
//     required this.title,
//     required this.description,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               description,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const Spacer(),
//             ElevatedButton(
//               onPressed: () {
//                 // Add registration logic here
//               },
//               child: const Text('Register'),
//             ),
//           ],        ),
//       ),
//     );
//   }
// }
