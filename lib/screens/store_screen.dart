import 'package:flutter/material.dart';
import 'ResumeDetailsPage.dart';
import 'add_resume.dart';
import 'PaymentPage.dart';

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final List<Map<String, dynamic>> storeCourses = [
    {
      "title": "Store Course 1",
      "classLevel": "Grade 12",
      "price": 30.0,
      "reference": "Physics",
      "owner": "User C",
      "description": "An in-depth course on Grade 12 Physics.",
      "averageRating": 4.5,
    },
    {
      "title": "Store Course 2",
      "classLevel": "Grade 11",
      "price": 25.0,
      "reference": "Chemistry",
      "owner": "User D",
      "description": "A comprehensive course on Chemistry.",
      "averageRating": 3.8,
    },
    // Add more store courses as needed...
  ];

  List<Map<String, dynamic>> cart = []; // List to hold selected courses for payment

  void _addToCart(Map<String, dynamic> course) {
    setState(() {
      cart.add(course); // Add the selected course to the cart
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${course['title']} added to cart!')),
    );
  }

  void _onResumeAdded(Map<String, dynamic> newResume) {
    print("New Resume Added: $newResume");
  }

  void _addCourse() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddResumeScreen(onResumeAdded: _onResumeAdded),
      ),
    );
  }

  String searchQuery = "";
  TextEditingController searchController = TextEditingController();
  String selectedReference = 'All';
  double selectedMaxPrice = 100.0;
  String selectedLevel = 'All';

  List<String> references = ['All', 'Mathematics', 'Science', 'Physics', 'Chemistry', 'Biology'];
  List<String> levels = ['All', 'Grade 10', 'Grade 11', 'Grade 12'];

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
                child: DropdownButtonFormField<String>(
                  value: selectedLevel,
                  decoration: InputDecoration(labelText: 'Filter by Level'),
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
      final matchesLevel = selectedLevel == 'All' || course['classLevel'] == selectedLevel;
      return matchesSearch && matchesReference && matchesLevel && (course['price'] == null || course['price'] <= selectedMaxPrice);
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
                  if (course.containsKey('price')) Text("Price: \$${course['price']}"),
                  if (course.containsKey('averageRating'))
                    Text("Average Rating: ${course['averageRating'].toStringAsFixed(1)}", style: TextStyle(color: Colors.amber)),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () => _addToCart(course), // Add course to cart
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
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          cart: cart,
                          onRemoveFromCart: (course) {
                            setState(() {
                              cart.remove(course); // Remove the course from the cart
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${course['title']} removed from cart!')),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                if (cart.isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '${cart.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSearchAndFilter(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCourseList(storeCourses),
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          tabs: [
                            Tab(text: 'Completed Courses'),
                            Tab(text: 'Progress Courses'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildCourseList([]), // Empty for now
                              _buildCourseList([]), // Empty for now
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addCourse,
          tooltip: 'Add Course',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
