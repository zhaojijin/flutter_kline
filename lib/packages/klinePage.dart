/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-16 11:08:20
 * @LastEditTime: 2019-04-18 14:15:02
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kline/packages/bloc/klineBloc.dart';
import 'package:flutter_kline/packages/bloc/klineBlocProvider.dart';
import 'package:flutter_kline/packages/model/klineModel.dart';
import 'package:flutter_kline/packages/view/klineWidget.dart';

class KlinePage extends StatelessWidget {
  final KlineBloc bloc;
  KlinePage({Key key, @required this.bloc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Offset lastPoint;
    int count;
    double currentRectWidth;
    bool isScale = false;

    return KlineBlocProvider<KlineBloc>(
      bloc: bloc,
      child: GestureDetector(
        child: StreamBuilder(
          stream: bloc.klineListStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
            List<Market> listData = snapshot.data;
            if (listData != null) {
              double screenWidth = MediaQuery.of(context).size.width;
              bloc.setScreenWidth(screenWidth);
            }
            return KlineWidget();
          },
        ),
      ),
    );
  }
}
