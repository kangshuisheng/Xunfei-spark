import 'dart:async';

import 'package:ai_chat/model/chat_request.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AiChatView extends StatefulWidget {
  const AiChatView({super.key});

  @override
  State<AiChatView> createState() => _AiChatViewState();
}

enum AiChatStatus { connected, disconnected }

enum ApiVersion { v1, v2 }

const Map<ApiVersion, String> versionMap = {
  ApiVersion.v1: 'ws://spark-api.xf-yun.com/v1.1/chat',
  ApiVersion.v2: 'ws://spark-api.xf-yun.com/v2.1/chat',
};

class _AiChatViewState extends State<AiChatView> {
  late final WebSocketChannel channel;
  final TextEditingController _controller = TextEditingController();
  final String _curUrl = versionMap[ApiVersion.v1]!;
  final _AuthorizationGenerator authGenerator = _AuthorizationGenerator();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    debugPrint("init");
    final Uri uri = Uri.parse(_curUrl);
    final String host = uri.host;
    final String path = uri.path;

    debugPrint("host: $host");
    debugPrint("path: $path");

    String date = authGenerator.generateDate();
    String authorization =
        authGenerator.generateAuthorization(host, date, path);
    Map<String, dynamic> queryParams = {
      "authorization": authorization,
      "date": date,
      "host": host,
    };
    String url = "wss://$host$path?${Uri(queryParameters: queryParams).query}";
    debugPrint("url: $url");
    channel = IOWebSocketChannel.connect(url);
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void _send() {
    final input = _controller.text;
    ChatRequest request = ChatRequest(
      header: Header(appId: appId, uid: "xiaozhushou"),
      parameter: Parameter(
        chat: Chat(domain: "general", temperature: 0.6, maxTokens: 64),
      ),
      payload: Payload(
          message: Message(text: [
        MsgText(content: input, role: 'user'),
      ])),
    );
    channel.sink.add(request);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('小助手'),
      ),
      body: Column(
        children: [
          Expanded(
              child: Center(
            child: StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Logger().i(snapshot.data);
                  return Text('Received: ${snapshot.data}');
                } else if (snapshot.hasError) {
                  Logger().e(snapshot.error);
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Text("问点什么吧~");
                }
              },
            ),
          )),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10.0), // 添加水平边距
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '请输入...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // 圆角边框
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0), // 调整内边距
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _send,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
          const SizedBox(height: 10.0)
        ],
      ),
    );
  }
}

String appId = dotenv.env['APP_ID']!;
String apiSecret = dotenv.env['API_SECRET']!;
String apiKey = dotenv.env['API_KEY']!;

class _AuthorizationGenerator {
  String generateAuthorization(String host, String date, String path) {
    String tmp = "host: $host\n";
    tmp += "date: $date\n";
    tmp += "GET $path HTTP/1.1";

    List<int> tmpSha =
        Hmac(sha256, utf8.encode(apiSecret)).convert(utf8.encode(tmp)).bytes;

    String signature = base64.encode(tmpSha);

    String authorizationOrigin =
        'api_key="$apiKey", algorithm="hmac-sha256", headers="host date request-line", signature="$signature"';

    String authorization = base64.encode(utf8.encode(authorizationOrigin));

    return authorization;
  }

  String generateDate() {
    DateTime now = DateTime.now().toUtc();
    String date = HttpDate.format(now);

    return date;
  }
}
