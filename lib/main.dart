import 'package:delivery_app/app/core/config/env/envt.dart';
import 'package:delivery_app/app/delivery_app.dart';
import 'package:flutter/cupertino.dart';

Future<void> main() async {
  await Env.instance.load();
  runApp(DeliveryApp());
}
