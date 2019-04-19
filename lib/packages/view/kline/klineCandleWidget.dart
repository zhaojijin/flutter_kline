/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-18 12:44:49
 * @LastEditTime: 2019-04-19 13:20:16
 */

import 'package:flutter/material.dart';
import 'package:flutter_kline/packages/bloc/klineBloc.dart';
import 'package:flutter_kline/packages/bloc/klineBlocProvider.dart';
import 'package:flutter_kline/packages/model/klineConstrants.dart';
import 'package:flutter_kline/packages/model/klineModel.dart';

class KlineCandleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KlineBloc bloc = KlineBlocProvider.of<KlineBloc>(context);
    return StreamBuilder(
      stream: bloc.currentKlineListStream,
      builder: (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
        // List<Market> listData =  ?? [Market(0, 0, 0, 0, 0)];
        return CustomPaint(
          size: Size.infinite,
          painter: _CandlePainter(snapshot.data, bloc.priceMax, bloc.priceMin,
              bloc.candlestickWidth),
        );
      },
    );
  }
}

class _CandlePainter extends CustomPainter {
  _CandlePainter(
    this.listData,
    this.priceMax,
    this.priceMin,
    this.candlestickWidth,
  );
  final List<Market> listData;
  final double priceMax;
  final double priceMin;

  /// 烛台宽度
  final double candlestickWidth;

  /// 灯芯宽度
  final double wickWidth = kWickWidth;

  /// 烛台间空隙
  final double candlestickGap = kCandlestickGap;

  /// 上影线上方距离
  final double topMargin = kTopMargin;
  final Color increaseColor = kIncreaseColor;
  final Color decreaseColor = kDecreaseColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (listData == null || priceMax == null || priceMin == null) {
      return;
    }
    double height = size.height - topMargin;
    double heightPriceOffset = 0;
    if ((priceMax - priceMin) != 0) {
      heightPriceOffset = height / (priceMax - priceMin);
    }
    double candlestickLeft;
    double candlestickTop;
    double candlestickRight;
    double candlestickBottom;
    Paint candlestickPaint;
    for (int i = 0; i < listData.length; i++) {
      Market market = listData[i];
      // 画笔
      Color painterColor;
      if (market.open > market.close) {
        painterColor = decreaseColor;
      } else if (market.open == market.close) {
        painterColor = Colors.white;
      } else {
        painterColor = increaseColor;
      }
      candlestickPaint = Paint()
        ..color = painterColor
        ..strokeWidth = wickWidth
        ..isAntiAlias = true
        ..filterQuality = FilterQuality.high;

      // 绘制烛台
      int j = listData.length - 1 - i;
      candlestickLeft =
          j * (candlestickWidth + candlestickGap) + candlestickGap;
      candlestickRight = candlestickLeft + candlestickWidth;
      // print('candlestickLeft: $candlestickLeft === candlestickRight: $candlestickRight    ${listData.length}');
      candlestickTop =
          height - (market.open - priceMin) * heightPriceOffset + topMargin;
      candlestickBottom =
          height - (market.close - priceMin) * heightPriceOffset + topMargin;

      Rect candlestickRect = Rect.fromLTRB(
          candlestickLeft, candlestickTop, candlestickRight, candlestickBottom);
      canvas.drawRect(candlestickRect, candlestickPaint);

      // 绘制上影线/下影线
      double low =
          height - (market.low - priceMin) * heightPriceOffset + topMargin;
      double high =
          height - (market.high - priceMin) * heightPriceOffset + topMargin;
      double candlestickCenterX =
          candlestickLeft + candlestickWidth / 2 - wickWidth / 2;
      Offset highBottomOffset = Offset(candlestickCenterX, candlestickTop);
      Offset highTopOffset = Offset(candlestickCenterX, high);
      Offset lowBottomOffset = Offset(candlestickCenterX, candlestickBottom);
      Offset lowTopOffset = Offset(candlestickCenterX, low);
      canvas.drawLine(highBottomOffset, highTopOffset, candlestickPaint);
      canvas.drawLine(lowBottomOffset, lowTopOffset, candlestickPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return listData != null;
  }
}
