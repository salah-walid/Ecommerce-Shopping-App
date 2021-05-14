
import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Function(T) onModelReady;
  final Function(T) onModelClosed;
  final T viewModel;

  BaseView({@required this.builder, this.onModelReady, @required this.viewModel, this.onModelClosed});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {

  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady(widget.viewModel);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.onModelClosed != null) {
      widget.onModelClosed(widget.viewModel);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
        create: (context) => widget.viewModel,
        child: Consumer<T>(builder: widget.builder));
  }
}