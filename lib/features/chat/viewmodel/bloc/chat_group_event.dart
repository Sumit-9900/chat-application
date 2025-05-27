part of 'chat_group_bloc.dart';

@immutable
sealed class ChatGroupEvent {}

final class ChatGroupFetched extends ChatGroupEvent {}
