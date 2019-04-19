/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: 
 * @Date: 2019-04-16 15:02:47
 * @LastEditTime: 2019-04-16 15:14:54
 */
import 'package:flutter/material.dart';

abstract class KlineBlocBase {
  void dispose();
}

class KlineBlocProvider<T extends KlineBlocBase> extends StatefulWidget {
  KlineBlocProvider({Key key, @required this.child, @required this.bloc})
      : super(key: key);
  final Widget child;
  final T bloc;
  @override
  _KlineBlocProviderState<T> createState() => _KlineBlocProviderState<T>();
  static T of<T extends KlineBlocBase>(BuildContext context) {
    final type = _typeOf<KlineBlocProvider<T>>();
    KlineBlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }
  static Type _typeOf<T>() => T;
}

class _KlineBlocProviderState<T>
    extends State<KlineBlocProvider<KlineBlocBase>> {

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
