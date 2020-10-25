import '../actions/actions.dart';
import '../state/state.dart';

selectForumScreenStateReducer(
    SelectForumScreenState prevState, SetSelectForumScreenStateAction action) {
  final payload = action.selectForumScreenState;
  return prevState.copyWith(
      isError: payload.isError,
      isLoading: payload.isLoading,
      screenSelect: payload.screenSelect);
}

userLoginStateReducer(
    UserLoginState prevState, SetUserLoginStateAction action) {
  final payload = action.userLoginAction;
  return prevState.copyWith(
      isError: payload.isError,
      isLoading: payload.isLoading,
      token: payload.token);
}

selectCourseIdReducer(CourseId prevState, SetCourseIdAction action) {
  final payload = action.courseIdAction;
  return prevState.copyWith(id: payload.id);
}

selectQuestionIdReducer(QuestionId prevState, SetQuestionIdAction action) {
  final payload = action.questionIdAction;
  return prevState.copyWith(id: payload.id);
}
