import 'package:flutter/material.dart';
import 'package:flutter_demo/counter/counter_page.dart';
import 'package:flutter_demo/guess/guess_page.dart';
import 'package:flutter_demo/muyu/muyu_page.dart';
import 'package:flutter_demo/net_article/views/net_articel_page.dart';

import 'app_bottom_bar.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<StatefulWidget> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _index = 0;
  final PageController _ctrl = PageController();

  final List<MenuData> menus = const [
    MenuData(label: '计数器', icon: Icons.numbers_outlined),
    MenuData(label: '猜数字', icon: Icons.question_mark),
    MenuData(label: '电子木鱼', icon: Icons.my_library_music_outlined),
    MenuData(label: '网络文章', icon: Icons.article_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: [
    //     Expanded(child: _buildContent(_index)),
    //     AppBottomBar(
    //         meuns: menus,
    //         currentIndex: _index,
    //         onItemTap: _onChangePage,
    //     )
    //   ],
    // );
    return Scaffold(
        body: Expanded(child: _buildContent(_index)),
        bottomNavigationBar: AppBottomBar(
          meuns: menus,
          currentIndex: _index,
          onItemTap: _onChangePage,
        )
    );
  }

  void _onChangePage(int index) {
    _ctrl.jumpToPage(index);
    setState(() {
      _index = index;
    });
  }

  Widget _buildContent(int index) {
    // switch(index) {
    //   case 0:
    //     return const GuessPage();
    //   case 1:
    //     return const MuyuPage();
    //   default:
    //     return SizedBox.shrink();
    // }
    return PageView(
      physics: const NeverScrollableScrollPhysics(), // 禁止PageView滑动
      controller: _ctrl,
      children: const [
        CounterPage(),
        GuessPage(),
        MuyuPage(),
        NetArticlePage()
      ],
    );
  }
}