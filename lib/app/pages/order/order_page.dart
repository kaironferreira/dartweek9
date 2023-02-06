import 'package:delivery_app/app/core/extensions/formatter_extensions.dart';
import 'package:delivery_app/app/core/ui/base_state/base_state.dart';
import 'package:delivery_app/app/core/ui/styles/colors_app.dart';
import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_appbar.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:delivery_app/app/dto/order_dto.dart';
import 'package:delivery_app/app/dto/order_product_dto.dart';
import 'package:delivery_app/app/models/payment_type_model.dart';
import 'package:delivery_app/app/pages/order/order_controller.dart';
import 'package:delivery_app/app/pages/order/order_state.dart';
import 'package:delivery_app/app/pages/order/widgets/order_input_field.dart';
import 'package:delivery_app/app/pages/order/widgets/order_product_tile.dart';
import 'package:delivery_app/app/pages/order/widgets/payment_types_field.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends BaseState<OrderPage, OrderController> {
  final _formKey = GlobalKey<FormState>();

  final addressEC = TextEditingController();
  final documentEC = TextEditingController();
  int? paymentTypeId;
  final paymentTypeValidate = ValueNotifier<bool>(true);

  @override
  void onReady() {
    final products =
        ModalRoute.of(context)!.settings.arguments as List<OrderProductDto>;

    controller.load(products);
  }

  void _showConfirmDeleteProductDialog(OrderConfirmDeleteProductState state) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
                'Deseja remover o produto ${state.orderProduct.product.name}?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.cancelDeleteProcess();
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
                  controller.decrementProduct(state.index);
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
    return BlocListener<OrderController, OrderState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () => hideLoader(),
          loading: () => showLoader(),
          error: () {
            hideLoader();
            showError(state.errorMessage ?? 'Erro não informado');
          },
          confirmRemoveProduct: () {
            hideLoader();
            if (state is OrderConfirmDeleteProductState) {
              _showConfirmDeleteProductDialog(state);
            }
          },
          emptyBag: () {
            showInfo(
                'Seu carrinho está vazio, por favor selecione um produto para realizar o pedido');
            Navigator.pop(context, <OrderProductDto>[]);
          },
          success: () {
            hideLoader();
            Navigator.of(context).popAndPushNamed(
              '/order/completed',
              result: <OrderProductDto>[],
            );
          },
        );
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(controller.state.orderProducts);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Carrinho',
              style: context.textStyles.textBold.copyWith(
                color: context.colors.black800,
              ),
            ),
            centerTitle: false,
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                                'Deseja remover todos os itens do carrinho?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  controller.cancelDeleteProcess();
                                },
                                child: Text(
                                  'Cancelar',
                                  style: context.textStyles.textBold
                                      .copyWith(color: Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  controller.emptyBag();
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Confirmar',
                                  style: context.textStyles.textBold,
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
            ],
          ),
          body: Form(
            key: _formKey,
            child: CustomScrollView(
              slivers: [
                BlocSelector<OrderController, OrderState,
                    List<OrderProductDto>>(
                  selector: (state) => state.orderProducts,
                  builder: (context, orderProducts) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: orderProducts.length,
                        (context, index) {
                          final orderProduct = orderProducts[index];
                          return OrderProductTile(
                            index: index,
                            orderProductDto: orderProduct,
                          );
                        },
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total do Pedido',
                              style: context.textStyles.textExtraBold.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            BlocSelector<OrderController, OrderState, double>(
                              selector: (state) => state.totalOrder,
                              builder: (context, totalOrder) {
                                return Text(
                                  totalOrder.currencyPTBR,
                                  style:
                                      context.textStyles.textExtraBold.copyWith(
                                    fontSize: 18,
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        child: TextFormField(
                          controller: addressEC,
                          validator:
                              Validatorless.required('Endereço obrigatório'),
                          decoration: const InputDecoration(
                            labelText: 'Endereço de Entrega.',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        child: TextFormField(
                          controller: documentEC,
                          validator: Validatorless.required('CPF obrigatório'),
                          decoration: const InputDecoration(
                            labelText: 'CPF',
                          ),
                        ),
                      ),
                      BlocSelector<OrderController, OrderState,
                          List<PaymentTypeModel>>(
                        selector: (state) => state.paymentTypes,
                        builder: (context, paymentType) {
                          return ValueListenableBuilder(
                              valueListenable: paymentTypeValidate,
                              builder: (_, paymentTypeValidateValue, child) {
                                return PaymentTypesField(
                                  paymentTypes: paymentType,
                                  valueChanged: (value) {
                                    paymentTypeId = value;
                                  },
                                  validate: paymentTypeValidateValue,
                                  valueSelected: paymentTypeId.toString(),
                                );
                              });
                        },
                      )
                    ],
                  ),
                ),
                SliverFillRemaining(
                    hasScrollBody: false,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        child: DeliveryButton(
                          width: double.infinity,
                          label: 'Finalizar',
                          onPressed: () {
                            final validate =
                                _formKey.currentState?.validate() ?? false;
                            final paymentTypeSelected = paymentTypeId != null;
                            paymentTypeValidate.value = paymentTypeSelected;
                            if (validate && paymentTypeSelected) {
                              controller.saveOrder(
                                address: addressEC.text,
                                document: documentEC.text,
                                paymentMethodId: paymentTypeId!,
                              );
                            }
                          },
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
