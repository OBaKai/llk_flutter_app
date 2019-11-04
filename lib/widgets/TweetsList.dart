import 'package:flutter/material.dart';
import 'package:llk_app/utils/As.dart';
import 'package:llk_app/utils/LogUtils.dart';

class TweetsList extends StatelessWidget {
  static const String TAG = 'TweetsList';
  List datas;
  bool isHotTab;

  // 动弹作者文本样式
  TextStyle authorTextStyle;

  // 动弹时间文本样式
  TextStyle subtitleStyle;

  TweetsList(datas, isHotTab) {
    this.datas = datas;
    this.isHotTab = isHotTab;

    authorTextStyle = TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);
    subtitleStyle = TextStyle(fontSize: 12.0, color: const Color(0xFFB5BDC0));
  }

  @override
  Widget build(BuildContext context) {
    return _getListView();
  }

  _getListView() => ListView.separated(
      separatorBuilder: (context, index) => Divider(color: Colors.blue),
      itemCount: datas.length,
      itemBuilder: (context, i) => _renderItem(i));

  // 渲染热门动弹列表Item
  _renderItem(i) {
    var listItem = datas[i];

    //头像、昵称、评论数
    var authorRow = Row(
      children: <Widget>[
        // 用户头像
        Container(
          width: 35.0,
          height: 35.0,
          decoration: BoxDecoration(
            // 头像显示为圆形
            shape: BoxShape.circle,
            color: Colors.transparent,
            image: DecorationImage(
                image: NetworkImage(listItem['portrait']), fit: BoxFit.cover),
            // 头像边框
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
          ),
        ),
        // 动弹作者的昵称
        Padding(
            padding: const EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
            child: Text(listItem['author'], style: TextStyle(fontSize: 16.0))),
        // 动弹评论数，显示在最右边
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '${listItem['commentCount']}',
                style: subtitleStyle,
              ),
              Image.asset(
                As.image('ic_comment'),
                width: 16.0,
                height: 16.0,
              )
            ],
          ),
        )
      ],
    );

    //title
    var contentRow = Row(
      children: <Widget>[Expanded(child: Text(listItem['body']))],
    );

    //照片墙
    var picRow = GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      //横向item数量
      primary: false,
      padding: const EdgeInsets.all(12),
      mainAxisSpacing: 12,
      //竖向间距
      crossAxisSpacing: 12,
      //横向间距
      children: buildGridPicList(i),
    );

    //发布时间
    var timeRow = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          listItem['pubDate'],
          style: subtitleStyle,
        )
      ],
    );

    return InkWell(
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
              children: <Widget>[authorRow, contentRow, picRow, timeRow])),
      onTap: () {
        LogUtils.d(TAG, 'tweets item=$i');
      },
    );
  }

  List<Widget> buildGridPicList(index) {
    List<Widget> widgetList = new List();

    var d = datas[index];
    LogUtils.d(TAG, d);
    String pics = d['imgSmall'];
    LogUtils.d(TAG, pics);
    List picUrls = pics.split(',');
    LogUtils.d(TAG, picUrls.toString());

    for (int i = 0; i < picUrls?.length; i++) {
      widgetList.add(InkWell(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: NetworkImage(picUrls[i]),
              fit: BoxFit.cover,
            ),
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: Offset(0.0, 1.0),
                blurRadius: 2.0,
                color: const Color(0xffaaaaaa),
              ),
            ],
          ),
        ),
        onTap: () {
          LogUtils.d(TAG, 'tweets item=$index, picIndex=$i');
        },
      ));
    }
    return widgetList;
  }
}
