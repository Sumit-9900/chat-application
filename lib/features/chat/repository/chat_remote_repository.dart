import 'dart:async';
import 'dart:convert';
import 'package:chat_app/core/const/api_constants.dart';
import 'package:chat_app/core/const/app_const.dart';
import 'package:chat_app/core/failure/app_failure.dart';
import 'package:chat_app/features/chat/models/chat_model.dart';
import 'package:chat_app/features/chat/models/group_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract interface class ChatRemoteRepository {
  Future<Either<AppFailure, List<GroupWithUnread>>> groupList(String authToken);
  void initSocket({required String token, required String groupId});
  Future<Either<AppFailure, Unit>> sendMessage({
    required String token,
    required String groupId,
    required String content,
  });
  void leaveSocket(String groupId);
  Stream<ChatMessage> get messageStream;

  String get authToken;
  String get groupId;
}

class ChatRemoteRepositoryImpl implements ChatRemoteRepository {
  final http.Client client;
  ChatRemoteRepositoryImpl(this.client);

  late IO.Socket _socket;

  String? _authToken;
  String? _groupId;

  final _controller = StreamController<ChatMessage>.broadcast();

  @override
  Future<Either<AppFailure, List<GroupWithUnread>>> groupList(
    String authToken,
  ) async {
    try {
      final url = Uri.parse(ApiConstants.groupListApi);
      final res = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (res.statusCode == 401) {
        return left(AppFailure('Unauthorized - Token expired'));
      }

      if (res.statusCode != 200) {
        return left(AppFailure(AppConst.errorMssg));
      }

      final decodedData = jsonDecode(res.body);
      final groupListResponse = GroupListModel.fromJson(decodedData);
      final groups = groupListResponse.groups;

      return right(groups);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  void initSocket({required String token, required String groupId}) {
    _authToken = token;
    _groupId = groupId;

    _socket = IO.io(
      ApiConstants.socketBaseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .setQuery({'_id': groupId})
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      _socket.emit('join-chat', {'_id': groupId});
    });

    _socket.on('new-message', (data) {
      _controller.add(ChatMessage.fromJson(data));
    });

    _socket.onDisconnect((_) {});
    _socket.on('server-error', (data) => debugPrint("Server Error: $data"));
  }

  @override
  Future<Either<AppFailure, Unit>> sendMessage({
    required String token,
    required String groupId,
    required String content,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.sendMessageApi);
      final req =
          http.MultipartRequest('POST', url)
            ..headers['Authorization'] = 'Bearer $token'
            ..fields['group'] = groupId
            ..fields['content'] = content;

      final res = await req.send();

      if (res.statusCode == 401) {
        return left(AppFailure('Unauthorized - Token expired'));
      }

      if (res.statusCode != 200) {
        return left(AppFailure(AppConst.errorMssg));
      }

      return right(unit);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Stream<ChatMessage> get messageStream => _controller.stream;

  @override
  void leaveSocket(String groupId) {
    _socket.emit('leave-chat', {"_id": groupId});
    _socket.dispose();
    _controller.close();
  }

  @override
  String get authToken => _authToken ?? '';

  @override
  String get groupId => _groupId ?? '';
}
