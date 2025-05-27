part of 'chat_group_bloc.dart';

@immutable
sealed class ChatGroupState {}

final class ChatGroupInitial extends ChatGroupState {}

final class ChatGroupLoading extends ChatGroupState {}

final class ChatGroupFailure extends ChatGroupState {
  final String message;
  ChatGroupFailure(this.message);
}

final class ChatGroupExpired extends ChatGroupState {}

final class ChatGroupSuccess extends ChatGroupState {
  final List<GroupWithUnread> groupData;
  ChatGroupSuccess(this.groupData);
}
