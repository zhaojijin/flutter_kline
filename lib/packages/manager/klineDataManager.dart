/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: zhaojijin
 * @Date: 2019-04-16 14:33:00
 * @LastEditTime: 2019-05-13 16:07:14
 */

import 'package:flutter_kline/packages/model/klineModel.dart';

enum YKChartType { Unknown, MA, VOL }

class KlineDataManager {
  static final List<int> priceMaList = [5, 10, 30];
  static final List<int> volumeMaList = [5, 10];
  static List<Market> calculateKlineData(
      YKChartType type, List<Market> dataList) {
    switch (type) {
      case YKChartType.MA:
        return _calculatePriceMa(dataList);
      case YKChartType.VOL:
        return _calculateVolumeMa(dataList);
      default:
        return dataList;
    }
  }

  static List<Market> _calculatePriceMa(List<Market> dataList) {
    List<Market> tmpList = dataList;
    for (int numIndex = 0; numIndex < priceMaList.length; numIndex++) {
      int maNum = priceMaList[numIndex];
      if (maNum <= 0) {
        return tmpList;
      }
      int listCount = tmpList.length;
      for (int i = tmpList.length - 1; i >= 0; i--) {
        Market market = tmpList[i];
        if ((numIndex == 0 && market.priceMa1 != null) ||
            (numIndex == 0 && market.priceMa2 != null) ||
            (numIndex == 0 && market.priceMa3 != null)) {
          return tmpList;
        }

        if (i <= tmpList.length - maNum) {
          Market lastData;
          if (i < tmpList.length - 1) {
            lastData = tmpList[i + 1];
          }
          double lastMa;
          if (lastData != null) {
            switch (numIndex) {
              case 0:
                lastMa = lastData.priceMa1;
                break;
              case 1:
                lastMa = lastData.priceMa2;
                break;
              case 2:
                lastMa = lastData.priceMa3;
                break;
              default:
                break;
            }
          }
          double priceMa = 0;
          if (lastMa != null) {
            Market deleteData = tmpList[i + maNum];
            priceMa = lastMa * maNum + market.close - deleteData.close;
          } else {
            List<Market> aveArray = tmpList.sublist(i, listCount);
            for (var tmpData in aveArray) {
              priceMa += tmpData.close;
            }
          }
          priceMa = priceMa / maNum;
          switch (numIndex) {
            case 0:
              tmpList[i].priceMa1 = priceMa;
              break;
            case 1:
              tmpList[i].priceMa2 = priceMa;
              break;
            case 2:
              tmpList[i].priceMa3 = priceMa;
              break;
            default:
              break;       
          }
        } 
      }
    }
    return tmpList;
  }

  static List<Market> _calculateVolumeMa(List<Market> dataList) {
    // TODO： 计算幅图Ma数据
    return dataList;
  }
}
