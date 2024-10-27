import 'package:flutter/material.dart';

class ResumeDetailsPage extends StatefulWidget {
  final Map<String, dynamic> resume;

  ResumeDetailsPage({required this.resume});

  @override
  _ResumeDetailsPageState createState() => _ResumeDetailsPageState();
}

class _ResumeDetailsPageState extends State<ResumeDetailsPage> {
  List<Map<String, dynamic>> reviews = [];
  double rating = 0.0;
  TextEditingController commentController = TextEditingController();
  String username = "User A"; // Replace with actual user data
  bool hasRated = false; // Track if the user has already rated

  void _submitReview() {
    if (commentController.text.isNotEmpty && !hasRated) {
      setState(() {
        reviews.add({
          'rating': rating,
          'comment': commentController.text,
          'user': username, // Store the username with the review
        });
        commentController.clear();
        rating = 0.0; // Reset rating after submitting
        hasRated = true; // Set to true after rating
      });
    }
  }

  double _calculateAverageRating() {
    if (reviews.isEmpty) return 0.0;
    double total = reviews.fold(0, (sum, review) => sum + review['rating']);
    return total / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    double averageRating = _calculateAverageRating();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.resume['title']),
          bottom: TabBar(
            tabs: [
              Tab(text: 'About'),
              Tab(text: 'Modules'),
              Tab(text: 'Reviews'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // About Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title: ${widget.resume['title']}",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      // Add more information about the resume here...
                    ],
                  ),
                ),
              ),
            ),
            // Modules Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text("Modules will go here..."),
                      // Add module details...
                    ],
                  ),
                ),
              ),
            ),
            // Reviews Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Average rating display
                  Text("Average Rating: ${averageRating.toStringAsFixed(1)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  // Star rating section
                  Text("Rate this Resume:", style: TextStyle(fontSize: 18)),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: hasRated
                            ? null // Disable rating if already rated
                            : () {
                          setState(() {
                            rating = index + 1.0; // Update rating
                          });
                        },
                      );
                    }),
                  ),
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      labelText: "Leave a comment",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    enabled: !hasRated, // Disable comment field if already rated
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: hasRated ? null : _submitReview, // Disable button if already rated
                    child: Text("Submit Review"),
                  ),
                  SizedBox(height: 20),
                  // Display reviews
                  Text("Reviews:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text("Rating: ${reviews[index]['rating']} - ${reviews[index]['user']}", style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(reviews[index]['comment']),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
