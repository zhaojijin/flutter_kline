/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-23 18:44:59
 * @LastEditTime: 2019-04-23 21:02:38
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter_kline/packages/bloc/klineBloc.dart';
import 'package:flutter_kline/packages/bloc/klineBlocProvider.dart';
import 'package:flutter_kline/packages/model/klineConstrants.dart';

class KlinePeriodSwitchWidget extends StatefulWidget {
  @override
  _KlinePeriodSwitchWidgetState createState() =>
      _KlinePeriodSwitchWidgetState();
}

class _KlinePeriodSwitchWidgetState extends State<KlinePeriodSwitchWidget> {
  @override
  Widget build(BuildContext context) {
    KlineBloc bloc = KlineBlocProvider.of<KlineBloc>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    List periodList = [k1min, k5min, k15min, k30min, k60min, k1day];
    List periodTitleList = ['1分', '5分', '15分', '30分', '1小时', '日线'];
    double width = screenWidth / periodList.length;
    return Container(
        width: screenWidth,
        height: kPeriodHeight,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: periodList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                // margin: EdgeInsets.only(top: -4),
                width: width,
                alignment: Alignment.center,
                child: CupertinoButton(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    '${periodTitleList[index]}',
                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: kGridTextColor),
                    
                  ),
                  onPressed: () {
                    bloc.periodSwitchSinkAdd(periodList[index]);
                  },
                ),
              );
            }));
  }
}
