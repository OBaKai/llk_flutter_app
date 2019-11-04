

import 'package:flutter/material.dart';
import 'package:llk_app/utils/As.dart';
import 'package:llk_app/utils/LogUtils.dart';

class MyDrawer extends StatelessWidget{

  static final String TAG = 'MyDrawer';

  final List titles = ['发布动态', '动态小黑屋', '关于', '设置'];
  final List icons = [
    As.menu('ic_fabu'),
    As.menu('ic_xiaoheiwu'),
    As.menu('ic_about'),
    As.menu('ic_settings')
  ];

  // icon size
  static const double IMAGE_ICON_WIDTH = 30.0;

  //箭头view
  var rightArrowIcon = new Image.asset(
      As.image('ic_arrow_right'),
    width: 16,
    height: 16,
  );

  //文本样式
  TextStyle titleStyle = new TextStyle(
      fontSize: 16,
      color: Colors.green
  );

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
        constraints: const BoxConstraints.expand(width: 300), //侧滑菜单宽度
      child: Material(
        elevation: 16, //drawer后面的阴影大小
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
          ),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                flexibleSpace: Image.asset(As.image('cover_img')),
                backgroundColor: Colors.transparent,
                expandedHeight: 300,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index)=>
                    ListTile(
                      leading: Padding(
                        child: Image.asset(icons[index], width: 30, height: 30),
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      ),
                      title: Text(titles[index], style: TextStyle(fontSize: 20, color: Colors.red)),
                      onTap: ()=>{
                        onDrawerItemClick(index)
                      },
                    ),
                  childCount: titles.length,
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onDrawerItemClick(index){
      LogUtils.d(TAG, "============= " + index.toString());
  }
}