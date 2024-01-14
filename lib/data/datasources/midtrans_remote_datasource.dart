import 'dart:convert';

import 'package:flutter_pos_dhani/data/models/response/qris_response_model.dart';
import 'package:flutter_pos_dhani/data/models/response/qris_status_response_model.dart';
import 'package:http/http.dart' as http;

class MidtransRemoteDatasource {
  String generateBasicAuthHeader(String serverKey) {
    final base64Credetial = base64Encode(utf8.encode(serverKey));
    final authHeader = 'Basic $base64Credetial';
    return authHeader;
  }

  Future<QrisResponseModel> generateQRCode(
      String orderId, int grossAmount) async {
    final headers = {
      'Accept': 'Application/json',
      'Content-Type': 'Application/json',
      'Authorization':
          generateBasicAuthHeader('SB-Mid-server--L_tAy_4dHzdfxBxhTGEjhUZ')
    };
    final body = jsonEncode({
      'payment_type': 'gopay',
      'transaction_details': {
        'order_id': orderId,
        'gross_amount': grossAmount,
      },
    });
    final response = await http.post(
      Uri.parse('https://api.sandbox.midtrans.com/v2/charge'),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      print(response.body);
      return QrisResponseModel.fromJson(response.body);
    } else {
      throw Exception('failed to generate QR Code');
    }
  }

  Future<QrisStatusResponseModel> checkPaymentStatus(String orderId) async {
    final headers = {
      'Accept': 'Application/json',
      'Content-Type': 'Application/json',
      'Authorization':
          generateBasicAuthHeader('SB-Mid-server--L_tAy_4dHzdfxBxhTGEjhUZ')
    };
    final response = await http.get(
      Uri.parse('https://api.sandbox.midtrans.com/v2/$orderId/status'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return QrisStatusResponseModel.fromJson(response.body);
    } else {
      throw Exception('failed to check payment status');
    }
  }
}
