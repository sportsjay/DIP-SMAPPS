import 'package:meta/meta.dart';

@immutable
class SelectForumScreenState {
  final bool isError;
  final bool isLoading;
  final String screenSelect;

  SelectForumScreenState({
    this.isError,
    this.isLoading,
    this.screenSelect
  });

  factory SelectForumScreenState.initial() => SelectForumScreenState(
        isLoading: false,
        isError: false,
        screenSelect:"courses"
      );

  SelectForumScreenState copyWith({
    @required bool isError,
    @required bool isLoading,
    @required String screenSelect
  }) {
    return SelectForumScreenState(
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      screenSelect: screenSelect ?? this.screenSelect
    );
  }
}