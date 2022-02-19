import 'package:delivery_m/ui/colors.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/auth_provider.dart';

class AuthPage extends HookConsumerWidget {
 const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final scheme = theme.colorScheme;
    final dark = ThemeData.dark();

    final model = ref.watch(authProvider);
    final controller = useTextEditingController();

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Theme(
        data: dark.copyWith(
          colorScheme: dark.colorScheme.copyWith(
            primary: Palette.secondary,
            // secondary: Palette.secondary,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              shape: theme.elevatedButtonTheme.style!.shape,
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Continue with Phone',
                style: style.headline5!.copyWith(
                  color: scheme.secondary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: !model.loading,
                      // initialValue: model.phone,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: "+91 ",
                        labelText: "Phone",
                      ),
                      onChanged: (v) {
                        model.phone = v;
                        controller.clear();
                      },
                      inputFormatters: [model.formater],
                    ),
                  ),
                  SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: model.phoneLoading
                          ? null
                          : () {
                              model.sendOTP();
                            },
                      child: model.phoneLoading
                          ? const SizedBox(
                              child: CircularProgressIndicator(),
                              height: 24,
                              width: 24,
                            )
                          :  Text(model.resendToken!=null?"RESEND":'SEND OTP'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller,
                enabled: !model.loading&& model.verificationId != null,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: "OTP",
                ),
                onChanged: (v) {
                  model.code = v.split(' ').join();
                },
                inputFormatters: [
                  model.otpformater
                ],
              ),
              const SizedBox(height: 32),
             model.loading?const Loading(): ElevatedButton(
                onPressed:
                    model.verificationId != null && model.code.length == 6
                        ? () {
                          model.verifyOTP(clear: controller.clear);
                        }
                        : null,
                child: Text(
                  'VERIFY',
                  style: style.button,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
