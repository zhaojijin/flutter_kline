/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-22 17:15:14
 * @LastEditTime: 2019-04-23 00:16:23
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
      stream: bloc.klineMarketStream ,
      builder: (BuildContext context, AsyncSnapshot<Market> snapshot){
        Market market = snapshot.data;
        return market == null ? Container() : market.isShowCandleInfo ?  CustomPaint(
          size: Size.infinite,
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
    Paint paintH = Paint()
    ..color = crossHLineColor
    ..strokeWidth = crossHLineWidth; 
    // 画横线 
    canvas.drawLine(Offset(0, market.offset.dy), Offset(size.width, market.offset.dy), paintH);

    Paint paintV = Paint()
    ..color = crossVLineColor
    ..strokeWidth = crossVLineWidth; 
    // 画竖线 
    canvas.drawLine(Offset(market.offset.dx, 0), Offset(market.offset.dx, size.height), paintV);

    // 画点
    Paint pointPaint = Paint()
    ..color = crossPointColor; 
    canvas.drawCircle(market.offset, crossPointRadius, pointPaint);
    // 画框
    // canvas.draw
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return market != null;
  }
  
}