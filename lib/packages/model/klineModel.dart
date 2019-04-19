/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: 
 * @Date: 2019-04-16 14:30:22
 * @LastEditTime: 2019-04-16 14:30:27
 */
import 'package:flutter/material.dart';

class Market {
  Market(this.open, this.high, this.low, this.close, this.vol);
  double open;
  double high;
  double low;
  double close;
  double vol;

  //指标线数据
  double priceMa5;
  double priceMa10;
  double priceMa20;
}

class KlineModel {
  Color lineColor;
}

class KlineCandleModel extends KlineModel {
  KlineCandleModel(this.hPrice, this.lPrice, this.openPrice, this.closePrice,
      this.time, this.volume);
  double hPrice;
  double lPrice;
  double openPrice;
  double closePrice;
  int time;
  double volume;
  // 缺张跌幅

}

class KlineColumnarPriceData extends KlineModel {
  KlineColumnarPriceData(this.hPrice, this.lPrice);
  double hPrice;
  double lPrice;
}

class KlineCandleData {
  Offset hPoint;
  Offset lPoint;
  Offset openPoint;
  Offset closePoint;
  double hPrice;
  double lPrice;
  int nDataIndex;
}
