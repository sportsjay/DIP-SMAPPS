import 'package:meta/meta.dart';

@immutable
class SelectForumScreenState {
  final bool isError;
  final bool isLoading;
  final String screenSelect;

  SelectForumScreenState({this.isError, this.isLoading, this.screenSelect});

  factory SelectForumScreenState.initial() => SelectForumScreenState(
      isLoading: false, isError: false, screenSelect: "courses");

  SelectForumScreenState copyWith(
      {@required bool isError,
      @required bool isLoading,
      @required String screenSelect}) {
    return SelectForumScreenState(
        isError: isError ?? this.isError,
        isLoading: isLoading ?? this.isLoading,
        screenSelect: screenSelect ?? this.screenSelect);
  }
}

class UserLoginState {
  final bool isError;
  final bool isLoading;
  final String token;

  UserLoginState({this.isError, this.isLoading, this.token});

  factory UserLoginState.initial() =>
      UserLoginState(isLoading: false, isError: false, token: "null");

  UserLoginState copyWith(
      {@required bool isError,
      @required bool isLoading,
      @required String token}) {
    return UserLoginState(
        isError: isError ?? this.isError,
        isLoading: isLoading ?? this.isLoading,
        token: token ?? this.token);
  }
}

class CourseId {
  final int id;
  final bool isLoading;

  CourseId({this.id, this.isLoading});

  factory CourseId.initial() => CourseId(isLoading: false, id: 0);

  CourseId copyWith({@required int id}) {
    return CourseId(id: id ?? this.id, isLoading: isLoading ?? this.isLoading);
  }
}

class QuestionId {
  final int id;

  QuestionId({this.id});

  factory QuestionId.initial() => QuestionId(id: 0);

  QuestionId copyWith({@required int id}) {
    return QuestionId(id: id ?? this.id);
  }
}

class Refresh {
  final bool isRefresh;

  Refresh({this.isRefresh});

  factory Refresh.initial() => Refresh(isRefresh: false);

  Refresh copyWith({@required bool isRefresh}) {
    return Refresh(isRefresh: isRefresh ?? this.isRefresh);
  }
}
