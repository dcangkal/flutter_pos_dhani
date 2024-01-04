import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_dhani/core/extensions/build_context_ext.dart';
import 'package:flutter_pos_dhani/core/extensions/int_ext.dart';
import 'package:flutter_pos_dhani/core/extensions/string_ext.dart';
import 'package:flutter_pos_dhani/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos_dhani/presentation/order/models/order_model.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../bloc/order/order_bloc.dart';
import 'payment_success_dialog.dart';

class PaymentCashDialog extends StatefulWidget {
  final int price;
  const PaymentCashDialog({super.key, required this.price});

  @override
  State<PaymentCashDialog> createState() => _PaymentCashDialogState();
}

class _PaymentCashDialogState extends State<PaymentCashDialog> {
  TextEditingController? priceController;

  @override
  void initState() {
    priceController =
        TextEditingController(text: widget.price.currencyFormatRp);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final priceController =
        TextEditingController(text: widget.price.currencyFormatRp);
    return AlertDialog(
      scrollable: true,
      title: Stack(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.highlight_off),
            color: AppColors.primary,
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Text(
                'Pembayaran - Tunai',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceHeight(16.0),
          CustomTextField(
            controller: priceController,
            label: '',
            showLabel: false,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final int priceValue = value.toIntegerFromText;
              priceController.text = priceValue.currencyFormatRp;
              priceController.selection = TextSelection.fromPosition(
                  TextPosition(offset: priceController.text.length));
            },
          ),
          const SpaceHeight(16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Button.filled(
                onPressed: () {},
                label: 'Uang Pas',
                disabled: true,
                textColor: AppColors.primary,
                fontSize: 13.0,
                width: 112.0,
                height: 50.0,
              ),
              const SpaceWidth(4.0),
              Flexible(
                child: Button.filled(
                  onPressed: () {},
                  label: widget.price.currencyFormatRp,
                  disabled: true,
                  textColor: AppColors.primary,
                  fontSize: 13.0,
                  height: 50.0,
                ),
              ),
            ],
          ),
          const SpaceHeight(30.0),
          BlocConsumer<OrderBloc, OrderState>(
            listener: (context, state) {
              state.maybeWhen(
                  orElse: () {},
                  success: (
                    orders,
                    totalQuantity,
                    totalPrice,
                    paymentMethod,
                    nominalBayar,
                    idKasir,
                    namaKasir,
                  ) {
                    final orderModel = OrderModel(
                      paymentMethod: paymentMethod,
                      nominalBayar: nominalBayar,
                      orders: orders,
                      totalQuantity: totalQuantity,
                      totalPrice: totalPrice,
                      idKasir: idKasir,
                      namaKasir: namaKasir,
                      isSync: false,
                    );
                    ProductLocalDatasource.instance.saveOrder(orderModel);
                    context.pop();
                    showDialog(
                      context: context,
                      builder: (context) => const PaymentSuccessDialog(),
                    );
                  });
            },
            builder: (context, state) {
              return state.maybeWhen(orElse: () {
                return const SizedBox();
              }, success: (
                data,
                totalQuantity,
                totalPrice,
                paymentMethod,
                nominalBayar,
                idKasir,
                namaKasir,
              ) {
                return Button.filled(
                  onPressed: () {
                    context.read<OrderBloc>().add(OrderEvent.addNominalBayar(
                        priceController.text.toIntegerFromText));
                  },
                  label: 'Proses',
                );
              }, error: (message) {
                return Center(
                  child: Text(message),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
