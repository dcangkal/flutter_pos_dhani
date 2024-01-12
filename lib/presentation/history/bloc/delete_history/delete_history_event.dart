part of 'delete_history_bloc.dart';

@freezed
class DeleteHistoryEvent with _$DeleteHistoryEvent {
  const factory DeleteHistoryEvent.started() = _Started;
  const factory DeleteHistoryEvent.deleted() = _Deleted;
}
