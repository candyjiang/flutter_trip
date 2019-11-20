import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav-model.dart';

// 首页-网格入口
class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;

  const GridNav({Key key, this.gridNavModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      // 裁剪
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: _gridNavItems(context),
      ),
    );
  }

  _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    if (gridNavModel == null) {
      return items;
    }
    if (gridNavModel.hotel != null) {
      items.add(_gridNavItem(context, gridNavModel.hotel, true));
    }
    if (gridNavModel.flight != null) {
      items.add(_gridNavItem(context, gridNavModel.flight, false));
    }
    if (gridNavModel.travel != null) {
      items.add(_gridNavItem(context, gridNavModel.travel, false));
    }
    return items;
  }

  _gridNavItem(BuildContext context, GridNavItem gridNavItem, bool isFirst) {
    List<Widget> items = [];
    items.add(_mainItem(context, gridNavItem.mainItem));
    items.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2));
    items.add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4));

    List<Widget> expandItems = [];
    items.forEach((item) {
      expandItems.add(Expanded(child: item, flex: 1));
    });
    Color startColor = Color(int.parse('0xff' + gridNavItem.startColor));
    Color endColor = Color(int.parse('0xff' + gridNavItem.endColor));
    return Container(
      height: 88,
      margin: isFirst ? null : EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        //线性渐变
        gradient: LinearGradient(colors: [startColor, endColor]),
      ),
      child: Row(children: expandItems),
    );
  }

  _mainItem(BuildContext context, CommonModel model) {
    return _wrapGesture(
        context,
        GestureDetector(
          onTap: () {},
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              Image.network(model.icon, width: 121, height: 80, alignment: AlignmentDirectional.bottomEnd),
              Container(
                margin: EdgeInsets.only(top: 11),
                child: Text(model.title, style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
        model);
  }

  _doubleItem(BuildContext context, CommonModel topModel, CommonModel bottomModel) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _item(context, topModel, true),
        ),
        Expanded(
          child: _item(context, bottomModel, false),
        ),
      ],
    );
  }

  _item(BuildContext context, CommonModel model, bool isFirst) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);
    return FractionallySizedBox(
      // 撑满父布局
      widthFactor: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: borderSide,
            bottom: isFirst ? borderSide : BorderSide.none,
          ),
        ),
        child: _wrapGesture(
            context,
            Center(
              child: Text(
                model.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            model),
      ),
    );
  }

  _wrapGesture(BuildContext context, Widget widget, CommonModel model) {
    return GestureDetector(
      onTap: () {},
      child: widget,
    );
  }
}
