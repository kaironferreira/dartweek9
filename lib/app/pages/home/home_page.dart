import 'package:badges/badges.dart';
import 'package:delivery_app/app/core/ui/base_state/base_state.dart';
import 'package:delivery_app/app/core/ui/helpers/loader.dart';
import 'package:delivery_app/app/core/ui/helpers/messages.dart';
import 'package:delivery_app/app/core/ui/styles/colors_app.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_appbar.dart';
import 'package:delivery_app/app/models/product_model.dart';
import 'package:delivery_app/app/pages/home/home_controller.dart';
import 'package:delivery_app/app/pages/home/home_state.dart';
import 'package:delivery_app/app/pages/home/widgets/button_shopping_bag_widget.dart';
import 'package:delivery_app/app/pages/home/widgets/delivery_product_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage, HomeController> {
  @override
  void onReady() {
    controller.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DeliveryAppbar(
          actions: [
            Padding(
                padding: const EdgeInsets.all(18),
                child: BlocBuilder<HomeController, HomeState>(
                  builder: (context, state) {
                    return Badge(
                      badgeContent: Text(state.shoppingBag.length.toString()),
                      badgeStyle: const BadgeStyle(
                        badgeColor: Color(0XFFFF970A),
                      ),
                      child: const Icon(
                        Icons.shopping_cart,
                        color: Color(0XFF39C166),
                      ),
                    );
                  },
                ))
          ],
        ),
        body: BlocConsumer<HomeController, HomeState>(
          listener: (context, state) {
            state.status.matchAny(
                any: () => hideLoader(),
                loading: () => showLoader(),
                error: () {
                  hideLoader();
                  showError(
                      state.errorMessage ?? 'Falha ao processar requisição');
                });
          },
          buildWhen: (previous, current) => current.status.matchAny(
            any: () => false,
            initial: () => true,
            loaded: () => true,
          ),
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];

                      final orders = state.shoppingBag
                          .where((order) => order.product == product);

                      return DeliveryProductTile(
                        product: product,
                        orderProduct: orders.isNotEmpty ? orders.first : null,
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: state.shoppingBag.isNotEmpty,
                  child: ButtonShoppingBarWidget(
                    bag: state.shoppingBag,
                  ),
                ),
              ],
            );
          },
        ));
  }
}
