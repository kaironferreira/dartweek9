// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:delivery_app/app/core/excepetions/repository_exceptions.dart';
import 'package:delivery_app/app/core/rest_client/custom_dio.dart';
import 'package:delivery_app/app/dto/order_dto.dart';
import 'package:delivery_app/app/models/payment_type_model.dart';
import 'package:delivery_app/app/repositories/order/order_repository.dart';
import 'package:dio/dio.dart';

class OrderRepositoryImpl extends OrderRepository {
  final CustomDio dio;
  OrderRepositoryImpl({
    required this.dio,
  });

  @override
  Future<List<PaymentTypeModel>> getAllPaymentsTypes() async {
    try {
      final result = await dio.auth().get('/payment-types');
      return result.data
          .map<PaymentTypeModel>((p) => PaymentTypeModel.fromMap(p))
          .toList();
    } on DioError catch (e, s) {
      log('Erro ao buscar formas de pagamento', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao buscar formas de pagamento');
    }
  }

  @override
  Future<void> saveOrder(OrderDto order) async {
    try {
      await dio.auth().post('/orders', data: {
        'products': order.products
            .map((e) => {
                  'id': e.product.id,
                  'amount': e.amount,
                  'total_price': e.totalPrice,
                })
            .toList(),
        'user_id': '#userAuthRef',
        'address': order.address,
        'CPF': order.document,
        'payment_method_id': order.paymentMethodId,
      });
    } on DioError catch (e, s) {
      log('Erro ao salvar pedido', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao salvar pedido');
    }
  }
}
