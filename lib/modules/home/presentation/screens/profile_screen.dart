import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/di/service_locator.dart';
import 'package:movies/core/locale/language_cubit.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:movies/modules/auth/domain/entities/app_user.dart';
import 'package:movies/modules/auth/presentation/manager/auth_cubit.dart';
import 'package:movies/modules/auth/presentation/manager/auth_state.dart';
import 'package:movies/modules/auth/presentation/widgets/language_switch.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/domain/repositories/movie_collection_repository.dart';
import 'package:movies/modules/home/presentation/screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AppUser user;
  final ValueChanged<Movie> onMovieTap;

  const ProfileScreen({
    super.key,
    required this.user,
    required this.onMovieTap,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0;
  bool _isEditing = false;
  late AppUser _user;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  String _text(String en, String ar) => _isArabic ? ar : en;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) => ColoredBox(
        color: AppColors.black,
        child: SafeArea(
          bottom: false,
          child: _isEditing
              ? EditProfileScreen(
                  user: _user,
                  onBack: () => setState(() => _isEditing = false),
                  onSaved: (updatedUser) {
                    setState(() {
                      _user = updatedUser;
                      _isEditing = false;
                    });
                  },
                )
              : _buildProfile(context, l10n, authState),
        ),
      ),
    );
  }

  Widget _buildProfile(
    BuildContext context,
    AppLocalizations l10n,
    AuthState authState,
  ) {
    final collection = sl<MovieCollectionRepository>();
    final displayName = (_user.displayName ?? '').trim().isEmpty
        ? (_user.email?.split('@').first ?? l10n.profileTab)
        : _user.displayName!.trim();

    return StreamBuilder<void>(
      stream: collection.changes,
      builder: (context, _) => FutureBuilder<List<List<Movie>>>(
        future: Future.wait([
          collection.getWatchedMovies(),
          collection.getSavedMovies(),
        ]),
        builder: (context, snapshot) {
          final watchedMovies = snapshot.data != null && snapshot.data!.isNotEmpty
              ? snapshot.data![0]
              : const <Movie>[];
          final savedMovies = snapshot.data != null && snapshot.data!.length > 1
              ? snapshot.data![1]
              : const <Movie>[];
          final currentMovies = _selectedTab == 0 ? watchedMovies : savedMovies;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _ProfileAvatar(imageUrl: _user.photoUrl, radius: 38),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            displayName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _ProfileStat(
                          value: '${watchedMovies.length}',
                          label: _text('Watch List', 'قائمة المشاهدة'),
                        ),
                        const SizedBox(width: 14),
                        _ProfileStat(
                          value: '${savedMovies.length}',
                          label: _text('History', 'السجل'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            label: _text('Edit Profile', 'تعديل الملف الشخصي'),
                            color: AppColors.yellow,
                            textColor: AppColors.black,
                            onTap: () => setState(() => _isEditing = true),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ActionButton(
                            label: l10n.signOut,
                            color: AppColors.red,
                            isLoading: authState is SignOutLoadingState,
                            onTap: () => context.read<AuthCubit>().signOut(),
                            icon: Icons.logout_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _text('Language', 'اللغة'),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        LanguageSwitch(
                          initialLanguage:
                              Localizations.localeOf(context).languageCode,
                          onLanguageChanged: context
                              .read<LanguageCubit>()
                              .changeLanguage,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _ProfileTab(
                    icon: Icons.playlist_add_check_rounded,
                    label: _text('Watch List', 'قائمة المشاهدة'),
                    selected: _selectedTab == 0,
                    onTap: () => setState(() => _selectedTab = 0),
                  ),
                  _ProfileTab(
                    icon: Icons.folder_rounded,
                    label: _text('History', 'السجل'),
                    selected: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                ],
              ),
              const Divider(height: 1, color: Color(0xFF353535)),
              Expanded(
                child: snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.yellow),
                      )
                    : currentMovies.isEmpty
                        ? _EmptyCollection(
                            message: _selectedTab == 0
                                ? _text(
                                    'Movies you mark as watched will appear here.',
                                    'الأفلام التي تحددها كمشاهَدة ستظهر هنا.',
                                  )
                                : _text(
                                    'Movies you save with the bookmark will appear here.',
                                    'الأفلام التي تحفظها بعلامة الحفظ ستظهر هنا.',
                                  ),
                            icon: _selectedTab == 0
                                ? Icons.movie_creation_outlined
                                : Icons.bookmark_border_rounded,
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
                            itemCount: currentMovies.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.58,
                            ),
                            itemBuilder: (context, index) {
                              final movie = currentMovies[index];
                              return _MoviePosterCard(
                                movie: movie,
                                onTap: () => widget.onMovieTap(movie),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const _ProfileAvatar({required this.imageUrl, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFF164A5A),
      child: imageUrl == null || imageUrl!.isEmpty
          ? Icon(Icons.person_rounded, color: AppColors.yellow, size: radius)
          : ClipOval(
              child: Image.network(
                imageUrl!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(
                  Icons.person_rounded,
                  color: AppColors.yellow,
                  size: radius,
                ),
              ),
            ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProfileStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: AppColors.white, fontSize: 10)),
      ],
    );
  }
}

class _ProfileTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ProfileTab({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? AppColors.yellow : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.yellow, size: 17),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: AppColors.white, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final bool isLoading;
  final IconData? icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.textColor = AppColors.white,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 6),
                    Icon(icon, size: 15),
                  ],
                ],
              ),
      ),
    );
  }
}

class _EmptyCollection extends StatelessWidget {
  final String message;
  final IconData icon;

  const _EmptyCollection({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 62, color: AppColors.yellow),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white.withValues(alpha: 0.72),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoviePosterCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const _MoviePosterCard({required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    movie.posterUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const ColoredBox(
                      color: AppColors.gray,
                      child: Icon(Icons.movie, color: AppColors.yellow),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.yellow, size: 11),
                          const SizedBox(width: 2),
                          Text(
                            movie.rating.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white, fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
