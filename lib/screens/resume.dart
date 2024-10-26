// resume.dart
class Resume {
  final String title;
  final String reference;
  final double price;
  final String owner;
  final String? description; // Add more fields as needed

  Resume({
    required this.title,
    required this.reference,
    required this.price,
    required this.owner,
    this.description,
  });
}
