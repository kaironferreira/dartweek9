import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class GlobalContext {
  late final GlobalKey<NavigatorState> _navigatorKey;
  static GlobalContext? _intance;

  GlobalContext._();

  static GlobalContext get instance {
    _intance ??= GlobalContext._();
    return _intance!;
  }

  set navigatorKey(GlobalKey<NavigatorState> key) => _navigatorKey = key;

  Future<void> loginExpired() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    showTopSnackBar(
        _navigatorKey.currentState!.overlay!,
        const CustomSnackBar.error(
          message: 'Login Expirado, clique na sacola novamente!',
          backgroundColor: Colors.black,
        ));

    _navigatorKey.currentState!.popUntil(ModalRoute.withName('/home'));
  }
}
