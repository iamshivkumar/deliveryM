import 'providers/auth_provider.dart';
import '../components/progress_loader.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/labels.dart';
import '../../root.dart';
import 'utils/auth_message.dart';

class VerifyPage extends HookConsumerWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    BoxDecoration _pinPutDecoration() {
      return BoxDecoration(
        border: Border.all(color: Colors.indigoAccent),
        borderRadius: BorderRadius.circular(8),
      );
    }

    final controller = useTextEditingController();
    final model = ref.watch(authProvider);
    controller.addListener(() {
      model.code = controller.text;
    });
    return ProgressLoader(
      isLoading: model.loading,
      child: Scaffold(
        body: Padding(
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
                        Labels.verifyOTP,
                        style: style.headline6,
                      ),
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Labels.otpSentTo(model.phone),
                            style: style.subtitle1,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            child: const Text(Labels.changeNumber),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: PinPut(
                              onTap: () =>
                                  model.authMessage = AuthMessage.empty(),
                              controller: controller,
                              fieldsCount: 6,
                              submittedFieldDecoration:
                                  _pinPutDecoration().copyWith(
                                border: Border.all(
                                  color: Colors.green,
                                ),
                              ),
                              selectedFieldDecoration: _pinPutDecoration(),
                              followingFieldDecoration:
                                  _pinPutDecoration().copyWith(
                                border: model.authMessage.color == Colors.red
                                    ? Border.all(
                                        color: Colors.red,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: StreamBuilder<int>(
                                initialData: 30,
                                stream: model.stream,
                                builder: (context, snapshot) {
                                  return IconButton(
                                    disabledColor: style.overline!.color,
                                    color: theme.primaryColor,
                                    onPressed: snapshot.data! <= 00
                                        ? () => model.sendOTP()
                                        : null,
                                    icon: Column(
                                      children: [
                                        const Icon(Icons.restart_alt),
                                        Text(
                                          snapshot.data! <= 0
                                              ? "0:00"
                                              : "0:${snapshot.data}",
                                          style: style.overline!.copyWith(
                                            fontSize: 6,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        model.authMessage.text,
                        style: TextStyle(
                          color: model.authMessage.color,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                child: const Text(Labels.verify),
                onPressed: model.code.length == 6
                    ? () {
                        model.verifyOTP(
                            clear: controller.clear);
                      }
                    : null,
              ),
              const SizedBox(height: 24)
            ],
          ),
        ),
      ),
    );
  }
}
