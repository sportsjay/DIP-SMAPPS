import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'actions/actions.dart';
import 'reducers/reducers.dart';
import 'state/state.dart';
import 'package:redux_thunk/redux_thunk.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SetSelectForumScreenStateAction) {
    final nextSelectForumScreenState =
        selectForumScreenStateReducer(state.selectForumScreenState, action);
    return state.copyWith(selectForumScreenState: nextSelectForumScreenState);
  } else if (action is SetUserLoginStateAction) {
    final nextUserLoginState =
        userLoginStateReducer(state.userLoginState, action);
    return state.copyWith(userLoginState: nextUserLoginState);
  } else if (action is SetCourseIdAction) {
    final nextCourseId = selectCourseIdReducer(state.courseId, action);
    return state.copyWith(courseId: nextCourseId);
  } else if (action is SetQuestionIdAction) {
    final nextQuestionId = selectQuestionIdReducer(state.questionId, action);
    return state.copyWith(questionId: nextQuestionId);
  }
  return state;
}

@immutable
class AppState {
  final SelectForumScreenState selectForumScreenState;
  final UserLoginState userLoginState;
  final CourseId courseId;
  final QuestionId questionId;

  AppState(
      {@required this.selectForumScreenState,
      @required this.userLoginState,
      @required this.courseId,
      @required this.questionId});

  AppState copyWith(
      {SelectForumScreenState selectForumScreenState,
      UserLoginState userLoginState,
      CourseId courseId,
      QuestionId questionId}) {
    return AppState(
        selectForumScreenState:
            selectForumScreenState ?? this.selectForumScreenState,
        userLoginState: userLoginState ?? this.userLoginState,
        courseId: courseId ?? this.courseId,
        questionId: questionId ?? this.questionId);
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
    final userLoginStateInitial = UserLoginState.initial();
    final courseIdInitial = CourseId.initial();
    final questionIdInitial = QuestionId.initial();
    _store = Store<AppState>(appReducer,
        middleware: [thunkMiddleware],
        initialState: AppState(
            selectForumScreenState: selectForumScreenStateInitial,
            userLoginState: userLoginStateInitial,
            courseId: courseIdInitial,
            questionId: questionIdInitial));
  }
}
