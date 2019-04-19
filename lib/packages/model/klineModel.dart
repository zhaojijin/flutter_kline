/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: 
 * @Date: 2019-04-16 14:30:22
 * @LastEditTime: 2019-04-16 14:30:27
 */

class Market {
  Market(this.open, this.high, this.low, this.close, this.vol);
  double open;
  double high;
  double low;
  double close;
  double vol;

  //指标线数据
  double priceMa1;
  double priceMa2;
  double priceMa3;
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
