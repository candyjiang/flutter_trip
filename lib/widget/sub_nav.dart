import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';

/// 首页-运营活动入口
class SubNav extends StatelessWidget {
  final List<CommonModel> subNavList;

  const SubNav({Key key, this.subNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: EdgeInsets.all(6),
        child: _items(context),
      ),
    );
  }

  Widget _items(BuildContext context) {
    List<Widget> items = [];
    if (subNavList == null) {
      return null;
    }
    subNavList.forEach((model) {
      items.add(_item(context, model));
    });

    //计算出第一行显示的数量
    int separate = (subNavList.length / 2 + 0.5).toInt();

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(0, separate),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.sublist(separate, items.length),
          ),
        ),
      ],
    );
  }

  Widget _item(BuildContext context, CommonModel model) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {},
        child: Column(
          children: <Widget>[
            Image.network(model.icon, width: 18, height: 18),
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(model.title, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
