import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_dhani/core/extensions/build_context_ext.dart';
import 'package:flutter_pos_dhani/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos_dhani/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos_dhani/presentation/auth/pages/login_page.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/menu_button.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../home/bloc/product/product_bloc.dart';
import '../bloc/logout/logout_bloc.dart';
import 'manage_product_page.dart';

class ManageMenuPage extends StatelessWidget {
  const ManageMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola'),
        centerTitle: true,
        actions: [
          BlocConsumer<LogoutBloc, LogoutState>(
            listener: (context, state) {
              state.maybeWhen(
                  orElse: () {},
                  success: () {
                    // hapus data lokal
                    AuthLocalDatasource().removeAuthData();
                    // menampilkan snackbar logout sukses
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('logout sukses'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                    // pindah halaman ke login page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  error: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: AppColors.red,
                      ),
                    );
                  });
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return IconButton(
                    onPressed: () {
                      context
                          .read<LogoutBloc>()
                          .add(const LogoutEvent.logout());
                    },
                    icon: const Icon(
                      Icons.logout,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Row(
              children: [
                MenuButton(
                  iconPath: Assets.images.manageProduct.path,
                  label: 'Kelola Produk',
                  onPressed: () => context.push(const ManageProductPage()),
                  isImage: true,
                ),
                const SpaceWidth(15.0),
                MenuButton(
                  iconPath: Assets.images.managePrinter.path,
                  label: 'Kelola Printer',
                  onPressed: () {},
                  isImage: true,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                BlocConsumer<ProductBloc, ProductState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      orElse: () {},
                      success: (data) async {
                        await ProductLocalDatasource.instance
                            .removeAllProduct();
                        await ProductLocalDatasource.instance
                            .insertAllProduct(data);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          backgroundColor: AppColors.primary,
                          content: Text("sync data success"),
                        ));
                      },
                    );
                  },
                  builder: (context, state) {
                    return state.maybeWhen(orElse: () {
                      return ElevatedButton(
                        onPressed: () {
                          context
                              .read<ProductBloc>()
                              .add(const ProductEvent.fetch());
                        },
                        child: const Text("Sync Data"),
                      );
                    }, loading: () {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    });
                  },
                ),

                // const SpaceWidth(15.0),
                // MenuButton(
                //   iconPath: Assets.images.managePrinter.path,
                //   label: 'Kelola Printer',
                //   onPressed: () {},
                //   isImage: true,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
