/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: zhaojijin
 * @Date: 2019-04-16 16:45:21
 * @LastEditTime: 2019-04-26 16:42:32
 */

import 'package:flutter/material.dart';

/********************************kline切换相关配置********************************/
///
const double kPeriodHeight = 40;
const double kPeriodAspectRatio = 375/kPeriodHeight;
const String kDefaultPeriod = '1day';
const List<String> kPeriodList = ['1min', '5min', '15min', '30min', '60min', '1day'];
const List<String> kPeriodTitleList = ['1分', '5分', '15分', '30分', '1小时', '日线'];
const kDefaultPeriodIndex = 5;
/**********************************kline相关配置**********************************/
/// 烛台宽度
const double kCandlestickWidth = 7.0;
/// 灯芯宽度
const double kWickWidth = 1.0;
/// 烛台间空隙
const double kCandlestickGap = 2.0;
/// 上影线上方距离
const double kTopMargin = 30.0;
const Color kDecreaseColor = Color(0xffff4400);
const Color kIncreaseColor = Colors.green;
const Color kBackgroundColor = Color(0xff111825);
const double kcandleAspectRatio = 1;
const Color kCandleTextColor = Colors.white;
const double kCandleFontSize = 9;
const double kCandleTextHight = 12;

/**********************************交易量相关配置**********************************/
/// 柱状体宽度
const double kColumnarWidth = kCandlestickWidth;
/// 柱状体之间间隙 = 烛台间空隙
const double kColumnarGap = kCandlestickGap;
const double kColumnarTopMargin = 32.0;
const double kVolumeAspectRatio = 1/0.25;

/**********************************网格相关配置**********************************/
/// 网格线颜色
const Color kGridLineColor = Color(0xff263347);
const Color kGridTextColor = Color(0xff7287A5);
const double kGridLineWidth = 0.5;
const double kGridPriceFontSize = 10;
const int kGridRowCount = 4;
const int kGridColumCount = 5;
const int kGridPricePrecision = 7;
const double kColumnTopMargin = 20.0;

/**********************************MA线相关配置**********************************/
/// Ma线宽度
const double kMaLineWidth = 1.0;
const double kMaTopMargin = kTopMargin;
const Color kMa5LineColor = Color(0xffF1DB9D);
const Color kMa10LineColor = Color(0xff81CEBF);
const Color kMa20LineColor = Color(0xffC097F6);

/********************************十字交叉线相关配置********************************/
///
const Color kCrossHLineColor = Colors.white;
const Color kCrossVLineColor = Colors.white12;
const Color kCrossPointColor = Colors.white;
const double kCrossHLineWidth = 0.5;
const double kCrossVLineWidth = kCandlestickGap;
const double kCrossPointRadius = 2.0;
const double kCrossTopMargin = 0;

/********************************单个K线信息相关配置********************************/
///
const Color kCandleInfoBgColor = Color(0xff0C1522);
const Color kCandleInfoBorderColor = Color(0xff7286A4);
const Color kCandleInfoTextColor = Color(0xffCFD3E7);
const Color kCandleInfoDecreaseColor = kDecreaseColor;
const Color kCandleInfoIncreaseColor = kIncreaseColor;
const double kCandleInfoLeftFontSize = 10;
const double kCandleInfoRightFontSize = 10;
const double kCandleInfoLeftMargin = 5;
const double kCandleInfoTopMargin = 20;
const double kCandleInfoBorderWidth = 1;
const EdgeInsets kCandleInfoPadding = EdgeInsets.fromLTRB(5, 3, 5, 3);
const double kCandleInfoWidth = 130;
const double kCandleInfoHeight = 137;

enum YKMAType {
  MA5,
  MA10,
  MA30
}