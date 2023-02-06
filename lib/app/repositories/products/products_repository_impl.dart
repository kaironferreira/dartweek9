// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:delivery_app/app/core/excepetions/repository_exceptions.dart';
import 'package:delivery_app/app/core/rest_client/custom_dio.dart';
import 'package:delivery_app/app/models/product_model.dart';
import 'package:delivery_app/app/repositories/products/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final CustomDio dio;
  ProductsRepositoryImpl({
    required this.dio,
  });

  @override
  Future<List<ProductModel>> findAllProducts() async {
    try {
      final result = await dio.auth().get('/products');
      return result.data
          .map<ProductModel>((product) => ProductModel.fromMap(product))
          .toList();
    } on Exception catch (e, s) {
      log("Erro ao buscar produtos", error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao buscar produtos');
    }
  }
}
