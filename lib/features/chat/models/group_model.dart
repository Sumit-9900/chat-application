class GroupListModel {
  final bool status;
  final int code;
  final String message;
  final List<GroupWithUnread> groups;

  GroupListModel({
    required this.status,
    required this.code,
    required this.message,
    required this.groups,
  });

  factory GroupListModel.fromJson(Map<String, dynamic> json) {
    final data = json['resources']?['data'] as List<dynamic>? ?? [];
    return GroupListModel(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      groups: data.map((e) => GroupWithUnread.fromJson(e)).toList(),
    );
  }
}

class GroupWithUnread {
  final Group group;
  final int unreadCount;

  GroupWithUnread({required this.group, required this.unreadCount});

  factory GroupWithUnread.fromJson(Map<String, dynamic> json) {
    return GroupWithUnread(
      group: Group.fromJson(json['group']),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}

class Group {
  final String id;
  final String name;
  final String? description;
  final GroupFile? file;
  final GroupMessage? latestMessage;

  Group({
    required this.id,
    required this.name,
    this.description,
    this.file,
    this.latestMessage,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      file: json['file'] != null ? GroupFile.fromJson(json['file']) : null,
      latestMessage:
          json['latestMessage'] != null
              ? GroupMessage.fromJson(json['latestMessage'])
              : null,
    );
  }
}

class GroupFile {
  final String localFilePath;
  final String? mimeType;

  GroupFile({required this.localFilePath, this.mimeType});

  factory GroupFile.fromJson(Map<String, dynamic> json) {
    return GroupFile(
      localFilePath: json['localFilePath'] ?? '',
      mimeType: json['mimeType'],
    );
  }
}

class GroupMessage {
  final String id;
  final String content;
  final String? type;
  final DateTime? createdAt;
  final GroupUser? sender;

  GroupMessage({
    required this.id,
    required this.content,
    this.type,
    this.createdAt,
    this.sender,
  });

  factory GroupMessage.fromJson(Map<String, dynamic> json) {
    return GroupMessage(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      type: json['type'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      sender:
          json['sender'] != null ? GroupUser.fromJson(json['sender']) : null,
    );
  }
}

class GroupUser {
  final String id;

  GroupUser({required this.id});

  factory GroupUser.fromJson(Map<String, dynamic> json) {
    return GroupUser(id: json['_id'] ?? '');
  }
}
