
class InboxModel {
  String? conversationId;
  String? text;
  String? imageUrl;
  bool? seen;
  MsgByUserId? msgByUserId;
  DateTime? createdAt;
  String? id;

  InboxModel({
    this.conversationId,
    this.text,
    this.imageUrl,
    this.seen,
    this.msgByUserId,
    this.createdAt,
    this.id,
  });

  factory InboxModel.fromJson(Map<String, dynamic> json) => InboxModel(
    conversationId: json["conversationId"],
    text: json["text"],
    imageUrl: json["imageUrl"],
    seen: json["seen"],
    msgByUserId: json["msgByUserId"] == null ? null : MsgByUserId.fromJson(json["msgByUserId"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "conversationId": conversationId,
    "text": text,
    "imageUrl": imageUrl,
    "seen": seen,
    "msgByUserId": msgByUserId?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "id": id,
  };
}

class MsgByUserId {
  String? name;
  String? email;
  String? image;
  String? id;

  MsgByUserId({
    this.name,
    this.email,
    this.image,
    this.id,
  });

  factory MsgByUserId.fromJson(Map<String, dynamic> json) => MsgByUserId(
    name: json["name"],
    email: json["email"],
    image: json["image"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "image": image,
    "id": id,
  };
}
