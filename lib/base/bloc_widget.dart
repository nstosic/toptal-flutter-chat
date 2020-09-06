import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:toptal_chat/base/bloc_factory.dart';

class BlocWidget<E, S, B extends Bloc<E, S>> extends StatefulWidget {
  const BlocWidget({
    Key key,
    @required this.builder,
    this.data,
    this.listener,
  }) : super(key: key);

  final Widget Function(BuildContext context, S state) builder;
  final Map<String, dynamic> data;
  final Function(BuildContext context, S state) listener;

  @override
  _BlocWidgetState<E, S, B> createState() => _BlocWidgetState<E, S, B>(BlocFactory.create<B>(data));
}

class _BlocWidgetState<E, S, B extends Bloc<E, S>> extends State<BlocWidget<E, S, B>> {
  _BlocWidgetState(this._bloc);

  final B _bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: (context) => _bloc,
      lazy: false,
      child: BlocConsumer<Bloc<E, S>, S>(
        builder: widget.builder,
        cubit: _bloc,
        listener: widget.listener ?? (_, __) {},
      ),
    );
  }
}
