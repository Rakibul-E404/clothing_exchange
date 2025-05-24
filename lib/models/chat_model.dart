class MessagesResponse {
  final int code;
  final String message;
  final MessagesData data;

  MessagesResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory MessagesResponse.fromJson(Map<String, dynamic> json) {
    return MessagesResponse(
      code: json['code'],
      message: json['message'],
      data: MessagesData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'message': message,
    'data': data.toJson(),
  };
}

class MessagesData {
  final Attributes attributes;

  MessagesData({required this.attributes});

  factory MessagesData.fromJson(Map<String, dynamic> json) {
    return MessagesData(
      attributes: Attributes.fromJson(json['attributes']),
    );
  }

  Map<String, dynamic> toJson() => {
    'attributes': attributes.toJson(),
  };
}

class Attributes {
  final List<Message> data;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  Attributes({
    required this.data,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Message> messagesList = list.map((i) => Message.fromJson(i)).toList();

    return Attributes(
      data: messagesList,
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
      totalResults: json['totalResults'],
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    'page': page,
    'limit': limit,
    'totalPages': totalPages,
    'totalResults': totalResults,
  };
}

class Message {
  final String conversationId;
  final String text;
  final String imageUrl;
  final bool seen;
  final MsgByUser msgByUserId;
  final DateTime createdAt;
  final String id;

  Message({
    required this.conversationId,
    required this.text,
    required this.imageUrl,
    required this.seen,
    required this.msgByUserId,
    required this.createdAt,
    required this.id,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      conversationId: json['conversationId'],
      text: json['text'],
      imageUrl: json['imageUrl'],
      seen: json['seen'],
      msgByUserId: MsgByUser.fromJson(json['msgByUserId']),
      createdAt: DateTime.parse(json['createdAt']),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'conversationId': conversationId,
    'text': text,
    'imageUrl': imageUrl,
    'seen': seen,
    'msgByUserId': msgByUserId.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'id': id,
  };
}

class MsgByUser {
  final String email;
  final String image;
  final String id;

  MsgByUser({
    required this.email,
    required this.image,
    required this.id,
  });

  factory MsgByUser.fromJson(Map<String, dynamic> json) {
    return MsgByUser(
      email: json['email'],
      image: json['image'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'image': image,
    'id': id,
  };
}
