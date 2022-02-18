/* 界面控制器组件，主要控制页面切换效果和下面的选项卡菜单 */

import 'package:bp_notepad/localization/appLocalization.dart';
import 'package:bp_notepad/screens/reminderScreen.dart';
import 'package:bp_notepad/screens/historyScreen.dart';
import 'package:bp_notepad/screens/homeScreen.dart';
import 'package:bp_notepad/screens/recordScreen.dart';
import 'package:flutter/cupertino.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    RecordMeun(),
    ReminderScreen(),
    HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          // backgroundColor:
          //     CupertinoTheme.of(context).barBackgroundColor.withOpacity(0.8),
          currentIndex: _selectedIndex,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.heart_fill),
              label: AppLocalization.of(context).translate('home_page'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.doc_chart),
              label: AppLocalization.of(context).translate('function_page'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.alarm),
              label: AppLocalization.of(context).translate('reminder_page'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.gobackward),
              label: AppLocalization.of(context).translate('history_page'),
            ),
          ],
        ),
        tabBuilder: (context, i) {
          return CupertinoPageScaffold(child: _widgetOptions[_selectedIndex]);
        });
  }
}


// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _selectedIndex = 0;
//   PageController _pageController;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       //using this page controller you can make beautiful animation effects
//       _pageController.animateToPage(index,
//           duration: Duration(milliseconds: 350), curve: Curves.easeInOutCubic);
//     });
//   }

//   static List<Widget> _widgetOptions = <Widget>[
//     HomeScreen(),
//     RecordMeun(),
//     ReminderScreen(),
//     HistoryScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: PageView(
//             controller: _pageController,
//             onPageChanged: (index) {
//               setState(() => _selectedIndex = index);
//             },
//             children: _widgetOptions),
//         bottomNavigationBar: CupertinoTabBar(
//           iconSize: 24,
//           items: <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: const Icon(FontAwesomeIcons.chartBar),
//               label: AppLocalization.of(context).translate('home_page'),
//             ),
//             BottomNavigationBarItem(
//               icon: const Icon(FontAwesomeIcons.fileMedicalAlt),
//               label: AppLocalization.of(context).translate('function_page'),
//             ),
//             BottomNavigationBarItem(
//               icon: const Icon(FontAwesomeIcons.bell),
//               label: AppLocalization.of(context).translate('reminder_page'),
//             ),
//             BottomNavigationBarItem(
//               icon: const Icon(FontAwesomeIcons.history),
//               label: AppLocalization.of(context).translate('history_page'),
//             ),
//           ],
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//         ),
//     );
//   }
// }
