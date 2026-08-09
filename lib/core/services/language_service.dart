import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageService {
  LanguageService._();

  static final GetStorage _box = GetStorage();
  static const String _langCodeKey = "lang_code";

  static const Locale english = Locale('en', 'US');
  static const Locale arabic = Locale('ar', 'SA');

  static const List<Locale> supportedLocales = [english, arabic];

  // ── Persisted locale ─────────────────────────────────────────────────────

  static Locale get savedLocale {
    final code = _box.read<String>(_langCodeKey);
    return code == arabic.languageCode ? arabic : english;
  }

  static void changeLanguage(Locale locale) {
    _box.write(_langCodeKey, locale.languageCode);
    Get.updateLocale(locale);
  }
}
