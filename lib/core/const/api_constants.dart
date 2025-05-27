class ApiConstants {
  static const String loginApi = 'http://13.127.170.51:8080/api/v1/user/auth';
  static const String registerApi =
      'http://13.127.170.51:8080/api/v2/user/profile';
  static const String groupListApi =
      'http://13.127.170.51:8080/api/v1/group/list';
  static const socketBaseUrl = 'http://13.127.170.51:8080';
  static const sendMessageApi = '$socketBaseUrl/api/v1/message/send';
}
