/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-16 11:08:20
 * @LastEditTime: 2019-04-19 16:16:43
 */
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kline/packages/bloc/klineBloc.dart';
import 'package:flutter_kline/packages/bloc/klineBlocProvider.dart';
import 'package:flutter_kline/packages/model/klineConstrants.dart';
import 'package:flutter_kline/packages/model/klineModel.dart';
import 'package:flutter_kline/packages/view/klineWidget.dart';

class KlinePage extends StatelessWidget {
  final KlineBloc bloc;
  KlinePage({Key key, @required this.bloc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Offset lastPoint;
    double lastScale;
    bool isScale = false;
    double screenWidth = MediaQuery.of(context).size.width;
    return KlineBlocProvider<KlineBloc>(
      bloc: bloc,
      child: GestureDetector(
        //开始拖动
        onHorizontalDragStart: (details) {
          lastPoint = details.globalPosition;
        },
        //更新拖动
        onHorizontalDragUpdate: (details) {
          double offsetX = details.globalPosition.dx - lastPoint.dx;
          // 当前偏移的个数
          int offsetCount =
              ((offsetX / screenWidth) * bloc.singleScreenCandleCount).toInt();
          // print('offsetX：$offsetX  offSetCount: $offsetCount');
          if (isScale || offsetCount == 0) {
            return;
          }
          // print('====================================');
          if (bloc.klineTotalList.length > 1) {
            // 当前总的偏移个数
            int currentOffsetCount = bloc.currentIndex + offsetCount;
            int totalListLength = bloc.klineTotalList.length;
            currentOffsetCount = min(currentOffsetCount, totalListLength);
            if (currentOffsetCount < bloc.firstScreenCandleCount) {
              return;
            }
            int fromIndex = 0;
            // 如果当前偏移的个数 没有达到一屏所展示的个数则从0开始取数据
            if (currentOffsetCount > bloc.singleScreenCandleCount) {
              fromIndex = (currentOffsetCount - bloc.singleScreenCandleCount);
            }
            lastPoint = details.globalPosition;
            bloc.getSubKlineList(fromIndex, currentOffsetCount);
            bloc.currentIndex = currentOffsetCount;
            // print('fromIndex: $fromIndex  currentOffsetCount: $currentOffsetCount');
          }
        },
        // 结束拖动
        onHorizontalDragEnd: (details) {
          // TODO Something
        },
        // onScaleStart: (details) {
        //   isScale = true;
        // },
        // onScaleUpdate: (details) {
        //   double scale = details.scale;
        //   if (scale == 1.0) {
        //     return;
        //   }
        //   // print('details.scale ${details.scale}');
        //   lastScale = details.scale;
        //   double candlestickWidth = scale * bloc.candlestickWidth;
        //   bloc.setCandlestickWidth(candlestickWidth);
        //   bloc.setSingleScreenCandleCount(screenWidth);

        // // 当前总的偏移个数
        //   int currentOffsetCount = bloc.currentIndex;
        //   int totalListLength = bloc.klineTotalList.length;
        //   currentOffsetCount = min(currentOffsetCount, totalListLength);
        //   // if (currentOffsetCount < bloc.firstScreenCandleCount) {
        //   //   return;
        //   // }
        //   int fromIndex = 0;
        //   // 如果当前偏移的个数 没有达到一屏所展示的个数则从0开始取数据
        //   if (currentOffsetCount > bloc.singleScreenCandleCount) {
        //     fromIndex = (currentOffsetCount - bloc.singleScreenCandleCount);
        //   }
        //   bloc.getSubKlineList(fromIndex, currentOffsetCount);
        // },
        // onScaleEnd: (details) {
        //   isScale = false;
        // },
        child: StreamBuilder(
          stream: bloc.klineListStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
            List<Market> listData = snapshot.data;
            if (listData != null) {
              bloc.setScreenWidth(screenWidth);
            }
            return KlineWidget();
          },
        ),
      ),
    );
  }
}
