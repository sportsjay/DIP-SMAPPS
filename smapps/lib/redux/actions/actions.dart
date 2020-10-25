import 'package:redux/redux.dart';
import 'package:meta/meta.dart';

import '../state/state.dart';
import '../store.dart';

@immutable
// Select Forum Screen Action
class SetSelectForumScreenStateAction {
  final SelectForumScreenState selectForumScreenState;

  SetSelectForumScreenStateAction(this.selectForumScreenState);
}

Future<void> selectForumScreenStateAction(
    Store<AppState> store, String screenSelect) async {
  store.dispatch(
      SetSelectForumScreenStateAction(SelectForumScreenState(isLoading: true)));
  try {
    store.dispatch(
      SetSelectForumScreenStateAction(
        SelectForumScreenState(
          screenSelect: screenSelect,
          isLoading: false,
        ),
      ),
    );
  } catch (error) {
    store.dispatch(SetSelectForumScreenStateAction(
        SelectForumScreenState(isLoading: false)));
  }
}

// Login Action
class SetUserLoginStateAction {
  final UserLoginState userLoginAction;

  SetUserLoginStateAction(this.userLoginAction);
}

Future<void> loginUser(Store<AppState> store, String token) async {
  store.dispatch(SetUserLoginStateAction(UserLoginState(isLoading: true)));
  try {
    store.dispatch(SetUserLoginStateAction(UserLoginState(token: token)));
    print("token saved");
  } catch (error) {
    store.dispatch(SetUserLoginStateAction(UserLoginState(isLoading: true)));
    print("token saved failed");
  }
}

// Select Course ID

class SetCourseIdAction {
  final CourseId courseIdAction;

  SetCourseIdAction(this.courseIdAction);
}

Future<void> selectCourseId(Store<AppState> store, int courseId) async {
  store.dispatch(SetCourseIdAction(CourseId(isLoading: true)));
  try {
    await store.dispatch(SetCourseIdAction(CourseId(id: courseId)));
    print("course ID: $courseId stored in state");
    store.dispatch(SetCourseIdAction(CourseId(isLoading: false)));
  } catch (error) {
    print("Error storing course ID and Error :" + error);
    store.dispatch(SetCourseIdAction(CourseId(isLoading: false)));
  }
}

// Select Question ID
class SetQuestionIdAction {
  final QuestionId questionIdAction;

  SetQuestionIdAction(this.questionIdAction);
}

Future<void> selectQuestionId(Store<AppState> store, int questionId) async {
  try {
    await store.dispatch(SetQuestionIdAction(QuestionId(id: questionId)));
    print("question ID: $questionId stored in state");
  } catch (error) {
    print("Error in courseId, Error :" + error);
  }
}
