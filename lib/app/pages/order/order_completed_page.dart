import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:flutter/material.dart';

class OrderCompletedPage extends StatelessWidget {
  const OrderCompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo_rounded.png'),
              const SizedBox(
                height: 40,
              ),
              Text(
                'Pedido realizado com sucesso, em breve você receberá a confirmação do seu pedido.',
                textAlign: TextAlign.center,
                style: context.textStyles.textExtraBold.copyWith(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              DeliveryButton(
                width: double.infinity,
                label: 'Fechar',
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ]),
      ),
    );
  }
}
