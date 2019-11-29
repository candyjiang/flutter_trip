import 'package:flutter/material.dart';

enum SearchBarType { home, normal, homeLight }

class SearchBar extends StatefulWidget {
  /*是否禁止搜索*/
  final bool enabled;

  /*是否显示左边按钮*/
  final bool hideLeft;

  /*搜索框（类型）位置*/
  final SearchBarType searchBarType;

  /*搜索框hint*/
  final String hint;

  /*搜索框填充文本*/
  final String defaultText;

  /*搜索框左边按钮回调*/
  final void Function() leftButtonClick;

  /*搜索框右边按钮回调*/
  final void Function() rightButtonClick;

  /*搜索框语音按钮回调*/
  final void Function() speakClick;

  /*搜索框输入回调*/
  final void Function() inputBoxClick;

  /*内容变化回调*/
  final ValueChanged<String> onChanged;

  const SearchBar(
      {Key key,
      this.enabled,
      this.hideLeft,
      this.searchBarType,
      this.hint,
      this.defaultText,
      this.leftButtonClick,
      this.rightButtonClick,
      this.speakClick,
      this.inputBoxClick,
      this.onChanged})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (widget.defaultText != null) {
      setState(() {
        _controller.text = widget.defaultText;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal ? _genNormalSearch() : _genHomeSearch();
  }

  _genNormalSearch() {
    // 搜索页搜索框
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
              child: widget?.hideLeft ?? false
                  ? null
                  : Icon(
                      Icons.arrow_back,
                      color: Colors.blueGrey,
                      size: 26,
                    ),
            ),
            widget.leftButtonClick,
          ),
          Expanded(
            flex: 1,
            child: __inputBox(),
          ),
          _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text('搜索', style: TextStyle(color: Colors.blue, fontSize: 17)),
            ),
            widget.rightButtonClick,
          ),
        ],
      ),
    );
  }

  _genHomeSearch() {
    // 首页搜索框
    return Container();
  }

  _wrapTap(Widget widget, void Function() callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) {
          callback();
        }
      },
      child: widget,
    );
  }

  __inputBox() {

  }
}
