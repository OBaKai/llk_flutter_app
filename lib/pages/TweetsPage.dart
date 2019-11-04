import 'package:flutter/material.dart';
import 'package:llk_app/widgets/TweetsList.dart';

class TweetsPage extends StatelessWidget {
  // 热门动弹数据
  List hotTweetsList = [];

  // 普通动弹数据
  List normalTweetsList = [];

  // 屏幕宽度
  double screenWidth;

  // 构造方法中做数据初始化
  TweetsPage() {
    // 添加测试数据
    for (int i = 0; i < 20; i++) {
      Map<String, dynamic> map = new Map();
      // 动弹发布时间
      map['pubDate'] = '2018-7-30';
      // 动弹文字内容
      map['body'] =
          '早上七点十分起床，四十出门，花二十多分钟到公司，必须在八点半之前打卡；下午一点上班到六点，然后加班两个小时；八点左右离开公司，呼呼登自行车到健身房锻炼一个多小时。到家已经十点多，然后准备第二天的午饭，接着收拾厨房，然后洗澡，吹头发，等能坐下来吹头发时已经快十二点了。感觉很累。';
      // 动弹作者昵称
      map['author'] = '红薯';
      // 动弹评论数
      map['commentCount'] = 10;
      // 动弹作者头像URL
      map['portrait'] =
          'https://static.oschina.net/uploads/user/0/12_50.jpg?t=1421200584000';
      // 动弹中的图片，多张图片用英文逗号隔开
      map['imgSmall'] =
          'https://b-ssl.duitang.com/uploads/item/201508/27/20150827135810_hGjQ8.thumb.700_0.jpeg,https://b-ssl.duitang.com/uploads/item/201508/27/20150827135810_hGjQ8.thumb.700_0.jpeg,https://b-ssl.duitang.com/uploads/item/201508/27/20150827135810_hGjQ8.thumb.700_0.jpeg,https://b-ssl.duitang.com/uploads/item/201508/27/20150827135810_hGjQ8.thumb.700_0.jpeg';
      hotTweetsList.add(map);
      normalTweetsList.add(map);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          tabs: <Widget>[Tab(text: "动弹列表"), Tab(text: "热门动弹")],
        ),
        body: TabBarView(
          children: <Widget>[
            TweetsList(normalTweetsList, false),
            TweetsList(hotTweetsList, true),
          ],
        ),
      ),
    );
  }
}
