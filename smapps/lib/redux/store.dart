import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'actions/actions.dart';
import 'reducers/reducers.dart';
import 'state/state.dart';
import 'package:redux_thunk/redux_thunk.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SetSelectForumScreenStateAction) {
    final nextSelectForumScreenState = selectForumScreenStateReducer(state.selectForumScreenState, action);

    return state.copyWith(selectForumScreenState: nextSelectForumScreenState);
  }

  return state;
}

@immutable
class AppState {
  final SelectForumScreenState selectForumScreenState;

  AppState({
    @required this.selectForumScreenState,
  });

  AppState copyWith({
    SelectForumScreenState selectForumScreenState,
  }) {
    return AppState(
      selectForumScreenState: selectForumScreenState ?? this.selectForumScreenState,
    );
  }
}

class Redux {
  static Store<AppState> _store;

  static Store<AppState> get store {
    if (_store == null) {
      throw Exception("store is not initialized");
    } else {
      return _store;
    }
  }

  static Future<void> init() async {
    final selectForumScreenStateInitial = SelectForumScreenState.initial();

    _store = Store<AppState>(
      appReducer,
      middleware: [thunkMiddleware],
      initialState: AppState(selectForumScreenState: selectForumScreenStateInitial),
    );
  }
}