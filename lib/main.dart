import 'package:finease/app.dart';
import 'package:finease/db/settings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void main() {
  final Settings settings = {};
  runApp(MainApp(settings: settings));
}
