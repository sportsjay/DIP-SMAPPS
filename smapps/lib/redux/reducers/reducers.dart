import '../actions/actions.dart';
import '../state/state.dart';

selectForumScreenStateReducer(SelectForumScreenState prevState, SetSelectForumScreenStateAction action) {
  final payload = action.selectForumScreenState;
  return prevState.copyWith(
    isError: payload.isError,
    isLoading: payload.isLoading,
    screenSelect: payload.screenSelect
  );
}