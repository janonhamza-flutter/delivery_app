import 'package:get_storage/get_storage.dart';

class StorageService {
  static final GetStorage _box = GetStorage();

  static const String tokenKey = "token";

  static void saveToken(String token) {
    _box.write(tokenKey, token);
  }

  static String? getToken() {
    return _box.read(tokenKey);
  }

  static void clearToken() {
    _box.remove(tokenKey);
  }
}
