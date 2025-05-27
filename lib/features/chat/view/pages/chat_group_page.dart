import 'package:chat_app/core/utils/show_snackbar.dart';
import 'package:chat_app/core/widgets/loader.dart';
import 'package:chat_app/features/auth/view/pages/login_page.dart';
import 'package:chat_app/features/chat/view/widgets/group_tile.dart';
import 'package:chat_app/features/chat/viewmodel/bloc/chat_group_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatGroupPage extends StatefulWidget {
  const ChatGroupPage({super.key});

  @override
  State<ChatGroupPage> createState() => _ChatGroupPageState();
}

class _ChatGroupPageState extends State<ChatGroupPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatGroupBloc>().add(ChatGroupFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Groups')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: BlocConsumer<ChatGroupBloc, ChatGroupState>(
          listener: (context, state) {
            if (state is ChatGroupFailure) {
              showSnackbar(context, message: state.message, color: Colors.red);
            } else if (state is ChatGroupExpired) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (ctx) => const LoginPage()),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is ChatGroupLoading) {
              return const Loader();
            } else if (state is ChatGroupSuccess) {
              final groups = state.groupData;
              return ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return GroupTile(group: group);
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
