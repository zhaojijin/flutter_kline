/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: 
 * @Date: 2019-04-16 11:34:08
 * @LastEditTime: 2019-04-16 11:34:44
 */
import 'package:flutter/material.dart';

class KlineDataModel {
  KlineDataModel(
      {Key key,
      this.open,
      this.high,
      this.low,
      this.close,
      this.vol,
      this.amount,
      this.count,
      this.id});
  double open;
  double high;
  double low;
  double close;
  double vol;
  double amount;
  int count;
  int id;
}
