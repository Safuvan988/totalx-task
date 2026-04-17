import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

/// First page loading
class UserLoading extends UserState {
  const UserLoading();
}

/// Users successfully loaded
class UserLoaded extends UserState {
  final List<UserEntity> users;
  final bool hasMore;       // true if there are more pages to load
  final bool isSearchMode;  // true when displaying search/sort results
  final SortFilter currentFilter;

  const UserLoaded({
    required this.users,
    this.hasMore = false,
    this.isSearchMode = false,
    this.currentFilter = SortFilter.all,
  });

  UserLoaded copyWith({
    List<UserEntity>? users,
    bool? hasMore,
    bool? isSearchMode,
    SortFilter? currentFilter,
  }) {
    return UserLoaded(
      users: users ?? this.users,
      hasMore: hasMore ?? this.hasMore,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }

  @override
  List<Object?> get props => [users, hasMore, isSearchMode, currentFilter];
}

/// Loading more items at the bottom (lazy load indicator)
class UserLoadingMore extends UserState {
  final List<UserEntity> currentUsers;
  final SortFilter currentFilter;

  const UserLoadingMore({
    required this.currentUsers,
    this.currentFilter = SortFilter.all,
  });

  @override
  List<Object?> get props => [currentUsers];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
