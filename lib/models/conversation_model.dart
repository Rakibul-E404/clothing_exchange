

class ConversationModel {
  Receiver? sender;
  Receiver? receiver;
  Product? product;
  LastMessage? lastMessage;
  List<String>? messages;
  dynamic blockedBy;
  String? blockStatus;
  DateTime? createdAt;
  String? id;

  ConversationModel({
    this.sender,
    this.receiver,
    this.product,
    this.lastMessage,
    this.messages,
    this.blockedBy,
    this.blockStatus,
    this.createdAt,
    this.id,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) => ConversationModel(
    sender: json["sender"] != null ? Receiver.fromJson(json["sender"]) : null,
    receiver: json["receiver"] != null ? Receiver.fromJson(json["receiver"]) : null,
    product: json["product"] != null ? Product.fromJson(json["product"]) : null,
    lastMessage: json["lastMessage"] != null ? LastMessage.fromJson(json["lastMessage"]) : null,
    messages: json["messages"] != null
        ? List<String>.from(json["messages"].where((x) => x != null).map((x) => x.toString()))
        : [],
    blockedBy: json["blockedBy"],
    blockStatus: json["blockStatus"]?.toString(),
    createdAt: json["createdAt"] != null ? DateTime.tryParse(json["createdAt"]) : null,
    id: json["id"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "sender": sender?.toJson(),
    "receiver": receiver?.toJson(),
    "product": product?.toJson(),
    "lastMessage": lastMessage?.toJson(),
    "messages": messages == null ? [] : List<dynamic>.from(messages!.map((x) => x)),
    "blockedBy": blockedBy,
    "blockStatus": blockStatus,
    "createdAt": createdAt?.toIso8601String(),
    "id": id,
  };
}

class LastMessage {
  String? conversationId;
  String? text;
  String? imageUrl;
  bool? seen;
  String? msgByUserId;
  DateTime? createdAt;
  String? id;

  LastMessage({
    this.conversationId,
    this.text,
    this.imageUrl,
    this.seen,
    this.msgByUserId,
    this.createdAt,
    this.id,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
    conversationId: json["conversationId"]?.toString(),
    text: json["text"]?.toString(),
    imageUrl: json["imageUrl"]?.toString(),
    seen: json["seen"] == null ? false : json["seen"],
    msgByUserId: json["msgByUserId"]?.toString(),
    createdAt: json["createdAt"] != null ? DateTime.tryParse(json["createdAt"]) : null,
    id: json["id"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "conversationId": conversationId,
    "text": text,
    "imageUrl": imageUrl,
    "seen": seen,
    "msgByUserId": msgByUserId,
    "createdAt": createdAt?.toIso8601String(),
    "id": id,
  };
}

class Receiver {
  String? name;
  String? image;
  String? role;
  String? id;

  Receiver({
    this.name,
    this.image,
    this.role,
    this.id,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
    name: json["name"]?.toString(),
    image: json["image"]?.toString(),
    role: json["role"]?.toString(),
    id: json["id"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
    "role": role,
    "id": id,
  };
}

class Product {
  String? id;
  String? image;
  String? title;

  Product({this.id, this.image, this.title});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["_id"]?.toString(),
    image: json["image"]?.toString(),
    title: json["title"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "image": image,
    "title": title,
  };
}
