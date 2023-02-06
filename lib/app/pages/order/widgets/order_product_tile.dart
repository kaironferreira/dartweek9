import 'package:delivery_app/app/core/extensions/formatter_extensions.dart';
import 'package:delivery_app/app/core/ui/styles/colors_app.dart';
import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_button_inc_dec.dart';
import 'package:delivery_app/app/dto/order_product_dto.dart';
import 'package:delivery_app/app/pages/order/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderProductTile extends StatelessWidget {
  final int index;
  final OrderProductDto orderProductDto;

  const OrderProductTile({
    super.key,
    required this.index,
    required this.orderProductDto,
  });

  @override
  Widget build(BuildContext context) {
    final product = orderProductDto.product;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
        color: context.colors.black200,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              product.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style:
                        context.textStyles.textRegular.copyWith(fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (orderProductDto.amount * product.price).currencyPTBR,
                        style: context.textStyles.textBold.copyWith(
                          fontSize: 14,
                          color: context.colors.secundary,
                        ),
                      ),
                      DeliveryButtonIncDec.compact(
                        amount: orderProductDto.amount,
                        incrementTap: () {
                          context
                              .read<OrderController>()
                              .incrementProduct(index);
                        },
                        decrementTap: () {
                          context
                              .read<OrderController>()
                              .decrementProduct(index);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
