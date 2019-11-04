import 'package:flutter/material.dart';
import 'package:llk_app/utils/As.dart';
import 'package:llk_app/utils/LogUtils.dart';

class Not extends Notification{
  Not(this.msg, {this.index});

  final String msg;
  final int index;
}

class MyselfList extends StatefulWidget{

  MyselfListState myselfListState = MyselfListState();

  refreshUserInfo(avatorUrl, nickName){
      myselfListState.refreshUserInfo(avatorUrl, nickName);
  }

  @override
  State<StatefulWidget> createState() {
    return myselfListState;
  }

}

class MyselfListState extends State<MyselfList> {
  static final String TAG = 'MyselfListState';
  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;

  var titles = ["我的消息", "阅读记录", "我的博客", "我的问答", "我的活动", "我的团队", "邀请好友"];
  var imagePaths = [
    As.image('ic_my_message'),
    As.image('ic_my_blog'),
    As.image('ic_my_blog'),
    As.image('ic_my_question'),
    As.image('ic_discover_pos'),
    As.image('ic_my_team'),
    As.image('ic_my_recommend'),
  ];
  var icons = [];
  var userAvatar;
  var userName;
  var titleTextStyle = new TextStyle(fontSize: 16.0);
  var rightArrowIcon = new Image.asset(
    As.image('ic_arrow_right'),
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );


  refreshUserInfo(avatorUrl, nickName){
    LogUtils.d(TAG, 'MyselfListState refreshUserInfo $nickName $avatorUrl');
    setState(() {
      userAvatar = avatorUrl;
      userName = nickName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, i) => _renderItem(context, i),
        separatorBuilder: (context, i) => _renderDivider(i),
        itemCount: titles.length + 1);
  }

  _renderItem(context, i) {
    var itemView;

    if (i == 0) {
      itemView = new Container(
        color: const Color(0xff63ca6c),
        height: 200.0,
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              userAvatar == null
                  ? new Image.asset(
                      As.image('ic_avatar_default'),
                      width: 60.0,
                    )
                  : new Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        image: new DecorationImage(
                            image: new NetworkImage(userAvatar),
                            fit: BoxFit.cover),
                        border: new Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
              new Text(
                userName == null ? "点击头像登录" : userName,
                style: new TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
    } else {
      itemView = Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Row(
          children: <Widget>[
            _getIconImage(imagePaths[i-1]),
            Expanded(
                child: Text(
              titles[i-1],
              style: titleTextStyle,
            )),
            rightArrowIcon
          ],
        ),
      );
    }

    return InkWell(
      child: itemView,
      onTap: () {
        LogUtils.d(TAG, 'myself item=$i');
        if(i == 0){
          Not('topClick').dispatch(context);
        }else{
          Not('itemClick', index: i).dispatch(context);
        }
      },
    );
  }

  _getIconImage(path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child:
          Image.asset(path, width: IMAGE_ICON_WIDTH, height: IMAGE_ICON_WIDTH),
    );
  }

  _renderDivider(i) {
    return Divider(
      height: 1,
    );
  }
}
