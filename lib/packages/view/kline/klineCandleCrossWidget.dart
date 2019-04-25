/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: zhaojijin
 * @Date: 2019-04-22 17:15:14
 * @LastEditTime: 2019-04-25 10:45:28
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
      builder: (BuildContext context, AsyncSnapshot<Market> snapshot){
        Market market = snapshot.data;
        return market == null ? Container() : market.isShowCandleInfo ?  CustomPaint(
          size: Size(bloc.screenWidth, market?.gridTotalHeight),
          painter: _KlineCandleCrossPainter(snapshot.data,bloc.candlestickWidth),
        ) : Container();
      },
    );
  }
}

class _KlineCandleCrossPainter extends CustomPainter {
  _KlineCandleCrossPainter(this.market,this.crossVLineWidth);
  final Market market;
  final double crossVLineWidth;

  final Color crossHLineColor = kCrossHLineColor;
  final Color crossVLineColor = kCrossVLineColor;
  final double crossHLineWidth = kCrossHLineWidth;
  final double crossPointRadius = kCrossPointRadius;
  final Color crossPointColor = kCrossPointColor;
  @override
  void paint(Canvas canvas, Size size) {
    if (market == null ) {
      return;
    }
    double originY = market.candleWidgetOriginY;
    Paint paintH = Paint()
    ..color = crossHLineColor
    ..strokeWidth = crossHLineWidth; 
    // 画横线 
    canvas.drawLine(Offset(0, market.offset.dy + originY), Offset(size.width, market.offset.dy + originY), paintH);

    Paint paintV = Paint()
    ..color = crossVLineColor
    ..strokeWidth = crossVLineWidth; 
    
    // 画竖线 
    canvas.drawLine(Offset(market.offset.dx, originY), Offset(market.offset.dx, market.gridTotalHeight + originY), paintV);
    print(market.gridTotalHeight);
    // 画点
    Paint pointPaint = Paint()
    ..color = crossPointColor; 
    Offset realOffset = Offset(market.offset.dx, market.offset.dy + originY);
    canvas.drawCircle(realOffset, crossPointRadius, pointPaint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return market != null;
  }
  
}