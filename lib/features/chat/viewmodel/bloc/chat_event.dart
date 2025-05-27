part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class ChatInit extends ChatEvent {
  final String token;
  final String groupId;

  ChatInit({required this.token, required this.groupId});
}

class ChatSendMessage extends ChatEvent {
  final String message;

  ChatSendMessage(this.message);
}

class ChatReceiveMessage extends ChatEvent {
  final ChatMessage message;

  ChatReceiveMessage(this.message);
}

class ChatDispose extends ChatEvent {}
