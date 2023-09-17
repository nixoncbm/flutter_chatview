import 'dart:convert';

///chat option
class ChatOption {
  List<MessageOption>? messages;
  int? typeWithChat;

  ChatOption({
    this.messages,
    this.typeWithChat,
  });

  factory ChatOption.fromRawJson(String str) =>
      ChatOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatOption.fromJson(Map<String, dynamic> json) => ChatOption(
    messages: json["messages"] == null
        ? []
        : List<MessageOption>.from(
        json["messages"]!.map((x) => MessageOption.fromJson(x))),
    typeWithChat: json["typeWithChat"],
  );

  Map<String, dynamic> toJson() => {
    "messages": messages == null
        ? []
        : List<dynamic>.from(messages!.map((x) => x.toJson())),
    "typeWithChat": typeWithChat,
  };
}

class MessageOption {
  String? chat;
  dynamic icon;

  MessageOption({
    this.chat,
    this.icon,
  });

  factory MessageOption.fromRawJson(String str) => MessageOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MessageOption.fromJson(Map<String, dynamic> json) => MessageOption(
    chat: json["chat"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "chat": chat,
    "icon": icon,
  };
}