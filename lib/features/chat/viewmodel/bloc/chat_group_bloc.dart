import 'package:chat_app/features/auth/repository/auth_local_repository.dart';
import 'package:chat_app/features/chat/models/group_model.dart';
import 'package:chat_app/features/chat/repository/chat_remote_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_group_event.dart';
part 'chat_group_state.dart';

class ChatGroupBloc extends Bloc<ChatGroupEvent, ChatGroupState> {
  final ChatRemoteRepository _chatRemoteRepository;
  final AuthLocalRepository _authLocalRepository;
  ChatGroupBloc({
    required ChatRemoteRepository chatRemoteRepository,
    required AuthLocalRepository authLocalRepository,
  }) : _chatRemoteRepository = chatRemoteRepository,
       _authLocalRepository = authLocalRepository,
       super(ChatGroupInitial()) {
    on<ChatGroupFetched>(_onChatGroup);
  }

  void _onChatGroup(
    ChatGroupFetched event,
    Emitter<ChatGroupState> emit,
  ) async {
    emit(ChatGroupLoading());

    final authToken = _authLocalRepository.getPrefsData();

    final res = await _chatRemoteRepository.groupList(authToken!);

    res.fold((l) {
      if (l.message.contains('Unauthorized')) {
        emit(ChatGroupExpired());
      } else {
        emit(ChatGroupFailure(l.message));
      }
    }, (r) => emit(ChatGroupSuccess(r)));
  }
}
