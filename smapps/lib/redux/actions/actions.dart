import 'package:redux/redux.dart';
import 'package:meta/meta.dart';

import '../state/state.dart';
import '../store.dart';

@immutable
class SetSelectForumScreenStateAction {
  final SelectForumScreenState selectForumScreenState;

  SetSelectForumScreenStateAction(this.selectForumScreenState);
}

Future<void> fetchPostsAction(Store<AppState> store) async {

  store.dispatch(SetSelectForumScreenStateAction(SelectForumScreenState(isLoading: true)));
  try {
    store.dispatch(
      SetSelectForumScreenStateAction(
        SelectForumScreenState(
          isLoading: false,
          
        ),
      ),
    );
  } catch (error) {
    store.dispatch(SetSelectForumScreenStateAction(SelectForumScreenState(isLoading: false)));
  }
}
