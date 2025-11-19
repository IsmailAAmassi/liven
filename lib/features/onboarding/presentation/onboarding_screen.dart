import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_enums.dart';
import '../../../core/config/app_providers.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../../../l10n/app_localizations.dart';
import 'onboarding_view_model.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  static const routePath = '/onboarding';
  static const routeName = 'onboarding';

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingViewModelProvider);
    final viewModel = ref.read(onboardingViewModelProvider.notifier);
    final pages = viewModel.pages;
    final currentPage = pages[state.pageIndex];
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: currentPage.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: viewModel.skip,
                child: Text(l10n.generalSkip),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: viewModel.setPage,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  switch (page.type) {
                    case OnboardingPageType.language:
                      return _buildLanguageStep(l10n);
                    case OnboardingPageType.theme:
                      return _buildThemeStep(l10n);
                    case OnboardingPageType.content:
                      return _buildContentStep(page.data!, l10n);
                  }
                },
              ),
            ),
            _Indicators(count: pages.length, index: state.pageIndex),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: AppButton(
                label: state.pageIndex == pages.length - 1
                    ? l10n.generalGetStarted
                    : l10n.generalNext,
                onPressed: () {
                  if (state.pageIndex == pages.length - 1) {
                    viewModel.complete();
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
}

  Widget _buildLanguageStep(AppLocalizations l10n) {
    final locale = ref.watch(localeProvider);
    final selected = AppLanguageX.fromLocale(locale);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            l10n.onboardingLanguageTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          AppText(
            l10n.onboardingLanguageSubtitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: AppLanguage.values.map((language) {
              final isSelected = language == selected;
              return _SelectableOptionCard(
                onTap: () =>
                    ref.read(localeProvider.notifier).setLocale(language.locale),
                title: language.label(l10n),
                leading: Text(language.flag, style: const TextStyle(fontSize: 28)),
                selected: isSelected,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeStep(AppLocalizations l10n) {
    final themeMode = ref.watch(themeModeProvider);
    final selected = ThemePreferenceX.fromThemeMode(themeMode);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            l10n.onboardingThemeTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          AppText(
            l10n.onboardingThemeSubtitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: ThemePreference.values.map((preference) {
              final isSelected = preference == selected;
              return _SelectableOptionCard(
                onTap: () =>
                    ref.read(themeModeProvider.notifier).setTheme(preference.mode),
                title: preference.label(l10n),
                subtitle: preference.description(l10n),
                icon: preference.icon,
                selected: isSelected,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContentStep(OnboardingPageData data, AppLocalizations l10n) {
    final title = data.titleBuilder(l10n);
    final description = data.descriptionBuilder(l10n);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: CircleAvatar(
                radius: 120,
                backgroundColor: data.featureColor.withOpacity(0.15),
                child: Icon(
                  data.icon,
                  size: 96,
                  color: data.featureColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          AppText(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppText(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

class _Indicators extends StatelessWidget {
  const _Indicators({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 8,
          width: isActive ? 32 : 12,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
        );
      }),
    );
  }
}

class _SelectableOptionCard extends StatelessWidget {
  const _SelectableOptionCard({
    required this.onTap,
    required this.title,
    this.subtitle,
    this.icon,
    this.leading,
    required this.selected,
  });

  final VoidCallback onTap;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? leading;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final availableWidth = MediaQuery.of(context).size.width;
    final calculatedWidth = availableWidth / 2 - 32;
    final width = calculatedWidth.clamp(140.0, availableWidth);
    return SizedBox(
      width: width,
      child: Material(
        color: selected
            ? colorScheme.primary.withOpacity(0.1)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leading ?? Icon(icon, color: colorScheme.primary),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: colorScheme.outline),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
