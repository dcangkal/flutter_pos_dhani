part of 'delete_history_bloc.dart';

@freezed
class DeleteHistoryState with _$DeleteHistoryState {
  const factory DeleteHistoryState.initial() = _Initial;
  const factory DeleteHistoryState.loading() = _Loading;
  const factory DeleteHistoryState.success() = _Success;
  const factory DeleteHistoryState.error(String message) = _Error;
}
