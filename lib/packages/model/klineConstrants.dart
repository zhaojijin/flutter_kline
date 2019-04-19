/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-16 16:45:21
 * @LastEditTime: 2019-04-18 17:52:18
 */

import 'package:flutter/material.dart';

/**********************************kline相关配置**********************************/
/// 烛台宽度
const double kCandlestickWidth = 7.0;
/// 灯芯宽度
const double kWickWidth = 1.0;
/// 烛台间空隙
const double kCandlestickGap = 1.0;
/// 上影线上方距离
const double kTopMargin = 20.0;
const Color kIncreaseColor = Colors.green;
const Color kDecreaseColor = Colors.red;
const Color kBackgroundColor = Colors.black;

/**********************************交易量相关配置**********************************/
/// 柱状体宽度
const double kColumnarWidth = kCandlestickWidth;
/// 柱状体之间间隙 = 烛台间空隙
const double kColumnarGap = kCandlestickGap;
const double kColumnarTopMargin = 12.0;

/**********************************网格相关配置**********************************/
/// 网格线颜色
const Color kGridLineColor = Color.fromRGBO(255, 255, 255, 0.4);
const double kGridLineWidth = 0.5;
const double kGridPriceFontSize = 10;
const int kGridRowCount = 4;
const int kGridColumCount = 5;
const int kGridPricePrecision = 7;

/**********************************MA线相关配置**********************************/
/// Ma线宽度
const double kMaLineWidth = 1.0;
const double kMaTopMargin = kTopMargin;
const Color kMa5LineColor = Colors.yellow;
const Color kMa10LineColor = Colors.blue;
const Color kMa20LineColor = Colors.purple;


enum YKViewType {
  Kline,
  Volume,
}

enum YKMAType {
  MA5,
  MA10,
  MA20
}