/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-16 11:08:20
 * @LastEditTime: 2019-04-22 15:08:31
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
          if (isScale) {
            return;
          }
          double offsetX = details.globalPosition.dx - lastPoint.dx;
          int singleScreenCandleCount =
              bloc.getSingleScreenCandleCount(screenWidth);
          // 当前偏移的个数
          int offsetCount =
              ((offsetX / screenWidth) * singleScreenCandleCount).toInt();
          if (offsetCount == 0) {
            return;
          }
          int firstScreenNum =
              (singleScreenCandleCount * bloc.getFirstScreenScale()).toInt();
          if (bloc.klineTotalList.length > firstScreenNum) {
            // 当前总的偏移个数
            int currentOffsetCount = bloc.toIndex + offsetCount;
            int totalListLength = bloc.klineTotalList.length;
            currentOffsetCount = min(currentOffsetCount, totalListLength);
            if (currentOffsetCount < firstScreenNum) {
              return;
            }
            int fromIndex = 0;
            // 如果当前偏移的个数 没有达到一屏所展示的个数则从0开始取数据
            if (currentOffsetCount > singleScreenCandleCount) {
              fromIndex = (currentOffsetCount - singleScreenCandleCount);
            }
            fromIndex = max(0, fromIndex);
            lastPoint = details.globalPosition;
            bloc.getSubKlineList(fromIndex, currentOffsetCount);
            print(
                'fromIndex: $fromIndex  currentOffsetCount: $currentOffsetCount');
          }
        },
        // 结束拖动
        // onHorizontalDragEnd: (details) {
        //   // TODO Something
        // },
        onScaleStart: (details) {
          isScale = true;
        },
        onScaleUpdate: (details) {
          double scale = details.scale;
          // print('scale : $scale');
          if (scale == 1.0) {
            return;
          }
          if (scale > 1 && (scale - 1) > 0.01) {
            scale = 1.01;
          } else if (scale < 1 && (1 - scale) > 0.01) {
            scale = 0.99;
          }
          double candlestickWidth = scale * bloc.candlestickWidth;
          bloc.setCandlestickWidth(candlestickWidth);

          double count = (screenWidth - bloc.candlestickWidth) /
              (kCandlestickGap + bloc.candlestickWidth);
          int currentScreenCountNum = count.toInt();

          int toIndex = bloc.toIndex;
          int fromIndex = toIndex - currentScreenCountNum;
          fromIndex = max(0, fromIndex);

          print(
              'from: $fromIndex   to: $toIndex  currentScreenCountNum: $currentScreenCountNum');
          bloc.getSubKlineList(fromIndex, toIndex);
        },
        onScaleEnd: (details) {
          isScale = false;
        },
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
