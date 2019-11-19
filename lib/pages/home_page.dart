import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home-dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav-model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/widget/grid-nav.dart';
import 'package:flutter_trip/widget/local-nav.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _imageUrls = [
    'https://www.devio.org/io/flutter_app/img/banner/100h10000000q7ght9352.jpg',
    'https://dimg04.c-ctrip.com/images/300h0u000000j05rnD96B_C_500_280.jpg',
    'http://pages.ctrip.com/hotel/201811/jdsc_640es_tab1.jpg',
    'https://dimg03.c-ctrip.com/images/fd/tg/g1/M03/7E/19/CghzfVWw6OaACaJXABqNWv6ecpw824_C_500_280_Q90.jpg'
  ];

  static const APPBAR_SCROLL_OFFSET = 100;

  double appBarAlpha = 0;

  List<CommonModel> _localNavList;

  GridNavModel _gridNavModel;

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
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    try {
      HomeModel homeModel = await HomeDao.fetch();
      setState(() {
        _localNavList = homeModel.localNavList;
        _gridNavModel = homeModel.gridNav;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2f2f2),
      body: Stack(
        children: <Widget>[
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: NotificationListener(
              // ignore: missing_return
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                  //滚动且是列表滚动的时候
                  _onScroll(scrollNotification.metrics.pixels);
                }
              },
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 160,
                    child: Swiper(
                      itemCount: _imageUrls.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Image.network(_imageUrls[index], fit: BoxFit.fill);
                      },
                      autoplay: true,
                      pagination: SwiperPagination(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                    child: LocalNav(localNavList: _localNavList),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                    child: GridNav(gridNavModel: _gridNavModel),
                  ),
                  Container(
                    height: 500,
                    child: ListTile(
                      title: Text(''),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Opacity(
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
          )
        ],
      ),
    );
  }
}
