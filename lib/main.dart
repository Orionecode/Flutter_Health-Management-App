/* 主函数入口 */
import 'package:bp_notepad/events/reminderBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:bp_notepad/screens/mainScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bp_notepad/localization/languageConstants.dart';
import 'package:bp_notepad/localization/appLocalization.dart';

List sysSupportedLocales = []; //由于读出的环境语言不止一个所以添加了一个数组保存

void main() {
  runApp(BpNotepad());
}

class BpNotepad extends StatefulWidget {
  const BpNotepad({Key? key}) : super(key: key);
  static void setLocale(BuildContext context, Locale newLocale) {
    _BpNotepadState state = context.findAncestorStateOfType<_BpNotepadState>()!;
    state.setLocale(newLocale);
  }

  @override
  _BpNotepadState createState() => _BpNotepadState();
}

class _BpNotepadState extends State<BpNotepad> {
  late Locale _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReminderBloc>(
        create: (context) => ReminderBloc(),
        child: CupertinoApp(
            debugShowCheckedModeBanner: false,
            locale: _locale,
            supportedLocales: [
              Locale("en", ""),
              Locale("zh", ""),
            ],
            // 本地化代表
            // The delegates collectively define all of the localized resources for this application's Localizations widget.
            // Delegates相当于Flutter和localization的桥梁
            localizationsDelegates: [
              // 先把将json解析
              AppLocalization.delegate,
              // Built in
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            // localization logic，返回需要使用的local，检查我们需要使用的语言是否在supportedLocales当中
            localeResolutionCallback: (locale, supportedLocales) {
              sysSupportedLocales.add(locale?.languageCode);
              for (var supportedLocale in supportedLocales) {
                // 选择首选语言进行语言设置
                if (supportedLocale.languageCode == sysSupportedLocales.first) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            title: "BP Notepad",
            // theme: ThemeData.dark().copyWith(
            //     //颜色主题:.dark是深色模式，.light是浅色模式
            //     primaryColor: const Color(0xFF0A0E21), //颜色:整个主题主要颜色
            //     scaffoldBackgroundColor: const Color(0xFF0A0E21)), //颜色:背景颜色
            home: MyHomePage()));
  }
}
