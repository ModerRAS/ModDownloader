//drawer_demo.dartimport 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PureDrawer extends StatefulWidget {
  @override
  _PureDrawerState createState() => _PureDrawerState();
}

class _PureDrawerState extends State<PureDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: new GestureDetector(
              onTap: () => print('halfgong'),
              child: new CircleAvatar(
                backgroundImage: new NetworkImage(
                    'https://pic.downk.cc/item/5f31796014195aa5944fd2bd.jpg'),
              ),
            ),
            accountEmail: Text('Halfgong@outlook.com'),
            accountName: Text('龚一半'),
            decoration: BoxDecoration(
              image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://pic.downk.cc/item/5f9e1f771cd1bbb86bf49c90.jpg')),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/keqing.png'),
            ),
            title: Text('刻晴'),
            subtitle: Text('霆霓快雨'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/barbara.png'),
            ),
            title: Text('芭芭拉'),
            subtitle: Text('闪耀偶像'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/mona.png'),
            ),
            title: Text('莫娜'),
            subtitle: Text('星天水镜'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/fiechl.png'),
            ),
            title: Text('菲谢尔'),
            subtitle: Text('断罪皇女！！'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/noelle.png'),
            ),
            title: Text('诺艾尔'),
            subtitle: Text('未受勋之花'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/jean.png'),
            ),
            title: Text('琴'),
            subtitle: Text('蒲公英骑士'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/klee.png'),
            ),
            title: Text('可莉'),
            subtitle: Text('逃跑的太阳'),
          ),
          AboutListTile(
            child: Text('this is a Drawer'),
          )
        ],
      ),
    ));
  }
}
