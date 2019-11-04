import 'package:flutter/material.dart';
import 'package:llk_app/utils/As.dart';
import 'package:llk_app/utils/LogUtils.dart';

class DiscoveryList extends StatelessWidget {
  static final String TAG = 'DiscoveryList';
  // 菜单图标的大小
  static const double IMAGE_ICON_WIDTH = 30.0;

  // 菜单后面箭头的大小
  static const double ARROW_ICON_WIDTH = 16.0;



  // 菜单图片资源
  final imagePaths = [
    As.image('ic_discover_softwares'),
    As.image('ic_discover_git'),
    As.image('ic_discover_gist'),
    As.image('ic_discover_scan'),
    As.image('ic_discover_shake'),
    As.image('ic_discover_nearby'),
    As.image('ic_discover_pos'),
  ];

  // 菜单文本
  final titles = ["开源软件", "码云推荐", "代码片段", "扫一扫", "摇一摇", "码云封面人物", "线下活动"];

  // 菜单右箭头
  final rightArrowIcon = new Image.asset(
    As.image('ic_arrow_right'),
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );

  // 菜单文本样式
  final titleTextStyle = new TextStyle(fontSize: 16.0);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, i) => _renderItem(i),
        separatorBuilder: (context, i) => _renderDivider(i),
        itemCount: imagePaths.length


    );
  }
  
  _renderItem(i){
    // 菜单项
    var listItemContent = Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
      child: Row(
        children: <Widget>[
          _getIconImage(imagePaths[i]),
          Expanded(
              child: Text(titles[i], style: titleTextStyle,)
          ),
          rightArrowIcon
        ],
      ),
    );

    return InkWell(
      child: listItemContent,
      onTap: (){
        LogUtils.d(TAG, 'discovery item=$i');
      },
    );
  }

  _getIconImage(path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child: Image.asset(path, width: IMAGE_ICON_WIDTH, height: IMAGE_ICON_WIDTH),
    );
  }

  _renderDivider(i){
    return Divider(height: 1,);
  }
  
}
