import 'package:dartz/dartz.dart';
import 'package:flutter_pos_dhani/core/constants/variables.dart';
import 'package:flutter_pos_dhani/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos_dhani/data/models/response/auth_response_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> login(
      String email, String password) async {
    final response =
        await http.post(Uri.parse('${Variables.baseUrl}/api/login'), body: {
      'email': email,
      'password': password,
    });
    if (response.statusCode == 200) {
      return Right(AuthResponseModel.fromJson(response.body));
    } else {
      return const Left('login gagal');
    }
  }

  Future<Either<String, String>> logout() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/logout'),
      headers: {
        'Content-Type': 'Appication/json',
        'Authorization': 'Bearer ${authData.token}',
      },
    );
    if (response.statusCode == 200) {
      return const Right('logout sukses');
    } else {
      return const Left('logout gagal');
    }
  }
}
