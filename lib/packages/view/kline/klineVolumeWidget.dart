/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-18 15:21:47
 * @LastEditTime: 2019-04-18 16:43:52
 */
import 'package:flutter/material.dart';
import 'package:flutter_kline/packages/bloc/klineBloc.dart';
import 'package:flutter_kline/packages/bloc/klineBlocProvider.dart';
import 'package:flutter_kline/packages/model/klineConstrants.dart';
import 'package:flutter_kline/packages/model/klineModel.dart';

class KlineVolumeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KlineBloc bloc = KlineBlocProvider.of<KlineBloc>(context);
    return StreamBuilder(
      stream: bloc.currentKlineListStream,
      builder: (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
        List<Market> listData = snapshot.data ?? [Market(0, 0, 0, 0, 0)];
        return CustomPaint(
          size: Size.infinite,
          painter: _KlineVolumePainter(listData,bloc.volumeMax),
        );
      },
    );
  }
}

class _KlineVolumePainter extends CustomPainter {
  final List<Market> listData;
  final double maxVolume;
  _KlineVolumePainter(
    this.listData,
    this.maxVolume,
  );

  /// 柱状体宽度
  final double columnarWidth = kColumnarWidth;

  /// 柱状体之间间隙 = 烛台间空隙
  final double columnarGap = kColumnarGap;
  final double columnarTopMargin = kColumnarTopMargin;
  final Color increaseColor = kIncreaseColor;
  final Color decreaseColor = kDecreaseColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (maxVolume == null && maxVolume != 0) {
      return;
    }
    double height = size.height - columnarTopMargin;
    final double heightVolumeOffset = height / maxVolume;
    double columnarRectLeft;
    double columnarRectTop;
    double columnarRectRight;
    double columnarRectBottom;

    Paint columnarPaint;

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
      columnarPaint = Paint()
          ..color = painterColor
          ..strokeWidth = columnarWidth 
          ..isAntiAlias = true
          ..filterQuality = FilterQuality.high;

      
      // 柱状体
      int j = listData.length - 1 -i;
      columnarRectLeft = j * (columnarWidth + columnarGap) + columnarGap;
      columnarRectRight = columnarRectLeft + columnarWidth;
      columnarRectTop = height - market.vol * heightVolumeOffset + columnarTopMargin;
      columnarRectBottom = height + columnarTopMargin;
      Rect columnarRect = Rect.fromLTRB(columnarRectLeft, columnarRectTop, columnarRectRight, columnarRectBottom);
      canvas.drawRect(columnarRect, columnarPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
