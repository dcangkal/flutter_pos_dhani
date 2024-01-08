import 'package:flutter_pos_dhani/core/extensions/date_time_ext.dart';
import 'package:flutter_pos_dhani/core/extensions/int_ext.dart';

class HistoryModel {
  final String paymentMethod;
  final int totalBill;
  final int nominalPayment;
  final DateTime paymentTime;
  final String status;

  HistoryModel({
    required this.paymentMethod,
    required this.totalBill,
    required this.nominalPayment,
    required this.paymentTime,
    required this.status,
  });

  String get totalBillFormat => totalBill.currencyFormatRp;
  String get nominalPaymentFormat => nominalPayment.currencyFormatRp;
  String get paymentTimeFormat => paymentTime.toFormattedTime();
}
