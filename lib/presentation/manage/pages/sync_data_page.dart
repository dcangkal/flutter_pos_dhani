import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_dhani/presentation/manage/bloc/sync_order/sync_order_bloc.dart';
import 'package:flutter_pos_dhani/presentation/manage/models/sync_item_model.dart';

import '../../../core/constants/colors.dart';
import '../../../data/datasources/product_local_datasource.dart';
import '../../home/bloc/product/product_bloc.dart';

class SyncDataPage extends StatefulWidget {
  const SyncDataPage({super.key});

  @override
  State<SyncDataPage> createState() => _SyncDataPageState();
}

class _SyncDataPageState extends State<SyncDataPage> {
  final List<SyncItemModel> syncList = [
    SyncItemModel(
      name: 'sync products',
      type: 'download',
      icon: Icons.download,
    ),
    SyncItemModel(
      name: 'sync orders',
      type: 'upload',
      icon: Icons.upload,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Data'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                success: (data) async {
                  await ProductLocalDatasource.instance.removeAllProduct();
                  await ProductLocalDatasource.instance.insertAllProduct(data);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: AppColors.primary,
                    content: Text("sync data product success"),
                  ));
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(orElse: () {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 3, color: AppColors.blueLight),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.blueLight,
                      child: Icon(
                        Icons.sync,
                        size: 24.0,
                      ),
                    ),
                    title: Text(syncList[0].name),
                    subtitle: Text(syncList[0].type),
                    trailing: Icon(
                      syncList[1].icon,
                      size: 24.0,
                    ),
                    onTap: () {
                      context
                          .read<ProductBloc>()
                          .add(const ProductEvent.fetch());
                    },
                  ),
                );
              }, loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
            },
          ),
          BlocConsumer<SyncOrderBloc, SyncOrderState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () async {},
                success: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: AppColors.primary,
                    content: Text("sync data order success"),
                  ));
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(orElse: () {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 3, color: AppColors.blueLight),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: FutureBuilder(
                    future: ProductLocalDatasource.instance.getCountByIsSync(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final count = snapshot.data;
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.green,
                            child: Icon(
                              Icons.sync,
                              size: 24.0,
                            ),
                          ),
                          title: Text(syncList[1].name),
                          subtitle:
                              Text('${syncList[1].type} : ${count.toString()}'),
                          trailing: Icon(
                            syncList[0].icon,
                            size: 24.0,
                          ),
                          onTap: () {
                            context
                                .read<SyncOrderBloc>()
                                .add(const SyncOrderEvent.sendOrder());
                          },
                        );
                      }
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.blueLight,
                          child: Icon(
                            Icons.sync,
                            size: 24.0,
                          ),
                        ),
                        title: Text(syncList[1].name),
                        subtitle: Text(syncList[1].type),
                        trailing: Icon(
                          syncList[0].icon,
                          size: 24.0,
                        ),
                        // onTap: () {
                        // context
                        //     .read<ProductBloc>()
                        //     .add(const ProductEvent.fetch());
                        // },
                      );
                    },
                  ),
                );
              }, loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
