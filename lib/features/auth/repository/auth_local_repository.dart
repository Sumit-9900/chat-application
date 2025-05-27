import 'package:chat_app/core/const/app_const.dart';
import 'package:chat_app/core/failure/app_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthLocalRepository {
  Future<Either<AppFailure, bool>> setPrefsData(String authToken);
  String? getPrefsData();
}

class AuthLocalRepositoryImpl implements AuthLocalRepository {
  final SharedPreferences prefs;
  const AuthLocalRepositoryImpl(this.prefs);

  @override
  Future<Either<AppFailure, bool>> setPrefsData(String authToken) async {
    try {
      final isTokenSet = await prefs.setString(AppConst.prefsKey, authToken);
      return right(isTokenSet);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  String? getPrefsData() {
    final authToken = prefs.getString(AppConst.prefsKey);
    return authToken;
  }
}
