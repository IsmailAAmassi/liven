import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/otp_code_input.dart';
import '../../../l10n/app_localizations.dart';
import 'auth_view_model.dart';

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

  void _submit() {
    if ((_formKey.currentState?.validate() ?? false) && _code.length == 6) {
      ref.read(authViewModelProvider.notifier).verifyOtp(_code, widget.args);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);
    final isRegisterFlow = widget.args.flowType == OtpFlowType.register;
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
                AppText(
                  isRegisterFlow
                      ? l10n.otpRegisterMessage(widget.args.identifier)
                      : l10n.otpResetMessage(widget.args.identifier),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                AppText(
                  l10n.otpEnterCodeMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                OtpCodeInput(
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
                const Spacer(),
                AppButton(
                  label: l10n.verifyButton,
                  onPressed: _submit,
                  isLoading: state.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
