import 'package:bloc/bloc.dart';
import 'package:flutter_pos_dhani/data/datasources/product_local_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../order/models/order_model.dart';

part 'history_event.dart';
part 'history_state.dart';
part 'history_bloc.freezed.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(const _Initial()) {
    on<_Fetch>((event, emit) async {
      emit(const _Loading());
      final data = await ProductLocalDatasource.instance.getAllOrder();
      emit(_Success(data));
    });
  }
}
