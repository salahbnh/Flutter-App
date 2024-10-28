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
          'user': username,
        });
        commentController.clear();
        rating = 0.0;
        hasRated = true;
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
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      Text(
                        widget.resume['description'] ?? "Description not available.",
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Modules Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text("Modules will go here...", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
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
                  Row(
                    children: [
                      Text("Average Rating:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Star rating section
                  Text("Rate this Resume:", style: TextStyle(fontSize: 18)),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 30,
                        ),
                        onPressed: hasRated
                            ? null
                            : () {
                          setState(() {
                            rating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      labelText: "Leave a comment",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    maxLines: 3,
                    enabled: !hasRated,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: hasRated ? null : _submitReview,
                    child: Text("Submit Review"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Updated color parameter
                      foregroundColor: Colors.white, // Updated text color parameter
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Reviews:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      reviews[index]['user'],
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    Row(
                                      children: List.generate(5, (starIndex) {
                                        return Icon(
                                          starIndex < reviews[index]['rating'] ? Icons.star : Icons.star_border,
                                          color: Colors.amber,
                                          size: 20,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  reviews[index]['comment'],
                                  style: TextStyle(color: Colors.grey[700]),
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
          ],
        ),
      ),
    );
  }
}