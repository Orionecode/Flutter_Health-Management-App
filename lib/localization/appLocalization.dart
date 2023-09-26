/* 本地化内容 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalization {
  final Locale locale;

  AppLocalization(this.locale);

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  // 将json文件读取到一个map中，方便使用
  Map<String, String> _localizedStrings ={};

  // load函数来读取json文件
  Future<void> load() async {
    String jsonStringValues =
        await rootBundle.loadString('lib/lang/${locale.languageCode}.json');
    // 解析json文件
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    // 写入到_localizedStrings中
    _localizedStrings =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  //翻译，translate会在每个widget需要的时候被调用
  String translate(String key) {
    return _localizedStrings[key]!;
  }

  // static member to have simple access to the delegate from Material App
  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationsDelegate();
}

//这是AppLocalizations自己的初始化
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalization> {
  // This delegate instance will never change
  const _AppLocalizationsDelegate();

  
  // 检查是否支持该语言
  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localization = new AppLocalization(locale);
    await localization.load();
    return localization;
  }

  // Reload
  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) => false;
}
