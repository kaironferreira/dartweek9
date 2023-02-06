import 'package:auto_size_text/auto_size_text.dart';
import 'package:delivery_app/app/core/extensions/formatter_extensions.dart';
import 'package:delivery_app/app/core/ui/base_state/base_state.dart';
import 'package:delivery_app/app/core/ui/helpers/size_extensions.dart';
import 'package:delivery_app/app/core/ui/styles/colors_app.dart';
import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_appbar.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_button_inc_dec.dart';
import 'package:delivery_app/app/dto/order_product_dto.dart';
import 'package:delivery_app/app/models/product_model.dart';
import 'package:delivery_app/app/pages/product_detail/product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  final OrderProductDto? order;
  const ProductDetailPage({
    super.key,
    this.order,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState
    extends BaseState<ProductDetailPage, ProductDetailController> {
  @override
  void initState() {
    super.initState();
    final amount = widget.order?.amount ?? 1;
    controller.initial(amount, widget.order != null);
  }

  void _showConfirmDelete(int amount) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Deseja remover o produto?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancelar',
                  style:
                      context.textStyles.textBold.copyWith(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).pop(OrderProductDto(
                    product: widget.product,
                    amount: amount,
                  ));
                },
                child: Text(
                  'Confirmar',
                  style: context.textStyles.textBold,
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: context.percentWidht(.8),
                height: context.percentHeight(0.4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(300),
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.product.image.toString(),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Center(
              child: Container(
                width: context.percentWidht(.3),
                height: 54,
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<ProductDetailController, int>(
                  builder: (context, amount) {
                    return DeliveryButtonIncDec(
                      amount: amount,
                      decrementTap: () {
                        controller.decrement();
                      },
                      incrementTap: () {
                        controller.increment();
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                widget.product.name,
                style: context.textStyles.textExtraBold.copyWith(
                  fontSize: 22,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Detalhes',
                style: context.textStyles.textBold,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SingleChildScrollView(
                  child: Text(
                    widget.product.description,
                    style: context.textStyles.textRegular
                        .copyWith(fontSize: 14, color: context.colors.black700),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 68,
              padding: const EdgeInsets.all(8),
              child: BlocBuilder<ProductDetailController, int>(
                builder: (context, amount) {
                  return ElevatedButton(
                    style: amount == 0
                        ? ElevatedButton.styleFrom(backgroundColor: Colors.red)
                        : null,
                    onPressed: () {
                      if (amount == 0) {
                        _showConfirmDelete(amount);
                      } else {
                        Navigator.of(context).pop(OrderProductDto(
                          product: widget.product,
                          amount: amount,
                        ));
                      }
                    },
                    child: Visibility(
                      visible: amount > 0,
                      replacement: Text(
                        'Remover produto',
                        style: context.textStyles.textExtraBold,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Adicionar',
                            style: context.textStyles.textExtraBold.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            (widget.product.price * amount).currencyPTBR,
                            style: context.textStyles.textExtraBold,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
