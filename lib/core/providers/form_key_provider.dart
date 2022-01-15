import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final formKeyProvider = Provider((ref)=>GlobalKey<FormState>() );