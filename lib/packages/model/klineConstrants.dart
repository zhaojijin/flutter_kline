/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-16 16:45:21
 * @LastEditTime: 2019-04-19 13:18:02
 */

import 'package:flutter/material.dart';

/**********************************kline相关配置**********************************/
/// 烛台宽度
const double kCandlestickWidth = 7.0;
/// 灯芯宽度
const double kWickWidth = 1.0;
/// 烛台间空隙
const double kCandlestickGap = 2.0;
/// 上影线上方距离
const double kTopMargin = 20.0;
const Color kIncreaseColor = Color(0xff47967F);
const Color kDecreaseColor = Color(0xffBF5466);
const Color kBackgroundColor = Color(0xff131C2C);

/**********************************交易量相关配置**********************************/
/// 柱状体宽度
const double kColumnarWidth = kCandlestickWidth;
/// 柱状体之间间隙 = 烛台间空隙
const double kColumnarGap = kCandlestickGap;
const double kColumnarTopMargin = 12.0;

/**********************************网格相关配置**********************************/
/// 网格线颜色
const Color kGridLineColor = Color(0xff263347);
const Color kGridTextColor = Color(0xff7287A5);
const double kGridLineWidth = 0.4;
const double kGridPriceFontSize = 10;
const int kGridRowCount = 4;
const int kGridColumCount = 5;
const int kGridPricePrecision = 7;

/**********************************MA线相关配置**********************************/
/// Ma线宽度
const double kMaLineWidth = 1.0;
const double kMaTopMargin = kTopMargin;
const Color kMa5LineColor = Color(0xffF1DB9D);
const Color kMa10LineColor = Color(0xff81CEBF);
const Color kMa20LineColor = Color(0xffC097F6);


enum YKViewType {
  Kline,
  Volume,
}

enum YKMAType {
  MA5,
  MA10,
  MA20
}