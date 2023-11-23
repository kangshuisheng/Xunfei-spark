class Response {
  final Header header;
  final Payload payload;

  Response({required this.header, required this.payload});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      header: Header.fromJson(json['header']),
      payload: Payload.fromJson(json['payload']),
    );
  }
}

class Header {
  final int code;
  final String message;
  final String sid;
  final int status;

  Header(
      {required this.code,
      required this.message,
      required this.sid,
      required this.status});

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      code: json['code'],
      message: json['message'],
      sid: json['sid'],
      status: json['status'],
    );
  }
}

class Payload {
  final Choices choices;
  final Usage usage;

  Payload({required this.choices, required this.usage});

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      choices: Choices.fromJson(json['choices']),
      usage: Usage.fromJson(json['usage']),
    );
  }
}

class Choices {
  final int status;
  final int seq;
  final List<Text> text;

  Choices({required this.status, required this.seq, required this.text});

  factory Choices.fromJson(Map<String, dynamic> json) {
    return Choices(
      status: json['status'],
      seq: json['seq'],
      text: (json['text'] as List<dynamic>)
          .map((item) => Text.fromJson(item))
          .toList(),
    );
  }
}

class Text {
  final String content;
  final String role;
  final int index;

  Text({required this.content, required this.role, required this.index});

  factory Text.fromJson(Map<String, dynamic> json) {
    return Text(
      content: json['content'],
      role: json['role'],
      index: json['index'],
    );
  }
}

class Usage {
  final TextUsage text;

  Usage({required this.text});

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      text: TextUsage.fromJson(json['text']),
    );
  }
}

class TextUsage {
  final int questionTokens;
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  TextUsage({
    required this.questionTokens,
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory TextUsage.fromJson(Map<String, dynamic> json) {
    return TextUsage(
      questionTokens: json['question_tokens'],
      promptTokens: json['prompt_tokens'],
      completionTokens: json['completion_tokens'],
      totalTokens: json['total_tokens'],
    );
  }
}
