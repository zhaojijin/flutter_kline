/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-16 10:21:10
 * @LastEditTime: 2019-04-24 15:23:06
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kline/example/kline_data_model.dart';
import 'package:flutter_kline/packages/bloc/klineBloc.dart';
import 'package:flutter_kline/packages/klinePage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_kline/packages/model/klineConstrants.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_kline/packages/model/klineDataModel.dart';
import 'package:flutter_kline/packages/model/klineModel.dart';

import 'package:http/http.dart' as http;

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
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
                return Scaffold(
                  appBar: CupertinoNavigationBar(
                    middle: Text('BTC-USDT'),
                  ),
                  body: Container(
                    // margin: EdgeInsets.only(bottom: 34),
                    height: 500,
                    child: KlinePageWidget(bloc),
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

Future<String> getIPAddress(String period) async {
  if (period == null) {
    period = '1day';
  }
  var url =
      'https://api.huobi.br.com/market/history/kline?period=$period&size=449&symbol=btcusdt';
  String result;
  var response = await http.get(url);
  if (response.statusCode == HttpStatus.ok) {
    result = response.body;
  } else {
    print('Failed getting IP address');
  }
  return result;
}

class KlinePageBloc extends KlineBloc {
  @override
  void periodSwitch(String period) {
    _getData(period);
    super.periodSwitch(period);
  }
  @override
  void initData() {
    _getData('1day');
    super.initData();
  }
   _getData(String period) {
    this.showLoadingSinkAdd(true);
    Future<String> future = getIPAddress('$period');
    future.then((result) {
      final parseJson = json.decode(result);
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
      this.showLoadingSinkAdd(false);
      this.updateDataList(list);
    });
  }
    
}