import 'package:bloc/bloc.dart';
import 'package:flutter_pos_dhani/data/datasources/product_local_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_history_event.dart';
part 'delete_history_state.dart';
part 'delete_history_bloc.freezed.dart';

class DeleteHistoryBloc extends Bloc<DeleteHistoryEvent, DeleteHistoryState> {
  DeleteHistoryBloc() : super(const _Initial()) {
    on<_Deleted>((event, emit) async {
      emit(const _Loading());
      final result =
          await ProductLocalDatasource.instance.deleteSyncedOrdersAndItems();
      if (result == true) {
        emit(const _Success());
      } else {
        emit(const _Error('data for delete not found'));
      }
    });
  }
}
