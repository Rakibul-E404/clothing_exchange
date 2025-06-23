

class FavoriteItem {
  final String favoriteId;
  final String productId;
  final String title;
  final String age;
  final String description;
  final String image;
  final String size;  // Add size property
  final String gender; // Add gender property
  final String location; // Add location property

  FavoriteItem({
    required this.favoriteId,
    required this.productId,
    required this.title,
    required this.age,
    required this.description,
    required this.image,
    required this.size,     // Initialize size
    required this.gender,   // Initialize gender
    required this.location, // Initialize location
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'] is Map<String, dynamic> ? json['product'] : {};
    return FavoriteItem(
      favoriteId: json['_id'] ?? '',
      productId: json['product']?['_id'] ?? '',
      title: product['title'] ?? '',
      age: product['age'] ?? '',
      description: product['description'] ?? '',
      image: product['image'] ?? '',
      size: product['size'] ?? '',       // Ensure size is handled
      gender: product['gender'] ?? '',   // Ensure gender is handled
      location: product['location'] ?? '', // Ensure location is handled
    );
  }
}



class FavoriteResponse {
  final String message;
  final List<FavoriteItem> favorites;

  FavoriteResponse({
    required this.message,
    required this.favorites,
  });

  // Factory constructor to parse the full response JSON
  factory FavoriteResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteResponse(
      message: json['message'] ?? '',
      favorites: (json['data']['attributes'] as List)
          .map((e) => FavoriteItem.fromJson(e))
          .toList(),
    );
  }
}