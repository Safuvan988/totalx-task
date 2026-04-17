import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/add_user_usecase.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/search_users_usecase.dart';
import '../../domain/usecases/sort_users_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase _getUsers;
  final AddUserUseCase _addUser;
  final SearchUsersUseCase _searchUsers;
  final SortUsersUseCase _sortUsers;

  int _currentPage = 0;
  SortFilter _currentFilter = SortFilter.all;

  UserBloc({
    required GetUsersUseCase getUsers,
    required AddUserUseCase addUser,
    required SearchUsersUseCase searchUsers,
    required SortUsersUseCase sortUsers,
  })  : _getUsers = getUsers,
        _addUser = addUser,
        _searchUsers = searchUsers,
        _sortUsers = sortUsers,
        super(const UserInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<LoadMoreUsersEvent>(_onLoadMore);
    on<AddUserEvent>(_onAddUser);
    on<SearchUsersEvent>(_onSearchUsers);
    on<SortUsersEvent>(_onSortUsers);
    on<ClearSearchEvent>(_onClearSearch);
  }

  // ─── Load first page ───────────────────────────────────────────────────────

  Future<void> _onLoadUsers(
    LoadUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    _currentPage = 0;
    _currentFilter = SortFilter.all;
    emit(const UserLoading());
    try {
      final users = await _getUsers(
        offset: 0,
        limit: AppConstants.pageSize,
      );
      final hasMore = users.length == AppConstants.pageSize;
      emit(UserLoaded(users: users, hasMore: hasMore));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  // ─── Lazy load next page ───────────────────────────────────────────────────

  Future<void> _onLoadMore(
    LoadMoreUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    final current = state;
    // Only paginate in normal (non-search/sort) mode
    if (current is! UserLoaded || !current.hasMore || current.isSearchMode) {
      return;
    }

    emit(UserLoadingMore(
      currentUsers: current.users,
      currentFilter: _currentFilter,
    ));

    try {
      _currentPage++;
      final newUsers = await _getUsers(
        offset: _currentPage * AppConstants.pageSize,
        limit: AppConstants.pageSize,
      );
      final hasMore = newUsers.length == AppConstants.pageSize;
      emit(UserLoaded(
        users: [...current.users, ...newUsers],
        hasMore: hasMore,
        isSearchMode: false,
        currentFilter: _currentFilter,
      ));
    } catch (e) {
      _currentPage--;
      emit(UserError(e.toString()));
    }
  }

  // ─── Add user ──────────────────────────────────────────────────────────────

  Future<void> _onAddUser(
    AddUserEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      await _addUser(event.user);
      // Reload first page after adding
      _currentPage = 0;
      final users = await _getUsers(
        offset: 0,
        limit: AppConstants.pageSize,
      );
      final hasMore = users.length == AppConstants.pageSize;
      emit(UserLoaded(
        users: users,
        hasMore: hasMore,
        currentFilter: _currentFilter,
      ));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  // ─── Search ────────────────────────────────────────────────────────────────

  Future<void> _onSearchUsers(
    SearchUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      if (event.query.trim().isEmpty) {
        // Fall back to paginated list
        add(const LoadUsersEvent());
        return;
      }
      final users = await _searchUsers(event.query);
      emit(UserLoaded(
        users: users,
        hasMore: false,
        isSearchMode: true,
        currentFilter: _currentFilter,
      ));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  // ─── Sort / Filter by age ──────────────────────────────────────────────────

  Future<void> _onSortUsers(
    SortUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    _currentFilter = event.filter;
    try {
      if (event.filter == SortFilter.all) {
        // Reset to paginated list
        _currentPage = 0;
        final users = await _getUsers(offset: 0, limit: AppConstants.pageSize);
        final hasMore = users.length == AppConstants.pageSize;
        emit(UserLoaded(
          users: users,
          hasMore: hasMore,
          currentFilter: SortFilter.all,
        ));
      } else {
        final users = await _sortUsers(event.filter);
        emit(UserLoaded(
          users: users,
          hasMore: false,
          isSearchMode: true,
          currentFilter: event.filter,
        ));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  // ─── Clear search ──────────────────────────────────────────────────────────

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<UserState> emit,
  ) async {
    add(const LoadUsersEvent());
  }
}
