import 'package:flutter/material.dart';

class LoadingModel extends StatelessWidget {
  final isVisible;
  final Color? color;
  final Color? backgroundColor;
  final double? opacity;

  LoadingModel({
    this.isVisible,
    this.color,
    this.backgroundColor,
    this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: opacity ?? 0.7,
            child: Container(
              color: backgroundColor ?? Colors.grey[900],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
