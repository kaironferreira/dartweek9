import 'package:flutter/material.dart';

class DeliveryAppbar extends AppBar {
  final List<Widget>? actions;
  DeliveryAppbar({
    super.key,
    this.actions,
    double elevation = 0,
  }) : super(
          actions: actions,
          elevation: elevation,
          title: Image.asset(
            'assets/images/logo.png',
            width: 80,
          ),
        );
}
