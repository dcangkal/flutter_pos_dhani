import 'package:flutter/material.dart';
import 'package:flutter_pos_dhani/core/extensions/build_context_ext.dart';
import 'package:flutter_pos_dhani/core/extensions/int_ext.dart';
import 'package:flutter_pos_dhani/presentation/history/pages/history_detail_page.dart';
import 'package:flutter_pos_dhani/presentation/order/models/order_model.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/constants/colors.dart';

class HistoryTransactionCard extends StatelessWidget {
  final OrderModel data;
  final EdgeInsetsGeometry? padding;

  const HistoryTransactionCard({
    super.key,
    required this.data,
    this.padding,
  });
  @override
  Widget build(BuildContext context) {
    // Print information about OrderModel to the console
    // print('Order ID: ${data.id}');
    // print('Transaction Time: ${data.transactionTime}');
    // print('Total Quantity: ${data.totalQuantity}');
    // print('Total Price: ${data.totalPrice}');
    // print('Payment Method: ${data.paymentMethod}');
    // print('Nominal Bayar: ${data.nominalBayar}');

    // Print information about each OrderItem to the console
    // for (OrderItem item in data.orders) {
    //   print('Item Name: ${item.product.name}');
    //   print('Quantity: ${item.quantity}');
    // }
    return Container(
      margin: padding,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 48.0,
            blurStyle: BlurStyle.outer,
            spreadRadius: 0,
            color: AppColors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: ListTile(
        leading: Assets.icons.payments.svg(
            color: data.isSync == true ? AppColors.green : AppColors.disabled),
        title: Text(data.paymentMethod),
        subtitle: Text('${data.totalQuantity} item'),
        trailing: Text(
          data.totalPrice.currencyFormatRp,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        onTap: () {
          context.push(
            HistoryDetailPage(
              order: data,
            ),
          );
        },
      ),
    );
  }
}
