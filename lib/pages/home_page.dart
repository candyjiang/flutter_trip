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
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/widget/sub_nav.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const APPBAR_SCROLL_OFFSET = 100;
  static const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';
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

  /*Widget get _appBar {
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
  }*/

  /*
   * 加载appBar
   */
  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              //AppBar渐变遮罩背景
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80,
            decoration: BoxDecoration(
              color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255),
            ),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2 ? SearchBarType.homeLight : SearchBarType.home,
              //inputBoxClick: _jumpToSearch,
              //speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 0.5),
            ],
          ),
        ),
      ],
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

/*  _jumpToSearch() {
    NavigatorUtil.push(
        context,
        SearchPage(
          hint: SEARCH_BAR_DEFAULT_TEXT,
        ));
  }

  _jumpToSpeak() {
    NavigatorUtil.push(context, SpeakPage());
  }*/
}
