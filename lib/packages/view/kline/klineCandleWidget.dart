/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: zhaojijin
 * @Date: 2019-04-18 12:44:49
 * @LastEditTime: 2019-08-20 15:16:52
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
        return CustomPaint(
          key: bloc.candleWidgetKey,
          size: Size(bloc.screenWidth, bloc.screenWidth / kcandleAspectRatio),
          painter: _CandlePainter(
              listData: snapshot.data,
              priceMax: bloc.priceMax,
              priceMin: bloc.priceMin,
              pMax: bloc.pMax,
              pMin: bloc.pMin,
              candlestickWidth: bloc.candlestickWidth),
        );
      },
    );
  }
}

class _CandlePainter extends CustomPainter {
  _CandlePainter({
    @required this.listData,
    @required this.priceMax,
    @required this.priceMin,
    @required this.pMax,
    @required this.pMin,
    @required this.candlestickWidth,
  });
  final List<Market> listData;
  final double priceMax;
  final double priceMin;
  final double pMax;
  final double pMin;

  /// 烛台宽度
  final double candlestickWidth;

  /// 灯芯宽度
  final double wickWidth = kWickWidth;

  /// 烛台间空隙
  final double candlestickGap = kCandlestickGap;

  /// 上影线上方距离
  final double topMargin = kTopMargin + kCandleTextHight / 2;
  final Color increaseColor = kIncreaseColor;
  final Color decreaseColor = kDecreaseColor;
  final double candleTextHight = kCandleTextHight;

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = Colors.black
      ..blendMode = BlendMode.colorBurn
      ..strokeWidth = 0.5;
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), linePaint);
    if (listData == null || priceMax == null || priceMin == null) {
      return;
    }
    double height = size.height - topMargin - kCandleTextHight / 2;
    double heightPriceOffset = 0;
    if ((priceMax - priceMin) != 0) {
      heightPriceOffset = height / (priceMax - priceMin);
    }
    double candlestickLeft;
    double candlestickTop;
    double candlestickRight;
    double candlestickBottom;
    Paint candlestickPaint;
    bool maxPricePainted = false;
    bool minPricePainted = false;
    for (int i = 0; i < listData.length; i++) {
      Market market = listData[i];
      // 画笔
      Color painterColor;
      PaintingStyle paintingStyle;
      if (market.open > market.close) {
        painterColor = decreaseColor;
        paintingStyle = PaintingStyle.fill;
      } else if (market.open == market.close) {
        painterColor = Colors.white;
        paintingStyle = PaintingStyle.fill;
      } else {
        painterColor = increaseColor;
        paintingStyle = PaintingStyle.fill;
      }
      candlestickPaint = Paint()
        ..color = painterColor
        ..strokeWidth = wickWidth
        ..isAntiAlias = true
        ..filterQuality = FilterQuality.high
        ..style = paintingStyle;

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
      double candlestickCenterX = candlestickLeft +
          candlestickWidth.ceilToDouble() / 2.0;
      double closeOffsetY =
          height - (market.close - priceMin) * heightPriceOffset + topMargin;
      market.offset = Offset(candlestickCenterX, closeOffsetY);
      Offset highBottomOffset = Offset(candlestickCenterX, candlestickTop);
      Offset highTopOffset = Offset(candlestickCenterX, high);
      Offset lowBottomOffset = Offset(candlestickCenterX, candlestickBottom);
      Offset lowTopOffset = Offset(candlestickCenterX, low);
      canvas.drawLine(highBottomOffset, highTopOffset, candlestickPaint);
      canvas.drawLine(lowBottomOffset, lowTopOffset, candlestickPaint);

      Paint pricePaint = Paint()
        ..color = kCandleTextColor
        ..strokeWidth = 1;
      // 绘制最大值
      double lineWidth = 10;
      bool isLeft = false;
      double textOrginX;
      if (candlestickCenterX < size.width / 2) {
        textOrginX = candlestickCenterX + lineWidth;
        isLeft = true;
      } else {
        textOrginX = candlestickCenterX - lineWidth;
        isLeft = false;
      }
      if (market.high == pMax && !maxPricePainted) {
        canvas.drawLine(Offset(candlestickCenterX, high),
            Offset(textOrginX, high), pricePaint);
        _drawText(canvas, Offset(textOrginX, high - kCandleTextHight / 2),
            market.high.toStringAsPrecision(kGridPricePrecision), isLeft);
        maxPricePainted = true;
      }
      // 绘制最小值
      if (market.low == pMin && !minPricePainted) {
        canvas.drawLine(Offset(candlestickCenterX, low),
            Offset(textOrginX, low), pricePaint);
        _drawText(canvas, Offset(textOrginX, low - kCandleTextHight / 2),
            market.low.toStringAsPrecision(kGridPricePrecision), isLeft);
        minPricePainted = true;
      }
    }
  }

  _drawText(Canvas canvas, Offset offset, String text, bool isLeft) {
    TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: kCandleTextColor,
            fontSize: kCandleFontSize,
            fontWeight: FontWeight.normal,
          ),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr);
    textPainter.layout();
    Offset of = offset;
    if (!isLeft) {
      of = Offset(offset.dx - textPainter.width, offset.dy);
    }
    textPainter.paint(canvas, of);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return listData != null;
  }
}
