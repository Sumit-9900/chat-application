import 'package:chat_app/core/const/app_const.dart';
import 'package:chat_app/features/auth/repository/auth_local_repository.dart';
import 'package:chat_app/features/chat/models/group_model.dart';
import 'package:chat_app/features/chat/view/pages/chat_page.dart';
import 'package:chat_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GroupTile extends StatelessWidget {
  final GroupWithUnread group;
  const GroupTile({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final groupData = group.group;

    // if (groupData == null) return const SizedBox();

    final imageUrl = groupData.file?.localFilePath;
    final message = groupData.latestMessage?.content ?? '';
    final groupId = groupData.id;
    final currentUserId = groupData.latestMessage?.sender?.id ?? '';
    final groupName = groupData.name;

    return Card(
      elevation: 2,
      child: ListTile(
        leading: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl ?? '',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            placeholderFadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
            fadeInDuration: Duration(milliseconds: 150),
            placeholder:
                (context, url) =>
                    const CircularProgressIndicator(strokeWidth: 2),
            errorWidget:
                (context, url, error) =>
                    Image.network(AppConst.demoImageUrl, fit: BoxFit.cover),
          ),
        ),
        title: Text(
          groupName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis),
        onTap: () {
          final token = getIt<AuthLocalRepository>().getPrefsData();

          if (token == null || token.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User token not found.')),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => ChatPage(
                    groupId: groupId,
                    token: token,
                    userId: currentUserId,
                    groupName: groupName,
                  ),
            ),
          );
        },
      ),
    );
  }
}
