import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';

/// 首页-球区入口
class LocalNav extends StatelessWidget {
  final List<CommonModel> localNavList;

  const LocalNav({Key key, this.localNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: EdgeInsets.all(6),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (localNavList == null) return null;
    List<Widget> items = [];
    localNavList.forEach((model) {
      items.add(_item(context, model));
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items,
    );
  }

  _item(BuildContext context, CommonModel model) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Image.network(model.icon, width: 32, height: 32),
          Text(model.title, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
