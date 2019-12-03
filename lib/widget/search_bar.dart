import 'package:flutter/material.dart';

enum SearchBarType { home, normal, homeLight }

class SearchBar extends StatefulWidget {
  /// 是否禁止搜索
  final bool enabled;

  /// 是否显示左边按钮
  final bool hideLeft;

  /// 搜索框（类型）位置
  final SearchBarType searchBarType;

  /// 搜索框hint
  final String hint;

  /// 搜索框填充文本
  final String defaultText;

  /// 搜索框左边按钮回调
  final void Function() leftButtonClick;

  /// 搜索框右边按钮回调
  final void Function() rightButtonClick;

  /// 搜索框语音按钮回调
  final void Function() speakClick;

  /// 搜索框输入回调
  final void Function() inputBoxClick;

  /// 内容变化回调
  final ValueChanged<String> onChanged;

  const SearchBar(
      {Key key,
      this.enabled = true,
      this.hideLeft,
      this.searchBarType = SearchBarType.home,
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

  /// 搜索页搜索框
  Widget _genNormalSearch() {
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
            child: _inputBox(),
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

  /// 首页搜索框
  Widget _genHomeSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
              child: Row(
                children: <Widget>[
                  Text('上海', style: TextStyle(fontSize: 14, color: _homeFontColor())),
                  Icon(Icons.expand_more, size: 22, color: _homeFontColor()),
                ],
              ),
            ),
            widget.leftButtonClick,
          ),
          Expanded(flex: 1, child: _inputBox()),
          _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Icon(
                Icons.comment,
                size: 26,
                color: _homeFontColor(),
              ),
            ),
            widget.rightButtonClick,
          ),
        ],
      ),
    );
  }

  Widget _inputBox() {
    Color inputBoxColor;
    if (widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    } else {
      inputBoxColor = Color(int.parse('0xffEDEDED'));
    }
    return Container(
      height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: inputBoxColor,
        borderRadius: BorderRadius.circular(widget.searchBarType == SearchBarType.normal ? 5 : 15),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            size: 20,
            color: widget.searchBarType == SearchBarType.normal ? Color(0xffA9A9A9) : Colors.blue,
          ),
          Expanded(
            flex: 1,
            child: widget.searchBarType == SearchBarType.normal
                ? TextField(
                    controller: _controller,
                    onChanged: _onChanged,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      border: InputBorder.none,
                      hintText: widget.hint ?? '',
                      hintStyle: TextStyle(fontSize: 15),
                    ),
                  )
                : _wrapTap(
                    Container(
                      child: Text(
                        widget.defaultText,
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                    widget.inputBoxClick,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _wrapTap(Widget widget, void Function() callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) {
          callback();
        }
      },
      child: widget,
    );
  }

  void _onChanged(String text) {
    if (text.length > 0) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }
  }

  Color _homeFontColor() {
    return widget.searchBarType == SearchBarType.homeLight ? Colors.black54 : Colors.white;
  }
}
