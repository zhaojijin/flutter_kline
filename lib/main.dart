/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-16 10:21:10
 * @LastEditTime: 2019-04-19 17:13:38
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kline/example/kline_data_model.dart';
import 'package:flutter_kline/packages/bloc/klineBloc.dart';
import 'package:flutter_kline/packages/klinePage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:convert';

import 'package:flutter_kline/packages/model/klineDataModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Kline Demo',
      home: MyHomePage(title: 'Kline Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    KlinePageBloc bloc = KlinePageBloc();
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text(widget.title),
        ),
        body: Center(
          child: FloatingActionButton(
            child: Icon(Icons.input),
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context){
                return Scaffold(
                  appBar: CupertinoNavigationBar(
                    middle: Text('BTC-USDT'),
                  ),
                  body: Container(
                    // margin: EdgeInsets.only(bottom: 34),
                    height: 500,
                    child: KlinePage(bloc: bloc),
                  ),
                );
              }));
            },
          ),
        ));
  }
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('json/btcusdt.json');
}

class KlinePageBloc extends KlineBloc {
  @override
  void initData() {
    Future<String> future = loadAsset();
    future.then((onValue){
      final parseJson = json.decode(onValue);
      MarketData marketData = MarketData.fromJson(parseJson);
      List<KlineDataModel> list = List<KlineDataModel>();
      for (var item in marketData.data) {
        list.add(KlineDataModel(
          open: item.open,
          close: item.close,
          high: item.high,
          low: item.low,
          vol: item.vol,
          id: item.id
        ));
      }
      this.updateDataList(list);
    });
    super.initData();
  }
}