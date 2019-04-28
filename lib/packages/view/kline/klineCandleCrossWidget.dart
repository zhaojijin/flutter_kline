/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: zhaojijin
 * @Date: 2019-04-22 17:15:14
 * @LastEditTime: 2019-04-26 18:51:37
 */

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_kline/packages/bloc/klineBloc.dart';
import 'package:flutter_kline/packages/bloc/klineBlocProvider.dart';
import 'package:flutter_kline/packages/model/klineConstrants.dart';
import 'package:flutter_kline/packages/model/klineModel.dart';

class KlineCandleCrossWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KlineBloc bloc = KlineBlocProvider.of<KlineBloc>(context);
    return StreamBuilder(
      stream: bloc.klineMarketStream,
      builder: (BuildContext context, AsyncSnapshot<Market> snapshot) {
        Market market = snapshot.data;
        return market == null
            ? Container()
            : market.isShowCandleInfo
                ? CustomPaint(
                    size: Size(bloc.screenWidth, market?.gridTotalHeight),
                    painter: _KlineCandleCrossPainter(
                        snapshot.data, bloc.candlestickWidth),
                  )
                : Container();
      },
    );
  }
}

class _KlineCandleCrossPainter extends CustomPainter {
  _KlineCandleCrossPainter(this.market, this.crossVLineWidth);
  final Market market;
  final double crossVLineWidth;

  final Color crossHLineColor = kCrossHLineColor;
  final Color crossVLineColor = kCrossVLineColor;
  final double crossHLineWidth = kCrossHLineWidth;
  final double crossPointRadius = kCrossPointRadius;
  final Color crossPointColor = kCrossPointColor;
  @override
  void paint(Canvas canvas, Size size) {
    if (market == null) {
      return;
    }
    double originY = market.candleWidgetOriginY;
    Paint paintH = Paint()
      ..color = crossHLineColor
      ..strokeWidth = crossHLineWidth
      ..isAntiAlias = true;

    Paint paintV = Paint()
      ..color = crossVLineColor
      ..strokeWidth = crossVLineWidth
      ..isAntiAlias = true;

    // 画竖线
    canvas.drawLine(Offset(market.offset.dx, originY),
        Offset(market.offset.dx, market.gridTotalHeight + originY), paintV);
    // 画点
    Paint pointPaint = Paint()..color = crossPointColor;
    Offset realOffset = Offset(market.offset.dx, market.offset.dy + originY);
    canvas.drawCircle(realOffset, crossPointRadius, pointPaint);

    // 画当前收盘价
    TextPainter closePainter = TextPainter(
        text: TextSpan(
          text: market.close.toStringAsPrecision(kGridPricePrecision),
          style: TextStyle(
            color: kCandleTextColor,
            fontSize: kCandleFontSize,
            fontWeight: FontWeight.normal,
          ),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr);
    closePainter.layout();
    double closeTextOriginX = 0;
    double crossHlineStartOriginX = 0;
    double crossHlineEndOriginX = 0;
    double hMargin = 1;
    double leftPadding = 4;
    double topPadding = 4;
    Offset offset1;
    Offset offset2;
    Offset offset3;
    Offset offset4;
    Offset offset5;
    double halfRectHeight = topPadding + closePainter.height / 2;
    double rectTopY = originY + market.offset.dy - halfRectHeight;
    double rectBottomY = originY + market.offset.dy + halfRectHeight;

    if (market.offset.dx < size.width / 2) {
      closeTextOriginX = hMargin + leftPadding;
      crossHlineStartOriginX =
          leftPadding + hMargin + closePainter.width + halfRectHeight;
      crossHlineEndOriginX = size.width;
      offset1 = Offset(hMargin, rectTopY);
      offset2 = Offset(crossHlineStartOriginX - halfRectHeight, rectTopY);
      offset3 = Offset(crossHlineStartOriginX, originY + market.offset.dy);
      offset4 = Offset(crossHlineStartOriginX - halfRectHeight, rectBottomY);
      offset5 = Offset(hMargin, rectBottomY);
    } else {
      closeTextOriginX =
          size.width - leftPadding - hMargin - closePainter.width;
      crossHlineStartOriginX = 0;
      crossHlineEndOriginX = closeTextOriginX - halfRectHeight;

      offset1 = Offset(size.width - hMargin, rectTopY);
      offset2 = Offset(crossHlineEndOriginX + halfRectHeight, rectTopY);
      offset3 = Offset(crossHlineEndOriginX, originY + market.offset.dy);
      offset4 = Offset(crossHlineEndOriginX + halfRectHeight, rectBottomY);
      offset5 = Offset(size.width - hMargin, rectBottomY);
    }

    // 画横线
    canvas.drawLine(Offset(crossHlineStartOriginX, market.offset.dy + originY),
        Offset(crossHlineEndOriginX, market.offset.dy + originY), paintH);
    List<Offset> points = [
      offset1,
      offset2,
      offset3,
      offset4,
      offset5,
      offset1
    ];
    // 填充多边形颜色
    Paint polygonPainter = Paint()
      ..color = kBackgroundColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    Path path = Path()..moveTo(offset1.dx, offset1.dy);
    path.addPolygon(points, false);
    canvas.drawPath(path, polygonPainter);

    // 绘制多边形
    canvas.drawPoints(PointMode.polygon, points, paintH);
    // 绘制文字
    Offset of = Offset(
        closeTextOriginX, originY + market.offset.dy - closePainter.height / 2);
    closePainter.paint(canvas, of);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return market != null;
  }
}
