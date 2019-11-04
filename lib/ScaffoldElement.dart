
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:llk_app/utils/As.dart';
import 'package:llk_app/utils/LogUtils.dart';

import 'pages/DiscoveryPage.dart';
import 'pages/MyselfPage.dart';
import 'pages/NewsPage.dart';
import 'pages/TweetsPage.dart';
import 'widgets/MyDrawer.dart';

class ScaffoldElement{
  static const String TAG = 'ScaffoldElement';

  //当前页下标
  int _tabIndex = 0;
  // 页面底部TabItem上的图标数组
  var tabImages;
  // 页面顶部的大标题（也是TabItem上的文本）
  var appBarTitles = ['资讯', '动弹', '发现', '我的'];

  final List<Widget> _pages =
  [ new NewsPage(),
    new TweetsPage(),
    new DiscoveryPage(),
    new MyselfPage()
  ];

  ScaffoldElement(){
    initData();
  }

  // 数据初始化，包括TabIcon数据和页面内容数据
  void initData() {
    if (tabImages == null) {
      tabImages = [
        [
          _getTabImage(As.image('ic_nav_news_normal')),
          _getTabImage(As.image('ic_nav_news_actived'))
        ],
        [
          _getTabImage(As.image('ic_nav_tweet_normal')),
          _getTabImage(As.image('ic_nav_tweet_actived'))
        ],
        [
          _getTabImage(As.image('ic_nav_discover_normal')),
          _getTabImage(As.image('ic_nav_discover_actived'))
        ],
        [
          _getTabImage(As.image('ic_nav_my_normal')),
          _getTabImage(As.image('ic_nav_my_pressed'))
        ]
      ];
    }
    LogUtils.d(TAG, "initData ok");
  }

  void setTabIndex(index){
    _tabIndex = index;
  }

  int getTabIndex() => _tabIndex;

  AppBar getAppBar() =>
      AppBar(
        title: Text(appBarTitles[_tabIndex], style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      );

  CupertinoTabBar getBottomNavigationBar(tapCallback) =>
      CupertinoTabBar(items: getBottomNavItems(),
          currentIndex: _tabIndex,
          onTap: (index){
            tapCallback(index);
          });

  Drawer getDrawer() =>
    Drawer(
      child: MyDrawer(),
    );

  Widget getCurrentPage() =>
    _pages[_tabIndex];

  List<BottomNavigationBarItem> getBottomNavItems() {
    List<BottomNavigationBarItem> list = new List();
    for (int i = 0; i < 4; i++) {
      list.add(new BottomNavigationBarItem(
          icon: _getTabIcon(i),
          title: _getTabTitle(i)
      ));
    }
    return list;
  }

  // 根据索引值确定Tab是选中状态的样式还是非选中状态的样式
  TextStyle _getTabTextStyle(int curIndex) =>
      curIndex==_tabIndex ? TextStyle(color: const Color(0xFF63CA6C), fontSize: 12)
          : TextStyle(color: Colors.black, fontSize: 12);

  // 根据索引值确定TabItem的icon是选中还是非选中
  Image _getTabIcon(int curIndex) =>
      curIndex == _tabIndex ? tabImages[curIndex][1] : tabImages[curIndex][0];

  // 根据索引值返回页面顶部标题
  Text _getTabTitle(int curIndex) =>
      Text(appBarTitles[curIndex], style: _getTabTextStyle(curIndex));

  // 传入图片路径，返回一个Image组件
  Image _getTabImage(path) =>
      Image.asset(path, width: 20.0, height: 20.0);
}