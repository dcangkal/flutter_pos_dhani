import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_dhani/presentation/order/bloc/order/order_bloc.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/menu_button.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../home/bloc/checkout/checkout_bloc.dart';
import '../../home/models/order_item.dart';
import '../widgets/order_card.dart';
import '../widgets/payment_cash_dialog.dart';
import '../widgets/payment_qris_dialog.dart';
import '../widgets/process_button.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    final indexValue = ValueNotifier(0);
    const paddingHorizontal = EdgeInsets.symmetric(horizontal: 16.0);

    // List<OrderItem> orders = [];
    int totalPrice = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
        centerTitle: true,
        actions: [
          BlocConsumer<CheckoutBloc, CheckoutState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                // success: (data, price, total) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text('delete checkout success'),
                //       backgroundColor: AppColors.primary,
                //     ),
                //   );
                // },
                // error: (message) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text(message),
                //       backgroundColor: AppColors.red,
                //     ),
                //   );
                // },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return IconButton(
                    onPressed: () {
                      context
                          .read<CheckoutBloc>()
                          .add(const CheckoutEvent.started());
                    },
                    icon: Assets.icons.delete.svg(),
                  );
                },
              );
            },
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: Assets.icons.delete.svg(),
          // ),
        ],
      ),
      body: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          return state.maybeWhen(orElse: () {
            return const Center(
              child: Text('No Data'),
            );
          }, success: (data, qty, total) {
            if (data.isEmpty) {
              return const Center(
                child: Text('No Data'),
              );
            }
            // orders = data;
            totalPrice = total;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              itemCount: data.length,
              separatorBuilder: (context, index) => const SpaceHeight(20.0),
              itemBuilder: (context, index) => OrderCard(
                padding: paddingHorizontal,
                data: data[index],
                onDeleteTap: () {
                  // data.removeAt(index);
                  // setState(() {});
                },
              ),
            );
          });
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                return state.maybeWhen(orElse: () {
                  return const SizedBox();
                }, success: (data, qty, total) {
                  return ValueListenableBuilder(
                    valueListenable: indexValue,
                    builder: (context, value, _) => Row(
                      children: [
                        const SpaceWidth(10.0),
                        MenuButton(
                          iconPath: Assets.icons.cash.path,
                          label: 'Tunai',
                          isActive: value == 1,
                          onPressed: () {
                            indexValue.value = 1;
                            context.read<OrderBloc>().add(
                                OrderEvent.addPaymentMethod('Tunai', data));
                          },
                        ),
                        const SpaceWidth(10.0),
                        MenuButton(
                          iconPath: Assets.icons.qrCode.path,
                          label: 'QRIS',
                          isActive: value == 2,
                          onPressed: () => indexValue.value = 2,
                        ),
                        const SpaceWidth(10.0),
                      ],
                    ),
                  );
                });
              },
            ),
            const SpaceHeight(20.0),
            ProcessButton(
              price: 123000,
              onPressed: () async {
                if (indexValue.value == 0) {
                } else if (indexValue.value == 1) {
                  showDialog(
                    context: context,
                    builder: (context) => PaymentCashDialog(
                      price: totalPrice,
                    ),
                  );
                } else if (indexValue.value == 2) {
                  // showDialog(
                  //   context: context,
                  //   barrierDismissible: false,
                  //   builder: (context) => const PaymentQrisDialog(),
                  // );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
