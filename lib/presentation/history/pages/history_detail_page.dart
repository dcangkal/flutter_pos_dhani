import 'package:flutter/material.dart';
import 'package:flutter_pos_dhani/data/datasources/product_local_datasource.dart';

import '../../home/models/order_item.dart';
import '../../order/models/order_model.dart';

class HistoryDetailPage extends StatelessWidget {
  final int orderId;
  const HistoryDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Order'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ProductLocalDatasource.instance.getOrderItemsByOrderId(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No order items found.');
          } else {
            List<Map<String, dynamic>> orderItems = snapshot.data!;

            return ListView.builder(
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> item = orderItems[index];

                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text(
                      'Quantity: ${item['quantity']} - Price: ${item['price']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
