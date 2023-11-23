class ChatRequest {
  final Header header;
  final Parameter parameter;
  final Payload payload;

  ChatRequest(
      {required this.header, required this.parameter, required this.payload});

  factory ChatRequest.fromJson(Map<String, dynamic> json) {
    return ChatRequest(
      header: Header.fromJson(json['header']),
      parameter: Parameter.fromJson(json['parameter']),
      payload: Payload.fromJson(json['payload']),
    );
  }
}

class Header {
  final String appId;
  final String uid;

  Header({required this.appId, required this.uid});

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      appId: json['app_id'],
      uid: json['uid'],
    );
  }
}

class Parameter {
  final Chat chat;

  Parameter({required this.chat});

  factory Parameter.fromJson(Map<String, dynamic> json) {
    return Parameter(
      chat: Chat.fromJson(json['chat']),
    );
  }
}

class Chat {
  final String domain;
  final double temperature;
  final int maxTokens;

  Chat(
      {required this.domain,
      required this.temperature,
      required this.maxTokens});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      domain: json['domain'],
      temperature: json['temperature'],
      maxTokens: json['max_tokens'],
    );
  }
}

class Payload {
  final Message message;

  Payload({required this.message});

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      message: Message.fromJson(json['message']),
    );
  }
}

class Message {
  final List<MsgText> text;

  Message({required this.text});

  factory Message.fromJson(Map<String, dynamic> json) {
    var textList = json['text'] as List;
    List<MsgText> text =
        textList.map((textJson) => MsgText.fromJson(textJson)).toList();

    return Message(text: text);
  }
}

class MsgText {
  final String role;
  final String content;

  MsgText({required this.role, required this.content});

  factory MsgText.fromJson(Map<String, dynamic> json) {
    return MsgText(
      role: json['role'],
      content: json['content'],
    );
  }
}
