import 'package:flutter/material.dart';

import '../../home/models/order_item.dart';
import '../../order/models/order_model.dart';

class HistoryDetailPage extends StatefulWidget {
  final OrderModel order;
  const HistoryDetailPage({super.key, required this.order});

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Order'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transaction Time: ${widget.order.transactionTime}'),
            Text('Total Quantity: ${widget.order.totalQuantity} items'),
            Text('Total Price: ${widget.order.totalPrice}'),
            Text('Payment Method: ${widget.order.paymentMethod}'),
            Text('Nominal Bayar: ${widget.order.nominalBayar}'),
            const SizedBox(height: 16),
            const Text('Order Items:'),
            // Menampilkan detail setiap item di dalam order
            for (OrderItem item in widget.order.orders)
              ListTile(
                title: Text(item.product.name),
                subtitle: Text('Quantity: ${item.quantity}'),
              ),
            // Add more details based on your OrderModel properties
          ],
        ),
      ),
    );
  }
}
