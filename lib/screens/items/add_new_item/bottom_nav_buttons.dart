import 'package:flutter/material.dart';
import 'package:sharing_map/utils/colors.dart';

class BottomNavButtons extends StatelessWidget {
  final int selectedIndex;
  final PageController pageController;
  final bool isLoading;
  final GlobalKey<FormState> formKey;
  final Future<bool> Function() onSubmit;

  /// Called when you need the parent to rebuild. Only used on submit here
  /// to toggle loading. We avoid calling this during navigation.
  final VoidCallback onStateChanged;

  /// Configurable last page index (instead of hardcoding 4).
  final int lastPageIndex;

  const BottomNavButtons({
    Key? key,
    required this.selectedIndex,
    required this.pageController,
    required this.isLoading,
    required this.formKey,
    required this.onSubmit,
    required this.onStateChanged,
    this.lastPageIndex = 4,
  }) : super(key: key);

  bool get _showNav => selectedIndex > 0;
  bool get _isOnLastPage => selectedIndex == lastPageIndex;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(8, 8, 8, 20),
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              const Spacer(),
              if (_showNav)
                _CircleActionButton(
                  isLoading: false, // Never loading on back
                  icon: Icons.arrow_back,
                  onPressed: _handleBack,
                ),
              const Spacer(flex: 5),
              if (_showNav)
                _CircleActionButton(
                  // Show loading only when user tapped on last page
                  isLoading: _isOnLastPage && isLoading,
                  // Always show forward arrow, even on last page
                  icon: !_isOnLastPage
                      ? Icons.arrow_forward_rounded
                      : Icons.check_rounded,
                  onPressed: _isOnLastPage ? _handleSubmit : _handleNext,
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBack() {
    if (selectedIndex > 0 && pageController.hasClients) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
    // Do NOT toggle loading here.
    // If you need to update selectedIndex, rely on PageView.onPageChanged in parent.
  }

  void _handleNext() {
    final formState = formKey.currentState;
    if (formState?.validate() ?? false) {
      formState?.save();
      if (pageController.hasClients) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    }
    // Do NOT toggle loading here.
  }

  Future<void> _handleSubmit() async {
    if (isLoading) return;

    // Start loading only on explicit tap on last page
    onStateChanged(); // parent should set isLoading = true
    try {
      final formState = formKey.currentState;
      if (formState?.validate() ?? false) {
        final ok = await onSubmit();
        if (ok && pageController.hasClients) {
          // Optional: jump back to first page after success
          await Future.delayed(const Duration(microseconds: 100));
          pageController.jumpToPage(0);
        }
      }
    } catch (e) {
      debugPrint('BottomNavButtons submit error: $e');
    } finally {
      onStateChanged(); // parent should set isLoading = false
    }
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _CircleActionButton({
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: MColors.green,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: isLoading
                ? const SizedBox(
                    key: ValueKey('loader'),
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(MColors.white),
                    ),
                  )
                : IconButton(
                    key: const ValueKey('icon'),
                    onPressed: onPressed,
                    icon: Icon(
                      icon,
                      color: MColors.white,
                      // weight: 1200, // uncomment if using variable icons
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
