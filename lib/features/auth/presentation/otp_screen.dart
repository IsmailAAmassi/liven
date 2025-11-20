import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/otp_code_input.dart';
import '../../../l10n/app_localizations.dart';
import 'auth_view_model.dart';
import 'otp_view_model.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.args});

  static const routePath = '/otp';
  static const routeName = 'otp';

  final OtpScreenArgs args;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _code = '';
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.args.phone);
    _phoneController.addListener(() {
      ref.read(otpViewModelProvider(widget.args).notifier).updatePhone(_phoneController.text.trim());
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if ((_formKey.currentState?.validate() ?? false) && _code.length == 4) {
      ref.read(otpViewModelProvider(widget.args).notifier).verifyOtp(_code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(otpViewModelProvider(widget.args));
    final isRegisterFlow = widget.args.flowType == OtpFlow.register;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: AppText(
          l10n.otpAppBar,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: l10n.fieldPhone,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.validationPhone;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AppText(
                  isRegisterFlow
                      ? l10n.otpRegisterMessage(state.phone)
                      : l10n.otpResetMessage(state.phone),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                AppText(
                  l10n.otpEnterCodeMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                OtpCodeInput(
                  length: 4,
                  onChanged: (value) => setState(() => _code = value),
                  onCompleted: (value) {
                    setState(() => _code = value);
                    _submit();
                  },
                ),
                if (state.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
                if (state.successMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    state.successMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    TextButton(
                      onPressed: state.canResend
                          ? () => ref.read(otpViewModelProvider(widget.args).notifier).resendOtp()
                          : null,
                      child: state.secondsRemaining > 0
                          ? Text(l10n.otpResendInXSeconds(state.secondsRemaining))
                          : Text(l10n.sendOtpButton),
                    ),
                    if (state.isResending) ...[
                      const SizedBox(width: 8),
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ],
                  ],
                ),
                const Spacer(),
                AppButton(
                  label: l10n.verifyButton,
                  onPressed: _submit,
                  isLoading: state.isVerifying,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
