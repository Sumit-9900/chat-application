import 'package:chat_app/features/chat/models/chat_model.dart';
import 'package:chat_app/features/chat/repository/chat_remote_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRemoteRepository _chatRemoteRepository;
  final List<ChatMessage> _messages = [];

  ChatBloc({required ChatRemoteRepository chatRemoteRepository})
    : _chatRemoteRepository = chatRemoteRepository,
      super(ChatInitial()) {
    on<ChatInit>(_onInit);
    on<ChatSendMessage>(_onSendMessage);
    on<ChatReceiveMessage>(_onReceiveMessage);
    on<ChatDispose>(_onDispose);
  }

  void _onInit(ChatInit event, Emitter<ChatState> emit) {
    _chatRemoteRepository.initSocket(
      token: event.token,
      groupId: event.groupId,
    );

    _chatRemoteRepository.messageStream.listen((message) {
      add(ChatReceiveMessage(message));
    });

    emit(ChatLoaded(_messages));
  }

  void _onSendMessage(ChatSendMessage event, Emitter<ChatState> emit) async {
    final result = await _chatRemoteRepository.sendMessage(
      token: _chatRemoteRepository.authToken,
      groupId: _chatRemoteRepository.groupId,
      content: event.message,
    );

    result.fold((failure) {
      if (failure.message.contains('Unauthorized')) {
        emit(ChatExpired());
      } else {
        emit(ChatError(failure.message));
      }
    }, (_) {});
  }

  void _onReceiveMessage(ChatReceiveMessage event, Emitter<ChatState> emit) {
    _messages.insert(0, event.message);
    emit(ChatLoaded(List.from(_messages)));
  }

  void _onDispose(ChatDispose event, Emitter<ChatState> emit) {
    _chatRemoteRepository.leaveSocket(_chatRemoteRepository.groupId);
  }
}
