import 'dart:convert';

class QrisResponseModel {
  final String statusCode;
  final String statusMessage;
  final String transactionId;
  final String orderId;
  final String merchantId;
  final String grossAmount;
  final String currency;
  final String paymentType;
  final String transactionTime;
  final String transactionStatus;
  final String fraudStatus;
  final List<Action> actions;
  final String expiryTime;

  QrisResponseModel({
    required this.statusCode,
    required this.statusMessage,
    required this.transactionId,
    required this.orderId,
    required this.merchantId,
    required this.grossAmount,
    required this.currency,
    required this.paymentType,
    required this.transactionTime,
    required this.transactionStatus,
    required this.fraudStatus,
    required this.actions,
    required this.expiryTime,
  });

  factory QrisResponseModel.fromJson(String str) =>
      QrisResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QrisResponseModel.fromMap(Map<String, dynamic> json) =>
      QrisResponseModel(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        transactionId: json["transaction_id"],
        orderId: json["order_id"],
        merchantId: json["merchant_id"],
        grossAmount: json["gross_amount"],
        currency: json["currency"],
        paymentType: json["payment_type"],
        transactionTime: json["transaction_time"],
        transactionStatus: json["transaction_status"],
        fraudStatus: json["fraud_status"],
        actions:
            List<Action>.from(json["actions"].map((x) => Action.fromMap(x))),
        expiryTime: json["expiry_time"],
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "transaction_id": transactionId,
        "order_id": orderId,
        "merchant_id": merchantId,
        "gross_amount": grossAmount,
        "currency": currency,
        "payment_type": paymentType,
        "transaction_time": transactionTime,
        "transaction_status": transactionStatus,
        "fraud_status": fraudStatus,
        "actions": List<dynamic>.from(actions.map((x) => x.toMap())),
        "expiry_time": expiryTime,
      };
}

class Action {
  final String name;
  final String method;
  final String url;

  Action({
    required this.name,
    required this.method,
    required this.url,
  });

  factory Action.fromJson(String str) => Action.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Action.fromMap(Map<String, dynamic> json) => Action(
        name: json["name"],
        method: json["method"],
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "method": method,
        "url": url,
      };
}
