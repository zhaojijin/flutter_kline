/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-22 18:55:06
 * @LastEditTime: 2019-04-23 00:13:35
 */

import 'package:flutter/material.dart';
import 'package:flutter_kline/packages/bloc/klineBloc.dart';
import 'package:flutter_kline/packages/bloc/klineBlocProvider.dart';
import 'package:flutter_kline/packages/model/klineModel.dart';

class KlineCandleInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> _list = ['时间', '开', '高', '低', '收', '涨跌额', '涨跌幅', '成交量'];
    KlineBloc bloc = KlineBlocProvider.of<KlineBloc>(context);
    return StreamBuilder(
      stream: bloc.klineMarketStream,
      builder: (BuildContext context, AsyncSnapshot<Market> snapshot) {
        Market market = snapshot.data;
        return market == null
            ? Container()
            : (market.isShowCandleInfo ? Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 1),
                    color: Colors.blueGrey[100].withOpacity(0.8)),
                child: ListView.builder(
                  padding: EdgeInsets.all(6),
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int index) {
                    List marketInfoList = market?.candleInfo();
                    print('marketInfoList : $marketInfoList');
                    return Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${_list[index]}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: marketInfoList == null
                                ? Text('')
                                : Text(
                                    '${marketInfoList[index]}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ) : Container());
      },
    );
  }
}
