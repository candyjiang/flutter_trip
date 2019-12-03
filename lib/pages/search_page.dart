import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/search-dao.dart';
import 'package:flutter_trip/model/search-model.dart';
import 'package:flutter_trip/widget/search_bar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('搜索')),
      body: Column(
        children: <Widget>[
          SearchBar(
            hideLeft: true,
            defaultText: '搜索',
            hint: '搜索城市',
            leftButtonClick: () {
//              Navigator.pop(context);
            },
          ),
          InkWell(
            onTap: () {
              SearchDao.fetch('长城').then((SearchModel model) {
                print(model.data[0].toJson());
              });
            },
            child: Text('get'),
          ),
        ],
      ),
    );
  }
}
