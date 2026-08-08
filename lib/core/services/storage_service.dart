import 'package:get_storage/get_storage.dart';

class StorageService {
  static final GetStorage _box = GetStorage();

  static const String _tokenKey = "token";
  static const String _activeOrderIdKey = "active_order_id";

  // ── Token ──────────────────────────────────────────────────────────────────

  static void saveToken(String token) => _box.write(_tokenKey, token);

  static String? getToken() => _box.read(_tokenKey);

  static void clearToken() => _box.remove(_tokenKey);

  // ── Active Order ───────────────────────────────────────────────────────────

  static void saveActiveOrderId(int id) => _box.write(_activeOrderIdKey, id);

  static int? getActiveOrderId() => _box.read<int>(_activeOrderIdKey);

  static void clearActiveOrderId() => _box.remove(_activeOrderIdKey);
}
