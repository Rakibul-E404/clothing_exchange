// favorite_item_model.dart
class FavoriteItem {
  final String favoriteId; // this is the _id from the favorite record
  final String productId;
  final String title;
  final String age;
  final String image;
  // add other product fields as needed

  FavoriteItem({
    required this.favoriteId,
    required this.productId,
    required this.title,
    required this.age,
    required this.image,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    final product = json['productData'] ?? {}; // assuming you fetch product info as nested JSON
    return FavoriteItem(
      favoriteId: json['_id'] ?? '',
      productId: json['product'] ?? '',
      title: product['title'] ?? '',
      age: product['age'] ?? '',
      image: product['image'] ?? '',
    );
  }
}
