import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:llk_app/api/Api.dart';
import 'package:llk_app/utils/As.dart';
import 'package:llk_app/utils/LogUtils.dart';
import 'package:llk_app/utils/NetUtils.dart';
import 'package:llk_app/widgets/SlideView.dart';
import 'package:llk_app/widgets/SlideViewIndicator.dart';


final slideViewIndicatorStateKey = GlobalKey<SlideViewIndicatorState>();

class NewsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> {
  static final String TAG = 'NewsPageState';
  final ScrollController _controller = ScrollController();
  List slideData; //轮播数据
  List listData; //列表数据

  int curPage = 1;
  int listTotalSize = 0;
  SlideView slideView;
  SlideViewIndicator indicator;

  TextStyle titleTextStyle = TextStyle(fontSize: 15);
  TextStyle subtitleStyle =
      TextStyle(color: const Color(0xFFB5BDC0), fontSize: 12);

  NewsPageState() {
    //initData();
  }

//  void initData() {
//    // 这里做数据初始化，加入一些测试数据
//    for (int i = 0; i < 3; i++) {
//      Map map = new Map();
//      // 轮播图的资讯标题
//      map['title'] = 'Python 之父透露退位隐情，与核心开发团队产生隔阂';
//      // 轮播图的详情URL
//      map['detailUrl'] =
//          'https://www.oschina.net/news/98455/guido-van-rossum-resigns';
//      // 轮播图的图片URL
//      map['imgUrl'] =
//          'https://static.oschina.net/uploads/img/201807/30113144_1SRR.png';
//      slideData.add(map);
//    }
//    for (int i = 0; i < 30; i++) {
//      Map map = new Map();
//      // 列表item的标题
//      map['title'] = '$i J2Cache 2.3.23 发布，支持 memcached 二级缓存';
//      // 列表item的作者头像URL
//      map['authorImg'] = 'https://static.oschina.net/uploads/user/0/12_50.jpg?t=1421200584000';
//      // 列表item的时间文本
//      map['timeStr'] = '2018/7/30';
//      // 列表item的资讯图片
//      map['thumb'] = 'https://static.oschina.net/uploads/logo/j2cache_N3NcX.png';
//      // 列表item的评论数
//      map['commCount'] = 5;
//      listData.add(map);
//    }
//  }

  @override
  void initState() {
    super.initState();
    LogUtils.d(TAG, 'NewsPageState initState');
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
//      LogUtils.d(TAG, 'controller listener, maxScroll=$maxScroll, pixels=$pixels');
      if (maxScroll == pixels && listData.length < listTotalSize) {
        curPage++;
        getNewsList(true);
      }
    });
    getNewsList(false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _getPageContent(),
    );
  }

  Widget _getPageContent() {
    if (listData != null && listData.isNotEmpty) {
      Widget listviw = ListView.separated(
        itemBuilder: (context, index) => _renderRow(index),
        separatorBuilder: (context, index) => index == 0
            ? Divider(color: Colors.transparent)
            : Divider(color: Colors.red),
        itemCount: listData.length + 1,
        controller: _controller,
      );
      return RefreshIndicator(
        child: listviw,
        onRefresh: _pullToRefresh,
      );
    } else {
      return CircularProgressIndicator(); //圆形加载进度
    }
  }

  getNewsList(bool isLoadMore) {
    String url = Api.newsList;
    url += '?pageIndex=$curPage&pageSize=10';
    LogUtils.d(TAG, 'getNewsList isLoadMore=$isLoadMore, url=$url');
    NetUtils.get(url).then((data) {
      if (data != null) {
//        LogUtils.d(TAG, 'data=$data');
        Map<String, dynamic> map = json.decode(data);
        var _code = map['code'];
        LogUtils.d(TAG, 'getNewsList code=$_code');
        if (_code == 0) {
          var _msg = map['msg'];
          var _listTotal = _msg['news']['total'];
          var _listData = _msg['news']['data'];
          var _slideData = _msg['slide'];
          LogUtils.d(TAG, 'getNewsList listTotal=$_listTotal, list=$_listData, slide=$_slideData');
          setState(() {
            if (!isLoadMore) {
              // 不是加载更多，则直接为变量赋值
              listData = _listData;
              slideData = _slideData;
            } else {
              // 是加载更多，则需要将取到的news数据追加到原来的数据后面
              List list1 = new List();
              // 添加原来的数据
              list1.addAll(listData);
              // 添加新取到的数据
              list1.addAll(_listData);
//              // 判断是否获取了所有的数据，如果是，则需要显示底部的"我也是有底线的"布局
//              if (list1.length >= listTotalSize) {
//                list1.add(Constants.END_LINE_TAG);
//              }
              // 给列表数据赋值
              listData = list1;
              // 轮播图数据
              slideData = _slideData;
            }
          });

          initSlider();
        }
      }
    });
  }

  void initSlider() {
    indicator = SlideViewIndicator(slideData.length, key: slideViewIndicatorStateKey);
    slideView = SlideView(slideData, indicator, slideViewIndicatorStateKey);
  }

  Future<Null> _pullToRefresh() async {
    LogUtils.d(TAG, '_pullToRefresh');
    curPage = 1;
    getNewsList(false);
    return null;
  }

  Widget _renderRow(index) {
    if (index == 0) {
      //头布局
      return Container(
        height: 180,
        child: slideView,
      );
    } else {
      return _makeItem(index - 1);
    }
  }

  Widget _makeItem(index) {
    var itemData = listData[index];
    var titleRow = Row(
      children: <Widget>[
        // 标题充满一整行，所以用Expanded组件包裹
        Expanded(
          child: Text(itemData['title'], style: titleTextStyle),
        )
      ],
    );

    var timeRow = Row(
      children: <Widget>[
        Container(
          // 这是作者头像，使用了圆形头像
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle, // 通过指定shape属性设置图片为圆形
            color: const Color(0xFFECECEC),
            image: DecorationImage(
                image: NetworkImage(itemData['authorImg']), fit: BoxFit.cover),
            border: Border.all(color: const Color(0xFFECECEC), width: 2.0),
          ),
        ),
        Padding(
          // 这是时间文本
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: Text(
            itemData['timeStr'],
            style: subtitleStyle,
          ),
        ),
        Expanded(
          // 这是评论数，评论数由一个评论图标和具体的评论数构成，所以是一个Row组件
          flex: 1,
          child: Row(
            // 为了让评论数显示在最右侧，所以需要外面的Expanded和这里的MainAxisAlignment.end
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text("${itemData['commCount']}", style: subtitleStyle),
              Image.asset(As.image('ic_comment'), width: 16.0, height: 16.0),
            ],
          ),
        )
      ],
    );

    var thumbImgUrl = itemData['thumb'];
    // 这是item右侧的资讯图片，先设置一个默认的图片
    var thumbImg = Container(
      margin: const EdgeInsets.all(10.0),
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFECECEC),
        image: DecorationImage(
            image: thumbImgUrl != null && thumbImgUrl.length > 0
                ? NetworkImage(thumbImgUrl)
                : ExactAssetImage(As.image('ic_img_default')),
            fit: BoxFit.cover),
        border: Border.all(
          color: const Color(0xFFECECEC),
          width: 2.0,
        ),
      ),
    );

    // 这里的row代表了一个ListItem的一行
    var row = new Row(
      children: <Widget>[
        // 左边是标题，时间，评论数等信息
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                titleRow,
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                  child: timeRow,
                )
              ],
            ),
          ),
        ),
        // 右边是资讯图片
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            width: 100.0,
            height: 80.0,
            color: const Color(0xFFECECEC),
            child: Center(
              child: thumbImg,
            ),
          ),
        )
      ],
    );

    return new InkWell(
      child: row,
      onTap: () {
        LogUtils.d(TAG, "news list item click ========= " + index.toString());
      },
    );
  }
}
