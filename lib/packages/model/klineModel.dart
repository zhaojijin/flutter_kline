/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-16 14:30:22
 * @LastEditTime: 2019-04-23 17:26:46
 */

import 'package:flutter/material.dart';
import 'package:flutter_kline/packages/model/klineConstrants.dart';

class Market {
  Market(this.open, this.high, this.low, this.close, this.vol, {this.isShowCandleInfo});
  double open;
  double high;
  double low;
  double close;
  double vol;

  //指标线数据
  double priceMa1;
  double priceMa2;
  double priceMa3;

  // 十字交叉点
  Offset offset;
  double candleWidgetOriginY;
  double candleWidgetHeight;

  bool isShowCandleInfo;
  // ['时间', '开', '高', '低', '收', '涨跌额', '涨跌幅', '成交量'];
  List<String> candleInfo() {
    double limitUpDownAmount = close-open;
    double limitUpDownPercent = (limitUpDownAmount / open) *100;
    String pre = '';
    if (limitUpDownAmount < 0) {
      pre = '';
    } else if (limitUpDownAmount > 0) {
      pre = '+';
    }
    String limitPercentStr = '$pre${limitUpDownPercent.toStringAsFixed(2)}%';
    return ['xxx',
    open.toStringAsPrecision(kGridPricePrecision),
    high.toStringAsPrecision(kGridPricePrecision),
    low.toStringAsPrecision(kGridPricePrecision),
    close.toStringAsPrecision(kGridPricePrecision),
    limitUpDownAmount.toStringAsPrecision(kGridPricePrecision),
    limitPercentStr,
    vol.toStringAsPrecision(kGridPricePrecision)];
  }
  void printDesc() {
    print('open :$open close :$close high :$high low :$low vol :$vol offset: $offset');
  }
}

class KlineCandleModel {
  KlineCandleModel(this.hPrice, this.lPrice, this.openPrice, this.closePrice,
      this.time, this.volume);
  double hPrice;
  double lPrice;
  double openPrice;
  double closePrice;
  int time;
  double volume;
  // 张跌幅

}
