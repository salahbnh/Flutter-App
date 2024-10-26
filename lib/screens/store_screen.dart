import 'package:flutter/material.dart';
import 'ResumeDetailsPage.dart'; // Make sure to import the CourseDetailsPage

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final List<Map<String, dynamic>> purchasedCourses = [
    {
      "title": "Purchased Course 1",
      "classLevel": "Grade 10",
      "price": 20.0,
      "reference": "Mathematics",
      "owner": "User A",
      "description": "Detailed course content and structure of Grade 10 Mathematics."
    },
    // Additional course data...
  ];

  final List<Map<String, dynamic>> storeCourses = [
    {
      "title": "Store Course 1",
      "classLevel": "Grade 12",
      "price": 30.0,
      "reference": "Physics",
      "owner": "User C",
      "description": "An in-depth course on Grade 12 Physics."
    },
    // Additional course data...
  ];

  String searchQuery = "";
  TextEditingController searchController = TextEditingController();
  String selectedReference = 'All';
  double selectedMaxPrice = 100.0;

  List<String> references = ['All', 'Mathematics', 'Science', 'Physics', 'Chemistry', 'Biology'];

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search by Title',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    searchQuery = searchController.text;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedReference,
                  decoration: InputDecoration(labelText: 'Filter by Reference'),
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
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Slider(
                  value: selectedMaxPrice,
                  min: 0,
                  max: 100.0,
                  divisions: 10,
                  label: 'Max Price: \$${selectedMaxPrice.round()}',
                  onChanged: (value) {
                    setState(() {
                      selectedMaxPrice = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList(List<Map<String, dynamic>> courses) {
    final filteredCourses = courses.where((course) {
      final matchesSearch = searchQuery.isEmpty || course['title'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesReference = selectedReference == 'All' || course['reference'] == selectedReference;
      return matchesSearch && matchesReference && course['price'] <= selectedMaxPrice;
    }).toList();

    return ListView.builder(
      itemCount: filteredCourses.length,
      itemBuilder: (context, index) {
        final course = filteredCourses[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResumeDetailsPage(resume: course),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              leading: Icon(Icons.book, color: Colors.blueAccent),
              title: Text(course['title'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Level: ${course['classLevel']}"),
                  Text("Reference: ${course['reference']}"),
                  Text("Owner: ${course['owner']}"),
                  Text("Price: \$${course['price']}"),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.shopping_bag),
                onPressed: () {
                  print("Purchasing ${course['title']} for \$${course['price']}");
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Resume Store'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Store Courses'),
              Tab(text: 'My Courses'),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildSearchAndFilter(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCourseList(storeCourses),
                  _buildCourseList(purchasedCourses),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
