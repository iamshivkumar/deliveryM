import 'package:delivery_m/ui/auth/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userProvider = StreamProvider<User?>(
  (ref) => ref.read(authProvider).userStream,
);
