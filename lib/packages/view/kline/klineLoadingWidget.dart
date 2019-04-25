/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: zhaojijin
 * @Date: 2019-04-23 21:38:13
 * @LastEditTime: 2019-04-25 16:38:00
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kline/packages/bloc/klineBloc.dart';
import 'package:flutter_kline/packages/bloc/klineBlocProvider.dart';

class KlineLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KlineBloc bloc = KlineBlocProvider.of<KlineBloc>(context);
    return StreamBuilder(
      stream: bloc.klineShowLoadingStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        print(snapshot.data);
        bool show = snapshot.data == null ? true : snapshot.data;
        return Container(
          child: Center(child: show ? CupertinoActivityIndicator() : null));
      },
    );
  }
}
