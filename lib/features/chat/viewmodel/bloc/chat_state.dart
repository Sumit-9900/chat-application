part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;

  ChatLoaded(this.messages);
}

final class ChatError extends ChatState {
  final String error;

  ChatError(this.error);
}

final class ChatExpired extends ChatState {}
