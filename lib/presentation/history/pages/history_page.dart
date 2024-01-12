import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_dhani/presentation/history/bloc/delete_history/delete_history_bloc.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../bloc/history/history_bloc.dart';
import '../widgets/history_transaction_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(const HistoryEvent.fetch());
    // context.read<DeleteHistoryBloc>().add(const DeleteHistoryEvent.deleted());
  }

  @override
  Widget build(BuildContext context) {
    const paddingHorizontal = EdgeInsets.symmetric(horizontal: 16.0);

    return Scaffold(
        appBar: AppBar(
          title: const Text('History Orders',
              style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          centerTitle: true,
          actions: [
            BlocConsumer<DeleteHistoryBloc, DeleteHistoryState>(
              listener: (context, state) {
                state.maybeWhen(
                    orElse: () {},
                    success: () {
                      // menampilkan snackbar delete sukses
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('delete history success'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                      // fetch ulang data history
                      context
                          .read<HistoryBloc>()
                          .add(const HistoryEvent.fetch());
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
                            .read<DeleteHistoryBloc>()
                            .add(const DeleteHistoryEvent.deleted());
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            return state.maybeWhen(
                orElse: () => const Center(
                      child: Text("error"),
                    ),
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                success: (data) {
                  if (data.isEmpty) {
                    return const Center(
                      child: Text("no data"),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    itemCount: data.length,
                    separatorBuilder: (context, index) =>
                        const SpaceHeight(8.0),
                    itemBuilder: (context, index) => HistoryTransactionCard(
                      padding: paddingHorizontal,
                      data: data[index],
                    ),
                  );
                });
          },
        ));
  }
}
