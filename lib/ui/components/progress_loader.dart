import 'package:flutter/material.dart';

class ProgressLoader extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  const ProgressLoader({Key? key, required this.child, this.isLoading = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        isLoading
            ? Container(
                color: const Color(0xFFa7a7a7).withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
