import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load of first page
class LoadUsersEvent extends UserEvent {
  const LoadUsersEvent();
}

/// Load next page (triggered by scroll reaching bottom)
class LoadMoreUsersEvent extends UserEvent {
  const LoadMoreUsersEvent();
}

/// Add a new user
class AddUserEvent extends UserEvent {
  final UserEntity user;

  const AddUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}

/// Search users by name or phone
class SearchUsersEvent extends UserEvent {
  final String query;

  const SearchUsersEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Apply sort filter (All / Elder / Younger)
class SortUsersEvent extends UserEvent {
  final SortFilter filter;

  const SortUsersEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Clear search and return to paginated list
class ClearSearchEvent extends UserEvent {
  const ClearSearchEvent();
}
