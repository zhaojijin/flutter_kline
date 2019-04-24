/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-23 21:38:13
 * @LastEditTime: 2019-04-23 21:54:33
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter_kline/packages/bloc/klineBloc.dart';
import 'package:flutter_kline/packages/bloc/klineBlocProvider.dart';

class KlineLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KlineBloc bloc = KlineBlocProvider.of<KlineBloc>(context);
    return StreamBuilder(
      stream: bloc.klineShowLoadingStream ,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        print(snapshot.data);
        bool show = snapshot.data == null ? true : snapshot.data;
        return show ? CupertinoActivityIndicator() : Container();
      },
    );
  }
}