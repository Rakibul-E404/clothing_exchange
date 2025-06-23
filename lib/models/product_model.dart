class Product {
  final String id;
  final String author;
  final String image;
  final String title;
  final String description;
  final String age;
  final String size;
  final String gender;
  final String location;
  final String color;
  final String status;
  final bool isDeleted;
   bool wishlistStatus =false;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String changedBy;

  Product({
    required this.id,
    required this.author,
    required this.image,
    required this.title,
    required this.description,
    required this.age,
    required this.size,
    required this.gender,
    required this.location,
    required this.color,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.changedBy,
    required this.wishlistStatus,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["_id"] as String,
    author: json["author"] as String,
    image: json["image"] as String,
    title: json["title"] as String,
    description: json["description"] as String,
    age: json["age"] as String,
    size: json["size"] as String,
    gender: json["gender"] as String,
    location: json["location"] as String,
    color: json["color"] as String,
    status: json["status"] as String,
    isDeleted: json["isDeleted"] as bool,
    createdAt: DateTime.parse(json["createdAt"] as String),
    updatedAt: DateTime.parse(json["updatedAt"] as String),
    v: json["__v"] as int,
    changedBy: json["changedBy"] ?? '',
    wishlistStatus: json['wishlistStatus'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "author": author,
    "image": image,
    "title": title,
    "description": description,
    "age": age,
    "size": size,
    "gender": gender,
    "location": location,
    "color": color,
    "status": status,
    "isDeleted": isDeleted,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "changedBy": changedBy,
    "wishlistStatus": wishlistStatus,
  };
}
