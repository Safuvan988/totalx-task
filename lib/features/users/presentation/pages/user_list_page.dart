import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../widgets/add_user_bottom_sheet.dart';
import '../widgets/sort_bottom_sheet.dart';
import '../widgets/user_list_tile.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(const LoadUsersEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Trigger load more 150px before end
    if (currentScroll >= maxScroll - 150) {
      final state = context.read<UserBloc>().state;
      if (state is UserLoaded && state.hasMore && !state.isSearchMode) {
        context.read<UserBloc>().add(const LoadMoreUsersEvent());
      }
    }
  }

  int _lastSearchTime = 0;

  void _onSearchChanged(String query) {
    final now = DateTime.now().millisecondsSinceEpoch;
    _lastSearchTime = now;
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_lastSearchTime == now && mounted) {
        context.read<UserBloc>().add(SearchUsersEvent(query));
      }
    });
  }

  void _openSortSheet() async {
    final state = context.read<UserBloc>().state;
    SortFilter current = SortFilter.all;
    if (state is UserLoaded) current = state.currentFilter;

    final selected = await showModalBottomSheet<SortFilter>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SortBottomSheet(currentFilter: current),
    );

    if (selected != null && mounted) {
      context.read<UserBloc>().add(SortUsersEvent(selected));
    }
  }

  void _openAddUserSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<UserBloc>(),
        child: const AddUserBottomSheet(),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Users List',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildUserList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddUserSheet,
        backgroundColor: AppColors.textPrimary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: [
          const Icon(Icons.location_on, size: 18, color: AppColors.textPrimary),
          const SizedBox(width: 4),
          Text(
            'Nilambur',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Search Bar ───────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'search by name or phone',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textHint,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 20,
                    color: AppColors.textHint,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear,
                              size: 18, color: AppColors.textHint),
                          onPressed: () {
                            _searchController.clear();
                            context
                                .read<UserBloc>()
                                .add(const ClearSearchEvent());
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Sort button
          GestureDetector(
            onTap: _openSortSheet,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.sort, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  // ─── User List ────────────────────────────────────────────────────────────

  Widget _buildUserList() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is UserError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: AppColors.error),
                const SizedBox(height: 12),
                Text(state.message,
                    style:
                        GoogleFonts.poppins(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      context.read<UserBloc>().add(const LoadUsersEvent()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        List<UserEntity> users = [];
        bool isLoadingMore = false;

        if (state is UserLoaded) {
          users = state.users;
        } else if (state is UserLoadingMore) {
          users = state.currentUsers;
          isLoadingMore = true;
        }

        if (users.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people_outline,
                    size: 64,
                    color: AppColors.textHint.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                Text(
                  'No users found',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to add a new user',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
          itemCount: users.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == users.length) {
              // Bottom loader for lazy loading
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              );
            }
            return UserListTile(user: users[index]);
          },
        );
      },
    );
  }
}
