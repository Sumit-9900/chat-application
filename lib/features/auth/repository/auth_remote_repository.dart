import 'dart:convert';
import 'dart:developer';
// import 'dart:developer';

import 'package:chat_app/core/const/api_constants.dart';
import 'package:chat_app/core/const/app_const.dart';
import 'package:chat_app/core/failure/app_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

abstract interface class AuthRemoteRepository {
  Future<Either<AppFailure, String>> login({required String phoneNumber});
  Future<Either<AppFailure, Map<String, dynamic>>> register({
    required String firstName,
    required String lastName,
    required String authToken,
  });
}

class AuthRemoteRepositoryImpl implements AuthRemoteRepository {
  final http.Client client;
  AuthRemoteRepositoryImpl(this.client);

  @override
  Future<Either<AppFailure, String>> login({
    required String phoneNumber,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.loginApi);

      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"dialCode": "+91", "mobileNumber": phoneNumber}),
      );

      if (res.statusCode != 200) {
        return left(AppFailure(AppConst.errorMssg));
      }

      final decodedData = jsonDecode(res.body);

      // log('Res: $decodedData');

      final authToken = decodedData['resources']['data']['authToken'];
      return right(authToken);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Map<String, dynamic>>> register({
    required String firstName,
    required String lastName,
    required String authToken,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.registerApi);

      final res = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          "firstName": firstName,
          "lastName": lastName,
          "referCodeUsed": "SYS1234",
        }),
      );

      // log('Res: $res');

      if (res.statusCode != 200) {
        return left(AppFailure(AppConst.errorMssg));
      }

      final decodedData = jsonDecode(res.body);

      log('Res: $decodedData');

      final Map<String, dynamic> mapData = decodedData['resources']['data'];

      return right(mapData);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }
}
