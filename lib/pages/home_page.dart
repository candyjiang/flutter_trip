import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home-dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav-model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/widget/grid-nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/local-nav.dart';
import 'package:flutter_trip/widget/sales-box.dart';
import 'package:flutter_trip/widget/sub_nav.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const APPBAR_SCROLL_OFFSET = 100;
  double appBarAlpha = 0;

  List<CommonModel> _bannerList = [];
  List<CommonModel> _localNavList = [];
  List<CommonModel> _subNavList = [];
  GridNavModel _gridNavModel;
  SalesBoxModel _salesBoxModel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  Future<Null> _handleRefresh() async {
    try {
      HomeModel homeModel = await HomeDao.fetch();
      setState(() {
        _isLoading = false;
        _bannerList = homeModel.bannerList;
        _localNavList = homeModel.localNavList;
        _gridNavModel = homeModel.gridNav;
        _subNavList = homeModel.subNavList;
        _salesBoxModel = homeModel.salesBox;
      });
    } catch (e) {
      _isLoading = false;
      print(e);
    }
    return null;
  }

  // ignore: non_constant_identifier_names
  _onScroll(Offset) {
    double alpha = Offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2f2f2),
      body: LoadingContainer(
        isLoading: _isLoading,
        child: Stack(
          children: <Widget>[
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: NotificationListener(
                  // ignore: missing_return
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                      //滚动且是列表滚动的时候
                      _onScroll(scrollNotification.metrics.pixels);
                    }
                  },
                  child: _listView,
                ),
              ),
            ),
            _appBar,
          ],
        ),
      ),
    );
  }

  /*
   * 加载appBar
   */
  Widget get _appBar {
    return Opacity(
      opacity: appBarAlpha,
      child: Container(
        height: 80,
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('首页'),
          ),
        ),
      ),
    );
  }

  /*
   * 加载bodyListView
   */
  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner,
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 0),
          // 球区入口
          child: LocalNav(localNavList: _localNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 0),
          // 网格布局
          child: GridNav(gridNavModel: _gridNavModel),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 0),
          // 运营活动入口
          child: SubNav(subNavList: _subNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 0),
          // 运营活动入口
          child: SalesBox(salesBoxModel: _salesBoxModel),
        ),
      ],
    );
  }

  /*
   * 加载轮播图
   */
  Widget get _banner {
    return Container(
      height: 160,
      child: Swiper(
        itemCount: _bannerList.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(_bannerList[index].icon, fit: BoxFit.fill);
        },
        autoplay: true,
        pagination: SwiperPagination(),
      ),
    );
  }
}
