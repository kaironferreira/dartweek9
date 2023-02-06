import 'package:intl/intl.dart';

extension FormatterExtensions on double {
  String get currencyPTBR {
    final currencyFormater =
        NumberFormat.currency(locale: 'pt_BR', symbol: r'R$');
    return currencyFormater.format(this);
  }
}
