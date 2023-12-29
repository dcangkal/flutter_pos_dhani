import 'package:dartz/dartz.dart';
import 'package:flutter_pos_dhani/core/constants/variables.dart';
import 'package:flutter_pos_dhani/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos_dhani/data/models/response/product_response_model.dart';
import 'package:http/http.dart' as http;

class ProductRemoteDatasource {
  Future<Either<String, ProductResponseModel>> getProducts() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http
        .get(Uri.parse('${Variables.baseUrl}/api/products'), headers: {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer ${authData.token}'
    });
    if (response.statusCode == 200) {
      return Right(ProductResponseModel.fromJson(response.body));
    } else {
      return left('get products gagal');
    }
  }
}
