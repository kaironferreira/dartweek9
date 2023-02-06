import 'package:delivery_app/app/core/extensions/formatter_extensions.dart';
import 'package:delivery_app/app/core/ui/helpers/size_extensions.dart';
import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/app/dto/order_product_dto.dart';
import 'package:delivery_app/app/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ButtonShoppingBarWidget extends StatelessWidget {
  final List<OrderProductDto> bag;
  const ButtonShoppingBarWidget({
    super.key,
    required this.bag,
  });

  Future<void> _goOrder(BuildContext context) async {
    final navigator = Navigator.of(context);
    final prefs = await SharedPreferences.getInstance();
    final controller = context.read<HomeController>();

    if (!prefs.containsKey('accessToken')) {
      final loginResult = await navigator.pushNamed('/auth/login');

      if (loginResult == null || loginResult == false) {
        return;
      }
    }

    final updateBag = await navigator.pushNamed('/order', arguments: bag);
    controller.updateBag(updateBag as List<OrderProductDto>);
  }

  @override
  Widget build(BuildContext context) {
    var totalBag = bag
        .fold<double>(
          0.0,
          (total, element) => total += element.totalPrice,
        )
        .currencyPTBR;
    return Container(
      width: context.screenWidth,
      height: 90,
      padding: EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 5,
          )
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          _goOrder(context);
        },
        child: Stack(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Icon(Icons.shopping_cart_outlined),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Ver sacola',
              style: context.textStyles.textExtraBold.copyWith(
                fontSize: 16,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              totalBag,
              style: context.textStyles.textExtraBold.copyWith(
                fontSize: 16,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
