import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  // 是否加载中...
  final bool isLoading;

  // 是否覆盖底层布局
  final bool isCover;

  // 底层布局
  final Widget child;

  const LoadingContainer({Key key, @required this.isLoading, this.isCover = false, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !isCover
        ? !isLoading ? child : _loadingView
        : Stack(
            children: <Widget>[
              child,
              isLoading ? _loadingView : Container(),
            ],
          );
  }

  Widget get _loadingView {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
