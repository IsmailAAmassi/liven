import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../main/presentation/main_screen.dart';
import '../application/profile_completion_guard.dart';
import 'complete_profile_view_model.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  static const routePath = '/complete-profile';
  static const routeName = 'completeProfile';

  @override
  ConsumerState<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _lengthController = TextEditingController();
  final _weightController = TextEditingController();
  String? _gender;
  Map<String, String> _localErrors = const {};

  bool get _isRequired => AppConfig.completeProfileRequired;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(profileCompletionGuardProvider).markPrompted());
  }

  @override
  void dispose() {
    _ageController.dispose();
    _lengthController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(completeProfileViewModelProvider);
    final localeCode = Localizations.localeOf(context).languageCode;
    final maleLabel = localeCode == 'ar' ? 'ذكر' : 'Male';
    final femaleLabel = localeCode == 'ar' ? 'أنثى' : 'Female';

    String? fieldError(String key) {
      return _localErrors[key] ?? state.fieldErrors[key];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.completeProfileTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.completeProfileDescription,
                  style: Theme.of(context).textTheme.bodyLarge),
              if (_isRequired) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.completeProfileRequiredNotice,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 24),
              if (state.errorMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    state.errorMessage!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.ageLabel,
                        errorText: fieldError('age'),
                      ),
                      enabled: !state.isLoading,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: InputDecoration(
                        labelText: l10n.genderLabel,
                        errorText: fieldError('gender'),
                      ),
                      items: [
                        DropdownMenuItem(value: 'm', child: Text(maleLabel)),
                        DropdownMenuItem(value: 'f', child: Text(femaleLabel)),
                      ],
                      onChanged: state.isLoading ? null : (value) => setState(() => _gender = value),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _lengthController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.lengthLabel,
                        errorText: fieldError('length'),
                      ),
                      enabled: !state.isLoading,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.weightLabel,
                        errorText: fieldError('weight'),
                      ),
                      enabled: !state.isLoading,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onPressed: state.isLoading ? null : () => _submit(context),
                      label: l10n.completeProfileSaveButton,
                      isLoading: state.isLoading,
                    ),
                  ),
                ],
              ),
              if (!_isRequired) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: state.isLoading ? null : _skip,
                  child: Text(l10n.completeProfileSkipButton),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final errors = <String, String>{};

    final age = int.tryParse(_ageController.text.trim());
    if (age == null) {
      errors['age'] = l10n.ageRequiredError;
    } else if (age < 10 || age > 100) {
      errors['age'] = l10n.ageInvalidError;
    }

    final gender = _gender;
    if (gender == null || gender.isEmpty) {
      errors['gender'] = l10n.genderRequiredError;
    }

    final length = int.tryParse(_lengthController.text.trim());
    if (length == null) {
      errors['length'] = l10n.lengthRequiredError;
    } else if (length < 100 || length > 250) {
      errors['length'] = l10n.lengthInvalidError;
    }

    final weight = int.tryParse(_weightController.text.trim());
    if (weight == null) {
      errors['weight'] = l10n.weightRequiredError;
    } else if (weight < 20 || weight > 300) {
      errors['weight'] = l10n.weightInvalidError;
    }

    setState(() {
      _localErrors = errors;
    });

    if (errors.isNotEmpty) return;

    await ref.read(completeProfileViewModelProvider.notifier).submit(
          age: age!,
          gender: gender!,
          length: length!,
          weight: weight!,
        );
  }

  Future<void> _skip() async {
    await ref.read(profileCompletionGuardProvider).markPrompted();
    ref.read(appRouterProvider).go(MainScreen.routePath);
  }
}
