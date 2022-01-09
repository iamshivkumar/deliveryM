import 'package:delivery_m/ui/auth/providers/auth_provider.dart';
import 'package:delivery_m/ui/components/progress_loader.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/labels.dart';
import '../../root.dart';
import 'verify_page.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final model = ref.watch(authProvider);
    return Scaffold(
      body: ProgressLoader(
        isLoading: model.loading,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Labels.signupOrLogin,
                        style: style.headline6,
                      ),
                      SizedBox(height: 48),
                      Text(
                        Labels.enterYourMobileNumber,
                        style: style.subtitle1,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        initialValue: model.phone,
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        onChanged: (v) => model.phone = v,
                        textAlign: TextAlign.center,
                       
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                child: Text('CONTINUE'),
                onPressed: model.phone.length == 10
                    ? () => model.sendOTP(
                          onComplete: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Root(),
                              ),
                              (route) => false,
                            );
                           
                          },
                          onSend: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerifyPage(),
                            ),
                          ),
                        )
                    : null,
              ),
              SizedBox(height: 24)
            ],
          ),
        ),
      ),
    );
  }
}
