/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-18 16:48:38
 * @LastEditTime: 2019-04-19 00:05:49
 */
import 'package:flutter/material.dart';
import 'package:flutter_kline/packages/bloc/klineBloc.dart';
import 'package:flutter_kline/packages/bloc/klineBlocProvider.dart';
import 'package:flutter_kline/packages/model/klineConstrants.dart';
import 'package:flutter_kline/packages/model/klineModel.dart';

class KlineMaLineWidget extends StatelessWidget {
  final YKMAType maType;
  KlineMaLineWidget(this.maType);
  @override
  Widget build(BuildContext context) {
    KlineBloc bloc = KlineBlocProvider.of<KlineBloc>(context);
    return StreamBuilder(
      stream: bloc.currentKlineListStream ,
      builder: (BuildContext context, AsyncSnapshot<List<Market>> snapshot){
        List<Market> listData = snapshot.data ?? [Market(0, 0, 0, 0, 0)];
        return CustomPaint(
          size: Size.infinite,
          painter: _KlineMaLinePainter(listData,maType,bloc.priceMax,bloc.priceMin),
        );
      },
    );
  }
}

class _KlineMaLinePainter extends CustomPainter {
  _KlineMaLinePainter(this.listData,this.maType,this.priceMax,this.priceMin);
  final List<Market> listData;
  final YKMAType maType;
  final double priceMax;
  final double priceMin;
  final double lineWidth = kMaLineWidth;
  final double topMargin = kMaTopMargin;
  final double candlestickWidth = kCandlestickWidth;
  final double candlestickGap = kCandlestickGap;
  Color lineColor;
  
  @override
  void paint(Canvas canvas, Size size) {
    if (priceMax == null && priceMin == null && maType == null) {
      return;
    }

    double height = size.height - topMargin;
    double heightPriceOffset = 0;
    if (priceMax - priceMin != 0) {
      heightPriceOffset = height / (priceMax - priceMin);
    }

    for (int i = 0; i < listData.length; i++) {
      if (i == listData.length-1) {
        break;
      }
      Market market = listData[i];
      Market nextMarket = listData[i+1];
      if ((market.priceMa5 == null && maType == YKMAType.MA5)
          || (market.priceMa10 == null && maType == YKMAType.MA10)
          || (market.priceMa20 == null && maType == YKMAType.MA20)) {
            print('continue========= ${market.priceMa5}==${market.priceMa10}==${market.priceMa20}');
        continue;
      }
      double currentMaPrice;
      double currentNextMaPrice;
      switch (maType) {
        case YKMAType.MA5: {
          lineColor = kMa5LineColor;
          currentMaPrice = market.priceMa5;
          currentNextMaPrice = nextMarket.priceMa5;
        }
          break;
        case YKMAType.MA10:{
          lineColor = kMa10LineColor;
          currentMaPrice = market.priceMa10;
          currentNextMaPrice = nextMarket.priceMa10;
        }
          break;
        case YKMAType.MA20 : {
          lineColor = kMa20LineColor;
          currentMaPrice = market.priceMa20;
          currentNextMaPrice = nextMarket.priceMa20;
        }
          break;
        default:
      }

      Paint maPainter = Paint()
        ..color = lineColor
        ..isAntiAlias = true
        ..filterQuality = FilterQuality.high
        // ..strokeCap = StrokeCap.round
        ..strokeWidth = lineWidth;
      
      double startX,startY,endX,endY;
      int j = listData.length - 1 -i;

      double startRectLeft = j * (candlestickWidth + candlestickGap) + candlestickGap;
      double endRectLeft = (j-1) * (candlestickWidth + candlestickGap) + candlestickGap;
      startX = startRectLeft + candlestickWidth/2;
      endX = endRectLeft + candlestickWidth/2;

      print('startX: $startX ==== endX: $endX     === ${i}');

      startY = height - (currentMaPrice - priceMin) *heightPriceOffset + topMargin;
      endY = height -  (currentNextMaPrice - priceMin) * heightPriceOffset + topMargin;
        
      canvas.drawLine(Offset(startX,startY), Offset(endX,endY), maPainter);
      }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
  
}