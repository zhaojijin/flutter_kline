/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-16 15:02:34
 * @LastEditTime: 2019-04-19 16:57:55
 */
import 'dart:math';

import 'package:flutter_kline/packages/bloc/klineBlocProvider.dart';
import 'package:flutter_kline/packages/manager/klineDataManager.dart';
import 'package:flutter_kline/packages/model/klineDataModel.dart';
import 'package:flutter_kline/packages/model/klineModel.dart';
import 'package:flutter_kline/packages/model/klineConstrants.dart';
import 'package:rxdart/rxdart.dart';

class KlineBloc extends KlineBlocBase {
  BehaviorSubject<List<Market>> _klineListSubject =
      BehaviorSubject<List<Market>>();
  PublishSubject<List<Market>> _klineCurrentListSubject =
      PublishSubject<List<Market>>();

  // 总数据的流入流出
  Sink<List<Market>> get _klineListSink => _klineListSubject.sink;
  Stream<List<Market>> get klineListStream => _klineListSubject.stream;

  // 当前数据的流入流出
  Sink<List<Market>> get _currentKlineListSink => _klineCurrentListSubject.sink;
  Stream<List<Market>> get currentKlineListStream =>
      _klineCurrentListSubject.stream;

  /// 单屏显示的kline数据
  List<Market> klineCurrentList = List();

  /// 总数据
  List<Market> klineTotalList = List();

  /// 当前K线滑到的位置
  int currentIndex = 0;

  double screenWidth = 375;
  double priceMax;
  double priceMin;
  double volumeMax;
  int singleScreenCandleCount;
  int firstScreenCandleCount;
  double candlestickWidth = kCandlestickWidth;

  KlineBloc() {
    initData();
  }

  void initData() {}

  @override
  void dispose() {
    _klineListSubject.close();
    _klineCurrentListSubject.close();
  }

  void updateDataList(List<KlineDataModel> dataList) {
    if (dataList != null && dataList.length > 0) {
      klineTotalList.clear();
      for (var item in dataList) {
        Market data =
            Market(item.open, item.high, item.low, item.close, item.vol);
        klineTotalList.add(data);
      }
      klineTotalList = KlineDataManager.calculateKlineData(YKChartType.MA, klineTotalList);
      // klineTotalList = [klineTotalList.first];
      _klineListSink.add(klineTotalList);
    }
  }

  void setCandlestickWidth(double scaleWidth) {
      if (scaleWidth > 20 || scaleWidth < 1) {
        return;
      }
      this.candlestickWidth = scaleWidth;
  }

  void setSingleScreenCandleCount(double width) {
    screenWidth = width;
    // count *(candlestickWith + candlestickGap) + candlestickGap = screenWidth
    double count = (screenWidth - kCandlestickGap) / (candlestickWidth + kCandlestickGap);
    int totalScreenCountNum = count.toInt();
    singleScreenCandleCount = totalScreenCountNum;
    int maxCount = this.klineTotalList.length;
    int firstScreenNum = (((kGridColumCount-1)/kGridColumCount) * singleScreenCandleCount).toInt(); 
    if (singleScreenCandleCount > maxCount) {
      firstScreenNum = maxCount;
    } 
    currentIndex = firstScreenNum;
    firstScreenCandleCount = firstScreenNum;
  }

  void setScreenWidth(double width) {
    setSingleScreenCandleCount(width);
    getSubKlineList(0, firstScreenCandleCount);
  }

  void getSubKlineList(int from, int to) {
    List<Market> list = this.klineTotalList;
    klineCurrentList.clear();
    klineCurrentList = list.sublist(from, to);
    _calculateCurrentKlineDataLimit();
    _currentKlineListSink.add(klineCurrentList);
  }

  void _calculateCurrentKlineDataLimit() {
    double _priceMax = -double.infinity;
    double _priceMin = double.infinity;
    double _volumeMax = -double.infinity;
    for (var item in klineCurrentList) {
      _volumeMax = max(item.vol, _volumeMax);

      _priceMax = max(_priceMax, item.high);
      _priceMin = min(_priceMin, item.low);

      /// 与x日均线数据对比计算最高最低价格
      if (item.priceMa5 != null) {
        _priceMax = max(_priceMax, item.priceMa5);
        _priceMin = min(_priceMin, item.priceMa5);
      }
      if (item.priceMa10 != null) {
        _priceMax = max(_priceMax, item.priceMa10);
        _priceMin = min(_priceMin, item.priceMa10);
      }
      if (item.priceMa20 != null) {
        _priceMax = max(_priceMax, item.priceMa20);
        _priceMin = min(_priceMin, item.priceMa20);
      }
      priceMax = _priceMax;
      priceMin = _priceMin;
      volumeMax = _volumeMax;
    }
  }
}
