import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/l10n/app_localizations.dart';

class AvatarSelector extends StatefulWidget {
  static const List<String> avatars = [
    'https://api.dicebear.com/10.x/avataaars/png?seed=Alex&backgroundColor=b6e3f4',
    'https://api.dicebear.com/10.x/adventurer/png?seed=Sam&backgroundColor=c0aede',
    'https://api.dicebear.com/10.x/big-smile/png?seed=Jordan&backgroundColor=ffdfbf',
    'https://api.dicebear.com/10.x/lorelei/png?seed=Lisa&backgroundColor=ffd5dc',
    'https://api.dicebear.com/10.x/micah/png?seed=Maya&backgroundColor=d1f4d1',
    'https://api.dicebear.com/10.x/notionists/png?seed=David&backgroundColor=b6e3f4',
    'https://api.dicebear.com/10.x/croodles/png?seed=Sara&backgroundColor=ffdfbf',
    'https://api.dicebear.com/10.x/open-peeps/png?seed=Chris&backgroundColor=c0aede',
    'https://api.dicebear.com/10.x/fun-emoji/png?seed=Emma&backgroundColor=ffd5dc',
  ];

  final ValueChanged<int>? onAvatarSelected;
  final int initialIndex;

  const AvatarSelector({
    super.key,
    this.onAvatarSelected,
    this.initialIndex = 1,
  });

  @override
  State<AvatarSelector> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends State<AvatarSelector> {
  late final PageController _pageController;
  late int _currentIndex;

  List<String> get _avatars => AvatarSelector.avatars;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(
      viewportFraction: 0.38,
      initialPage: _currentIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatarLabel = AppLocalizations.of(context)!.avatarLabel;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 120,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _avatars.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              widget.onAvatarSelected?.call(index);
            },
            itemBuilder: (context, index) {
              final isSelected = index == _currentIndex;
              final size = isSelected ? 110.0 : 78.0;

              return Center(
                child: GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.yellow : Colors.transparent,
                        width: isSelected ? 2.5 : 0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.yellow.withValues(alpha: 0.3),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: ClipOval(
                      child: Image.network(
                        _avatars[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.gray,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.person,
                              color: isSelected
                                  ? AppColors.yellow
                                  : AppColors.white.withValues(alpha: 0.6),
                              size: size * 0.5,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: AppColors.gray,
                            alignment: Alignment.center,
                            child: const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.yellow,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Text(
          avatarLabel,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
