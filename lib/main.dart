/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: zhaojijin
 * @Date: 2019-04-16 10:21:10
 * @LastEditTime: 2019-04-26 10:30:48
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
                      padding: EdgeInsetsDirectional.only(start: 0),
                      leading: CupertinoButton(
                        padding: EdgeInsets.all(0),
                        child: Icon(Icons.arrow_back,color: Colors.white,),
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      middle: Text('BTC-USDT',style: TextStyle(color: Colors.white),),
                      backgroundColor: kBackgroundColor,
                    ),
                    body: Container(
                      color: kBackgroundColor,
                      child: ListView(
                        children: <Widget>[
                          KlinePageWidget(bloc),
                          Center(
                          
                            child: Container(
                              
                              margin: EdgeInsets.only(top: 20),
                              child: Text(
                              '财富自由，一站拥有',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.blueGrey),
                              ),
                            ))
                        ],
                      ),
                    ));
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
      List<Market> list = List<Market>();
      for (var item in marketData.data) {
        Market market =
            Market(item.open, item.high, item.low, item.close, item.vol);
        market.printDesc();
        list.add(market);
      }
      this.showLoadingSinkAdd(false);
      this.updateDataList(list);
    });
  }
}
